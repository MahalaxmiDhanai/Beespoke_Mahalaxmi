/// Domain model for a browsing history entry.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'browsing_history_entry.freezed.dart';

/// Represents a single product page visited in the in-app WebView.
@freezed
class BrowsingHistoryEntry with _$BrowsingHistoryEntry {
  const factory BrowsingHistoryEntry({
    required String url,
    required String title,
    required DateTime visitedAt,
  }) = _BrowsingHistoryEntry;
}
