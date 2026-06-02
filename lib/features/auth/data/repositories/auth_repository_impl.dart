import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required LocalStorageService localStorage,
  }) : _remoteDataSource = remoteDataSource,
       _localStorage = localStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorageService _localStorage;

  @override
  Future<Either<Failure, void>> login({
    required String login,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      login: login,
      password: password,
    );

    return result.fold(left, (response) async {
      await _persistTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return right(null);
    });
  }

  @override
  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _remoteDataSource.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    return result.fold(left, (response) async {
      await _persistTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return right(null);
    });
  }

  Future<Either<Failure, void>> _persistTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _localStorage.saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _localStorage.saveRefreshToken(refreshToken);
    }
    return right(null);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final useLiveLogout = dotenv.isInitialized && !AppConfig.useMockData;
    if (useLiveLogout) {
      await _remoteDataSource.logout();
    }
    await _localStorage.clearTokens();
    return right(null);
  }
}
