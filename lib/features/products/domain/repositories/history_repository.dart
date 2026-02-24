/// Abstract repository interface for browsing history.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/browsing_history_entry.dart';

/// Contract for the history repository.
abstract interface class HistoryRepository {
  /// Returns all browsing history entries.
  Either<Failure, List<BrowsingHistoryEntry>> getHistory();

  /// Saves a new history [entry].
  Future<Either<Failure, Unit>> addEntry(BrowsingHistoryEntry entry);

  /// Clears all history.
  Future<Either<Failure, Unit>> clearHistory();
}
