import 'package:flutter/foundation.dart';

class DebugLogEntry {
  const DebugLogEntry({
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
    this.stackTrace,
  });

  final DateTime timestamp;
  final String level;
  final String source;
  final String message;
  final String? stackTrace;
}

class DebugDiagnosticsStore extends ChangeNotifier {
  DebugDiagnosticsStore({this.maxEntries = 300});

  final int maxEntries;
  final List<DebugLogEntry> _entries = <DebugLogEntry>[];

  List<DebugLogEntry> get entries => List<DebugLogEntry>.unmodifiable(
        _entries.reversed,
      );

  void addLog({
    required String message,
    String source = 'app',
  }) {
    _append(
      DebugLogEntry(
        timestamp: DateTime.now(),
        level: 'LOG',
        source: source,
        message: message,
      ),
    );
  }

  void addError({
    required Object error,
    StackTrace? stackTrace,
    String source = 'app',
  }) {
    _append(
      DebugLogEntry(
        timestamp: DateTime.now(),
        level: 'ERROR',
        source: source,
        message: error.toString(),
        stackTrace: stackTrace?.toString(),
      ),
    );
  }

  void addFlutterError(FlutterErrorDetails details) {
    _append(
      DebugLogEntry(
        timestamp: DateTime.now(),
        level: 'FLUTTER',
        source: 'FlutterError',
        message: details.exceptionAsString(),
        stackTrace: details.stack?.toString(),
      ),
    );
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  void _append(DebugLogEntry entry) {
    _entries.add(entry);
    if (_entries.length > maxEntries) {
      _entries.removeAt(0);
    }
    notifyListeners();
  }
}

final DebugDiagnosticsStore debugDiagnosticsStore = DebugDiagnosticsStore();
