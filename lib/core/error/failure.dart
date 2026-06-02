/// Typed failures returned via fpdart Either from the data layer.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Check your connection.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.statusCode = 422});

  final int statusCode;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid email or password.']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
