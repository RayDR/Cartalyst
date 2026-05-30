import 'package:cartalyst_mobile/core/debug/debug_diagnostics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final debugDiagnosticsStoreProvider =
    ChangeNotifierProvider<DebugDiagnosticsStore>((Ref ref) {
  return debugDiagnosticsStore;
});

final debugDiagnosticsEntriesProvider = Provider<List<DebugLogEntry>>(
  (Ref ref) => ref.watch(debugDiagnosticsStoreProvider).entries,
);
