/// Extension helpers for working with [Either] from dartz.
library;

import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Convenience extensions on [Either<Failure, T>].
extension EitherX<L extends Failure, R> on Either<L, R> {
  /// Returns the right value or throws a [StateError].
  R getOrThrow() => fold(
        (failure) => throw StateError(failure.message),
        (value) => value,
      );

  /// Returns [true] if this is a [Right].
  bool get isSuccess => isRight();

  /// Returns [true] if this is a [Left].
  bool get isFailure => isLeft();
}
