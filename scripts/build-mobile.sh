#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
MOBILE_DIR="${REPO_ROOT}/mobile"

TARGET="all"
BUILD_MODE="debug"
SKIP_TESTS="false"
TARGET_SET="false"
OS_KIND="unknown"
RUN_ANDROID="false"
RUN_IOS="false"
GENERATED_ANDROID_DEBUG="false"
GENERATED_ANDROID_RELEASE="false"
GENERATED_IOS_DEBUG="false"
GENERATED_IOS_RELEASE="false"

log_info() {
  echo "[INFO] $*"
}

log_success() {
  echo "[OK] $*"
}

log_warn() {
  echo "[WARN] $*"
}

log_error() {
  echo "[ERROR] $*" >&2
}

on_error() {
  local exit_code=$?
  local failed_command="${BASH_COMMAND}"
  local line_number="${BASH_LINENO[0]:-unknown}"

  log_error "Command failed: ${failed_command}"
  log_error "Line number: ${line_number}"
  log_error "Exit code: ${exit_code}"
  log_error "Suggested next step: Fix the reported issue above and rerun the same command, or run ./scripts/build-mobile.sh --help."

  exit "${exit_code}"
}
trap on_error ERR

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/build-mobile.sh
  ./scripts/build-mobile.sh all
  ./scripts/build-mobile.sh android
  ./scripts/build-mobile.sh ios
  ./scripts/build-mobile.sh android --debug
  ./scripts/build-mobile.sh android --release
  ./scripts/build-mobile.sh ios --debug
  ./scripts/build-mobile.sh ios --release
  ./scripts/build-mobile.sh all --release
  ./scripts/build-mobile.sh android --skip-tests
  ./scripts/build-mobile.sh --help

Options:
  all            Build all supported platforms for the current OS (default)
  android        Build Android only
  ios            Build iOS only
  --debug        Build debug artifacts (default)
  --release      Build release artifacts
  --skip-tests   Skip flutter test
  -h, --help     Show this help message
EOF
}

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    log_error "Required command not found: ${command_name}"
    exit 1
  fi
}

run_step() {
  local title="$1"
  shift
  log_info "${title}"
  "$@"
  log_success "${title}"
}

detect_os() {
  local uname_value
  uname_value="$(uname -s 2>/dev/null || true)"

  case "${uname_value}" in
    Darwin)
      OS_KIND="macos"
      ;;
    Linux)
      OS_KIND="linux"
      ;;
    MINGW*|MSYS*|CYGWIN*|Windows_NT)
      OS_KIND="windows"
      ;;
    *)
      OS_KIND="unknown"
      ;;
  esac
}

validate_project() {
  require_command flutter
  require_command dart

  run_step "Flutter version check" flutter --version

  if [[ ! -d "${MOBILE_DIR}" ]]; then
    log_error "Mobile directory not found: ${MOBILE_DIR}"
    exit 1
  fi

  cd "${MOBILE_DIR}"

  run_step "Running flutter pub get" flutter pub get
  run_step "Running build_runner" dart run build_runner build --delete-conflicting-outputs
  run_step "Running flutter analyze" flutter analyze

  if [[ "${SKIP_TESTS}" == "true" ]]; then
    log_warn "Skipping flutter test because --skip-tests was provided."
  else
    run_step "Running flutter test" flutter test
  fi
}

flutter_config_android_sdk_path() {
  local line path
  line="$(flutter config --list 2>/dev/null | grep -E '^android-sdk\s*=\s*' || true)"
  path="${line#*=}"
  path="${path%\"}"
  path="${path#\"}"
  path="$(echo "${path}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  echo "${path}"
}

is_valid_android_sdk_dir() {
  local candidate="$1"
  if [[ -z "${candidate}" || ! -d "${candidate}" ]]; then
    return 1
  fi

  if [[ -d "${candidate}/platform-tools" || -d "${candidate}/cmdline-tools" || -d "${candidate}/platforms" ]]; then
    return 0
  fi

  return 1
}

prepend_path_if_dir() {
  local path_dir="$1"
  if [[ -d "${path_dir}" ]]; then
    case ":${PATH}:" in
      *":${path_dir}:"*)
        ;;
      *)
        PATH="${path_dir}:${PATH}"
        ;;
    esac
  fi
}

