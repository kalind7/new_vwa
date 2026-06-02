import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vwa/core/storage/local_storage_service.dart';
import 'package:vwa/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vwa/features/auth/data/models/login_response.dart';
import 'package:vwa/features/auth/data/models/register_response.dart';
import 'package:vwa/features/auth/data/repositories/auth_repository_impl.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  group('AuthRepositoryImpl token persistence', () {
    late _MockAuthRemoteDataSource remoteDataSource;
    late LocalStorageService localStorage;
    late AuthRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localStorage = LocalStorageService(prefs);
      remoteDataSource = _MockAuthRemoteDataSource();
      repository = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localStorage: localStorage,
      );
    });

    test('login saves access token to local storage on success', () async {
      when(
        () => remoteDataSource.login(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => right(const LoginResponse(accessToken: 'login-token-123')),
      );

      final result = await repository.login(
        login: 'user@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      expect(await localStorage.readAccessToken(), 'login-token-123');
    });

    test('register saves access token to local storage on success', () async {
      when(
        () => remoteDataSource.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          passwordConfirmation: any(named: 'passwordConfirmation'),
        ),
      ).thenAnswer(
        (_) async =>
            right(const RegisterResponse(accessToken: 'register-token-456')),
      );

      final result = await repository.register(
        name: 'Test User',
        email: 'user@example.com',
        phone: '9801234567',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(result.isRight(), isTrue);
      expect(await localStorage.readAccessToken(), 'register-token-456');
    });
    test('logout clears access token only', () async {
      when(
        () => remoteDataSource.login(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => right(const LoginResponse(accessToken: 'login-token')),
      );

      await repository.login(login: 'user@example.com', password: 'password');
      await repository.logout();

      expect(await localStorage.readAccessToken(), isNull);
    });
  });
}
