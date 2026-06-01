#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
MOBILE_DIR="${REPO_ROOT}/mobile"

TARGET=""
TARGET_SET="false"
DEBUG_ONLY="false"
RELEASE_ONLY="false"
BUILD_DEBUG="true"
BUILD_RELEASE="true"
SKIP_TESTS="false"
SKIP_FORMAT="false"
APPLY_FIXES="false"
OS_KIND="unknown"
FORMAT_MAY_HAVE_MODIFIED="false"
FIXES_REQUESTED="false"

GENERATED_ANDROID_DEBUG="false"
GENERATED_ANDROID_RELEASE="false"
GENERATED_IOS_DEBUG="false"
GENERATED_IOS_RELEASE="false"

declare -a GENERATED_ARTIFACTS=()

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
  ./scripts/build-mobile.sh android
  ./scripts/build-mobile.sh ios
  ./scripts/build-mobile.sh android --debug-only
  ./scripts/build-mobile.sh android --release-only
  ./scripts/build-mobile.sh ios --debug-only
  ./scripts/build-mobile.sh ios --release-only
  ./scripts/build-mobile.sh android --skip-tests
  ./scripts/build-mobile.sh android --skip-format
  ./scripts/build-mobile.sh android --apply-fixes
  ./scripts/build-mobile.sh --help

Options:
  android         Build Android artifacts only
  ios             Build iOS artifacts only
  --debug-only    Build debug artifacts only
  --release-only  Build release artifacts only
  --skip-tests    Skip flutter test
  --skip-format   Skip dart format lib test
  --apply-fixes   Run dart fix --apply before analyze/test/build
  -h, --help      Show this help message

Default build mode behavior:
  If no mode flag is provided, the script builds BOTH debug and release
  artifacts for the selected platform.
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

parse_args() {
  local arg
  for arg in "$@"; do
    case "${arg}" in
      android|ios)
        if [[ "${TARGET_SET}" == "true" ]]; then
          log_error "Multiple platform targets provided. Use one of: android, ios."
          print_usage
          exit 1
        fi
        TARGET="${arg}"
        TARGET_SET="true"
        ;;
      --debug-only)
        if [[ "${RELEASE_ONLY}" == "true" ]]; then
          log_error "Do not use --debug-only and --release-only together."
          exit 1
        fi
        DEBUG_ONLY="true"
        ;;
      --release-only)
        if [[ "${DEBUG_ONLY}" == "true" ]]; then
          log_error "Do not use --debug-only and --release-only together."
          exit 1
        fi
        RELEASE_ONLY="true"
        ;;
      --skip-tests)
        SKIP_TESTS="true"
        ;;
      --skip-format)
        SKIP_FORMAT="true"
        ;;
      --apply-fixes)
        APPLY_FIXES="true"
        FIXES_REQUESTED="true"
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

  if [[ "${TARGET_SET}" != "true" ]]; then
    log_error "Please specify a platform: android or ios."
    print_usage
    exit 1
  fi

  if [[ "${DEBUG_ONLY}" == "true" ]]; then
    BUILD_DEBUG="true"
    BUILD_RELEASE="false"
  elif [[ "${RELEASE_ONLY}" == "true" ]]; then
    BUILD_DEBUG="false"
    BUILD_RELEASE="true"
  else
    BUILD_DEBUG="true"
    BUILD_RELEASE="true"
  fi
}

validate_platform_target() {
  if [[ "${TARGET}" == "ios" && "${OS_KIND}" != "macos" ]]; then
    log_error "iOS builds require macOS and Xcode."
    exit 1
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
    log_error "Checked in order: ANDROID_HOME, ANDROID_SDK_ROOT, flutter config android-sdk, \$HOME/Android/Sdk, /opt/android-sdk"
    log_error "Install Android SDK/command-line tools and rerun."
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
    exit 1
  fi

  log_success "Android preflight checks passed."
}