resolve_android_sdk_path() {
  local sdk_from_config=""
  sdk_from_config="$(flutter_config_android_sdk_path)"

  if is_valid_android_sdk_dir "${ANDROID_HOME:-}"; then
    echo "${ANDROID_HOME}"
    return 0
  fi

  if is_valid_android_sdk_dir "${ANDROID_SDK_ROOT:-}"; then
    echo "${ANDROID_SDK_ROOT}"
    return 0
  fi

  if is_valid_android_sdk_dir "${sdk_from_config}"; then
    echo "${sdk_from_config}"
    return 0
  fi

  if is_valid_android_sdk_dir "${HOME}/Android/Sdk"; then
    echo "${HOME}/Android/Sdk"
    return 0
  fi

  if is_valid_android_sdk_dir "/opt/android-sdk"; then
    echo "/opt/android-sdk"
    return 0
  fi

  echo ""
}

preflight_android() {
  local doctor_output sdk_path sdk_from_config

  sdk_from_config="$(flutter_config_android_sdk_path)"
  sdk_path="$(resolve_android_sdk_path)"

  if [[ -z "${sdk_path}" ]]; then
    log_error "No valid Android SDK path found."
    log_error "Next steps:"
    log_error "1) Run: flutter doctor"
    log_error "2) Install Android command-line tools"
    log_error "3) Set: export ANDROID_HOME=\"$HOME/Android/Sdk\""
    log_error "4) Set: export ANDROID_SDK_ROOT=\"\$ANDROID_HOME\""
    log_error "5) Run: flutter config --android-sdk \"\$ANDROID_HOME\""
    exit 1
  fi

  export ANDROID_HOME="${sdk_path}"
  export ANDROID_SDK_ROOT="${sdk_path}"

  prepend_path_if_dir "${ANDROID_HOME}/cmdline-tools/latest/bin"
  prepend_path_if_dir "${ANDROID_HOME}/platform-tools"
  prepend_path_if_dir "${ANDROID_HOME}/emulator"

  if ! is_valid_android_sdk_dir "${sdk_from_config}"; then
    run_step "Configuring Flutter Android SDK path" flutter config --android-sdk "${ANDROID_HOME}"
  fi

  log_info "Android SDK path: ${ANDROID_HOME}"

  doctor_output="$(flutter doctor 2>&1 || true)"

  if echo "${doctor_output}" | grep -q "No Android SDK found"; then
    log_error "Android SDK still not detected by Flutter after configuring this process environment."
    log_error "Next steps:"
    log_error "1) Run: flutter doctor"
    log_error "2) Verify SDK path exists and contains cmdline-tools/platform-tools/platforms"
    log_error "3) Run: flutter config --android-sdk \"\$ANDROID_HOME\""
    exit 1
  fi

  log_success "Android preflight checks passed."
}

preflight_ios() {
  if [[ "${OS_KIND}" != "macos" ]]; then
    if [[ "${TARGET}" == "ios" ]]; then
      log_error "iOS builds require macOS with Xcode."
      exit 1
    fi

    log_warn "Skipping iOS build: iOS builds require macOS and Xcode."
    RUN_IOS="false"
    return
  fi

  require_command xcodebuild
  run_step "Checking Xcode" xcodebuild -version

  if ! command -v pod >/dev/null 2>&1; then
    log_warn "CocoaPods not found (pod). iOS builds may fail if pods are required."
  else
    run_step "Checking CocoaPods" pod --version
  fi

  log_success "iOS preflight checks passed."
}

build_android() {
  local artifact

  if [[ "${BUILD_MODE}" == "release" ]]; then
    run_step "Building Android release APK" flutter build apk --release
    artifact="${MOBILE_DIR}/build/app/outputs/flutter-apk/app-release.apk"
    if [[ ! -f "${artifact}" ]]; then
      log_error "Expected Android release APK not found: ${artifact}"
      exit 1
    fi
    log_success "Android release APK generated: mobile/build/app/outputs/flutter-apk/app-release.apk"
    GENERATED_ANDROID_RELEASE="true"
  else
    run_step "Building Android debug APK" flutter build apk --debug
    artifact="${MOBILE_DIR}/build/app/outputs/flutter-apk/app-debug.apk"
    if [[ ! -f "${artifact}" ]]; then
      log_error "Expected Android debug APK not found: ${artifact}"
      exit 1
    fi
    log_success "Android debug APK generated: mobile/build/app/outputs/flutter-apk/app-debug.apk"
    GENERATED_ANDROID_DEBUG="true"
  fi
}

