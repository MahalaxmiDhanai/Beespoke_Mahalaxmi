/// Riverpod provider for browsing history state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/browsing_history_entry.dart';
import 'di_providers.dart';

/// Provides the list of browsing history entries.
final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<BrowsingHistoryEntry>>(
  HistoryNotifier.new,
);

/// Manages browsing history state.
class HistoryNotifier extends AsyncNotifier<List<BrowsingHistoryEntry>> {
  @override
  Future<List<BrowsingHistoryEntry>> build() async {
    final result = ref.read(getHistoryUseCaseProvider).call();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (entries) => entries,
    );
  }

  /// Adds a new entry and refreshes the list.
  Future<void> add(BrowsingHistoryEntry entry) async {
    await ref.read(addHistoryEntryUseCaseProvider).call(entry);
    ref.invalidateSelf();
  }

  /// Clears the full history.
  Future<void> clear() async {
    await ref.read(historyRepositoryProvider).clearHistory();
    ref.invalidateSelf();
  }
}