preflight_ios() {
  if [[ "${OS_KIND}" != "macos" ]]; then
    log_error "iOS builds require macOS and Xcode."
    exit 1
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

validate_project() {
  local format_check_exit=0

  require_command flutter
  require_command dart

  if [[ ! -d "${MOBILE_DIR}" ]]; then
    log_error "Mobile directory not found: ${MOBILE_DIR}"
    exit 1
  fi

  cd "${MOBILE_DIR}"

  run_step "Flutter version check" flutter --version
  run_step "Running flutter pub get" flutter pub get
  run_step "Running build_runner" dart run build_runner build --delete-conflicting-outputs

  if [[ "${SKIP_FORMAT}" == "true" ]]; then
    log_warn "Skipping dart format because --skip-format was provided."
  else
    log_info "Checking if dart format would modify files"
    trap - ERR
    set +e
    dart format --output=none --set-exit-if-changed lib test >/dev/null 2>&1
    format_check_exit=$?
    set -e
    trap on_error ERR

    run_step "Running dart format lib test" dart format lib test

    if [[ ${format_check_exit} -ne 0 ]]; then
      FORMAT_MAY_HAVE_MODIFIED="true"
      log_warn "Formatting may have modified files. Review git diff before committing."
    fi
  fi

  if [[ "${APPLY_FIXES}" == "true" ]]; then
    run_step "Running dart fix --apply" dart fix --apply
  fi

  run_step "Running flutter analyze" flutter analyze

  if [[ "${SKIP_TESTS}" == "true" ]]; then
    log_warn "Skipping flutter test because --skip-tests was provided."
  else
    run_step "Running flutter test" flutter test
  fi
}

build_android() {
  local artifact

  if [[ "${BUILD_DEBUG}" == "true" ]]; then
    run_step "Building Android debug APK" flutter build apk --debug
    artifact="${MOBILE_DIR}/build/app/outputs/flutter-apk/app-debug.apk"
    if [[ ! -f "${artifact}" ]]; then
      log_error "Expected Android debug APK not found: ${artifact}"
      exit 1
    fi
    GENERATED_ANDROID_DEBUG="true"
    GENERATED_ARTIFACTS+=("mobile/build/app/outputs/flutter-apk/app-debug.apk")
    log_success "Android debug APK generated: mobile/build/app/outputs/flutter-apk/app-debug.apk"
  fi

  if [[ "${BUILD_RELEASE}" == "true" ]]; then
    run_step "Building Android release APK" flutter build apk --release
    artifact="${MOBILE_DIR}/build/app/outputs/flutter-apk/app-release.apk"
    if [[ ! -f "${artifact}" ]]; then
      log_error "Expected Android release APK not found: ${artifact}"
      exit 1
    fi
    GENERATED_ANDROID_RELEASE="true"
    GENERATED_ARTIFACTS+=("mobile/build/app/outputs/flutter-apk/app-release.apk")
    log_success "Android release APK generated: mobile/build/app/outputs/flutter-apk/app-release.apk"
  fi
}

build_ios() {
  local artifact

  if [[ "${BUILD_DEBUG}" == "true" ]]; then
    run_step "Building iOS debug artifact" flutter build ios --debug --no-codesign
    artifact="${MOBILE_DIR}/build/ios"
    if [[ ! -d "${artifact}" ]]; then
      log_error "Expected iOS debug output directory not found: ${artifact}"
      exit 1
    fi
    GENERATED_IOS_DEBUG="true"
    GENERATED_ARTIFACTS+=("mobile/build/ios")
    log_success "iOS debug output generated: mobile/build/ios"
  fi

  if [[ "${BUILD_RELEASE}" == "true" ]]; then
    run_step "Building iOS release IPA" flutter build ipa
    artifact="${MOBILE_DIR}/build/ios/ipa"
    if [[ ! -d "${artifact}" ]]; then
      log_error "Expected iOS release output directory not found: ${artifact}"
      exit 1
    fi
    GENERATED_IOS_RELEASE="true"
    GENERATED_ARTIFACTS+=("mobile/build/ios/ipa")
    log_success "iOS release output generated: mobile/build/ios/ipa"
  fi
}

print_artifacts_summary() {
  local artifact

  echo
  log_success "Build flow completed."
  if [[ ${#GENERATED_ARTIFACTS[@]} -eq 0 ]]; then
    log_error "No artifacts were generated."
    exit 1
  fi

  echo "Generated artifacts:"
  for artifact in "${GENERATED_ARTIFACTS[@]}"; do
    echo "- ${artifact}"
  done

  echo
  echo "Review git diff if format or dart fix changed files."
}

main() {
  parse_args "$@"
  detect_os
  validate_platform_target

  validate_project

  if [[ "${TARGET}" == "android" ]]; then
    if [[ "${OS_KIND}" == "linux" || "${OS_KIND}" == "windows" || "${OS_KIND}" == "macos" || "${OS_KIND}" == "unknown" ]]; then
      preflight_android
      build_android
    fi
  elif [[ "${TARGET}" == "ios" ]]; then
    preflight_ios
    build_ios
  else
    log_error "Unsupported target: ${TARGET}"
    exit 1
  fi

  print_artifacts_summary
}

main "$@"
