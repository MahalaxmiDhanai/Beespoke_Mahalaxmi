/// Concrete implementation of [HistoryRepository].
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/models/browsing_history_entry.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/local/history_local_datasource.dart';

/// Wraps [HistoryLocalDatasource] with error handling.
class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._datasource);

  final HistoryLocalDatasource _datasource;

  @override
  Either<Failure, List<BrowsingHistoryEntry>> getHistory() {
    try {
      return Right<Failure, List<BrowsingHistoryEntry>>(
        _datasource.getHistory(),
      );
    } catch (_) {
      return Left<Failure, List<BrowsingHistoryEntry>>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addEntry(BrowsingHistoryEntry entry) async {
    try {
      await _datasource.addEntry(entry);
      return Right<Failure, Unit>(unit);
    } catch (_) {
      return Left<Failure, Unit>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearHistory() async {
    try {
      await _datasource.clearHistory();
      return Right<Failure, Unit>(unit);
    } catch (_) {
      return Left<Failure, Unit>(CacheFailure());
    }
  }
}
