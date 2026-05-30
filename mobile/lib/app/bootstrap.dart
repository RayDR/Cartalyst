import 'package:cartalyst_mobile/app/app.dart';
import 'package:cartalyst_mobile/core/debug/debug_diagnostics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    _installDebugDiagnostics();
  }

  runApp(
    const ProviderScope(
      child: CartalystApp(),
    ),
  );
}

void _installDebugDiagnostics() {
  final FlutterExceptionHandler? previousFlutterHandler = FlutterError.onError;
  final DebugPrintCallback previousDebugPrint = debugPrint;

  FlutterError.onError = (FlutterErrorDetails details) {
    debugDiagnosticsStore.addFlutterError(details);
    previousFlutterHandler?.call(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    debugDiagnosticsStore.addError(
      error: error,
      stackTrace: stackTrace,
      source: 'PlatformDispatcher',
    );
    return false;
  };

  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.trim().isNotEmpty) {
      debugDiagnosticsStore.addLog(
        message: message,
        source: 'debugPrint',
      );
    }
    previousDebugPrint(message, wrapWidth: wrapWidth);
  };
}
