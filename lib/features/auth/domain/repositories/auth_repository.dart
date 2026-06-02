import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login({
    required String login,
    required String password,
  });

  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, void>> logout();
}