build_ios() {
  local artifact

  if [[ "${BUILD_MODE}" == "release" ]]; then
    run_step "Building iOS release IPA" flutter build ipa
    artifact="${MOBILE_DIR}/build/ios/ipa"
    if [[ ! -d "${artifact}" ]]; then
      log_error "Expected iOS release output directory not found: ${artifact}"
      exit 1
    fi
    log_success "iOS release output generated: mobile/build/ios/ipa"
    GENERATED_IOS_RELEASE="true"
  else
    run_step "Building iOS debug artifact" flutter build ios --debug --no-codesign
    artifact="${MOBILE_DIR}/build/ios"
    if [[ ! -d "${artifact}" ]]; then
      log_error "Expected iOS debug output directory not found: ${artifact}"
      exit 1
    fi
    log_success "iOS debug output generated: mobile/build/ios"
    GENERATED_IOS_DEBUG="true"
  fi
}

parse_args() {
  local arg
  for arg in "$@"; do
    case "${arg}" in
      all|android|ios)
        if [[ "${TARGET_SET}" == "true" ]]; then
          log_error "Multiple platform targets provided. Use one of: all, android, ios."
          print_usage
          exit 1
        fi
        TARGET="${arg}"
        TARGET_SET="true"
        ;;
      --debug)
        BUILD_MODE="debug"
        ;;
      --release)
        BUILD_MODE="release"
        ;;
      --skip-tests)
        SKIP_TESTS="true"
        ;;
      -h|--help)
        print_usage
        exit 0
        ;;
      *)
        log_error "Unknown argument: ${arg}"
        print_usage
        exit 1
        ;;
    esac
  done
}

configure_targets() {
  case "${TARGET}" in
    android)
      RUN_ANDROID="true"
      RUN_IOS="false"
      ;;
    ios)
      RUN_ANDROID="false"
      RUN_IOS="true"
      ;;
    all)
      RUN_ANDROID="true"
      RUN_IOS="true"
      ;;
    *)
      log_error "Unsupported target: ${TARGET}"
      exit 1
      ;;
  esac

  if [[ "${OS_KIND}" == "linux" || "${OS_KIND}" == "windows" || "${OS_KIND}" == "unknown" ]]; then
    if [[ "${TARGET}" == "ios" ]]; then
      log_error "iOS builds require macOS with Xcode."
      exit 1
    fi
    if [[ "${RUN_IOS}" == "true" ]]; then
      log_warn "Skipping iOS build: iOS builds require macOS and Xcode."
      RUN_IOS="false"
    fi
  fi

  if [[ "${RUN_ANDROID}" != "true" && "${RUN_IOS}" != "true" ]]; then
    log_error "No supported build targets remain for this OS and selected options."
    exit 1
  fi
}

main() {
  parse_args "$@"
  detect_os
  configure_targets

  validate_project

  if [[ "${RUN_ANDROID}" == "true" ]]; then
    preflight_android
    build_android
  fi

  if [[ "${RUN_IOS}" == "true" ]]; then
    preflight_ios
    if [[ "${RUN_IOS}" == "true" ]]; then
      build_ios
    fi
  fi

  echo
  log_success "Build flow completed."
  if [[ "${GENERATED_ANDROID_DEBUG}" == "true" ]]; then
    echo "Android debug APK: mobile/build/app/outputs/flutter-apk/app-debug.apk"
  fi
  if [[ "${GENERATED_ANDROID_RELEASE}" == "true" ]]; then
    echo "Android release APK: mobile/build/app/outputs/flutter-apk/app-release.apk"
  fi
  if [[ "${GENERATED_IOS_DEBUG}" == "true" ]]; then
    echo "iOS debug output: mobile/build/ios"
  fi
  if [[ "${GENERATED_IOS_RELEASE}" == "true" ]]; then
    echo "iOS release IPA directory: mobile/build/ios/ipa"
  fi
}

main "$@"
