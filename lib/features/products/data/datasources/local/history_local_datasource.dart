/// Local Hive datasource for persisting browsing history.
library;

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../domain/models/browsing_history_entry.dart';

/// Contract for the local browsing history datasource.
abstract interface class HistoryLocalDatasource {
  /// Returns all recorded history entries, newest first.
  List<BrowsingHistoryEntry> getHistory();

  /// Appends a new [entry] to history.
  Future<void> addEntry(BrowsingHistoryEntry entry);

  /// Clears all history.
  Future<void> clearHistory();
}

/// Hive-backed implementation of [HistoryLocalDatasource].
///
/// Stores each entry as a [Map<String, dynamic>] to avoid custom type adapters.
class HistoryLocalDatasourceImpl implements HistoryLocalDatasource {
  HistoryLocalDatasourceImpl(this._box);

  final Box<Map<String, dynamic>> _box;

  static Future<HistoryLocalDatasourceImpl> open() async {
    final box = await Hive.openBox<Map<String, dynamic>>(kHistoryBoxName);
    return HistoryLocalDatasourceImpl(box);
  }

  @override
  List<BrowsingHistoryEntry> getHistory() {
    final entries = _box.values
        .map(_mapToEntry)
        .whereType<BrowsingHistoryEntry>()
        .toList()
      ..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    return entries;
  }

  @override
  Future<void> addEntry(BrowsingHistoryEntry entry) async {
    await _box.add(_entryToMap(entry));
  }

  @override
  Future<void> clearHistory() async {
    await _box.clear();
  }

  Map<String, dynamic> _entryToMap(BrowsingHistoryEntry entry) => {
        'url': entry.url,
        'title': entry.title,
        'visitedAt': entry.visitedAt.toIso8601String(),
      };

  BrowsingHistoryEntry? _mapToEntry(Map<String, dynamic> raw) {
    try {
      return BrowsingHistoryEntry(
        url: raw['url'] as String,
        title: raw['title'] as String,
        visitedAt: DateTime.parse(raw['visitedAt'] as String),
      );
    } catch (_) {
      return null;
    }
  }
}
