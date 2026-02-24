/// Core failure types used across the application.
///
/// All use-cases return [Either<Failure, T>] to make error handling explicit.
library;

/// Base failure class — extend for each domain error kind.
abstract class Failure {
  Failure(this.message);

  /// Human-readable description of the failure.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Failure caused by a network connectivity issue.
class NetworkFailure extends Failure {
  NetworkFailure(
      [super.message = 'No internet connection. Please check your network.']);
}

/// Failure caused by an unexpected server response (4xx / 5xx).
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error. Please try again later.']);
}

/// Failure caused by reading/writing to local storage.
class CacheFailure extends Failure {
  CacheFailure(
      [super.message = 'Local storage error. Please restart the app.']);
}

/// Failure when a requested resource is not found.
class NotFoundFailure extends Failure {
  NotFoundFailure(
      [super.message = 'The requested resource was not found.']);
}
