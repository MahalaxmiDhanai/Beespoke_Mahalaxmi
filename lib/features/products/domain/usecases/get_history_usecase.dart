/// Use case to fetch all browsing history entries.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/browsing_history_entry.dart';
import '../repositories/history_repository.dart';

/// Returns all browsing history entries from the repository.
class GetHistoryUseCase {
  const GetHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  /// Executes the use case.
  Either<Failure, List<BrowsingHistoryEntry>> call() =>
      _repository.getHistory();
}
