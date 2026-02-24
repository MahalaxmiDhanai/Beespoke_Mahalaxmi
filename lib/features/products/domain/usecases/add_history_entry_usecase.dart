/// Use case to add a browsing history entry.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/browsing_history_entry.dart';
import '../repositories/history_repository.dart';

/// Persists a new browsing history [entry].
class AddHistoryEntryUseCase {
  const AddHistoryEntryUseCase(this._repository);

  final HistoryRepository _repository;

  /// Executes the use case with the given [entry].
  Future<Either<Failure, Unit>> call(BrowsingHistoryEntry entry) =>
      _repository.addEntry(entry);
}
