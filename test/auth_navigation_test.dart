import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'package:vwa/app/app_routes.dart';
import 'package:vwa/core/di/app_dependencies.dart';
import 'package:vwa/features/auth/domain/repositories/auth_repository.dart';
import 'package:vwa/features/auth/presentation/screens/add_vehicle_screen.dart';
import 'package:vwa/features/auth/presentation/screens/login_screen.dart';
import 'package:vwa/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:vwa/features/main/data/wash_station_repository.dart';
import 'package:vwa/features/main/presentation/screens/main_shell_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository authRepository;

  setUpAll(() async {
    await dotenv.load(fileName: 'assets/env/.env');
  });

  setUp(() {
    authRepository = _MockAuthRepository();
    when(() => authRepository.logout()).thenAnswer((_) async => right(null));
  });

  Future<void> pumpAuthApp(WidgetTester tester, Widget home) async {
    final dependencies = await AppDependencies.testing();

    await tester.binding.setSurfaceSize(const Size(800, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDependencies>.value(value: dependencies),
          Provider<AuthRepository>.value(value: authRepository),
          Provider<WashStationRepository>.value(
            value: const MockWashStationRepository(),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) {
            return BotToastInit()(context, child ?? const SizedBox.shrink());
          },
          navigatorObservers: [BotToastNavigatorObserver()],
          home: home,
          routes: {
            AppRoutes.addVehicle: (_) => const AddVehicleScreen(),
            AppRoutes.mainShell: (_) => const MainShellScreen(),
          },
        ),
      ),
    );
  }

  group('Auth post-submit navigation', () {
    testWidgets('register success navigates to add vehicle screen', (
      WidgetTester tester,
    ) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('RenderFlex overflowed')) {
          return;
        }
        originalOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = originalOnError);

      when(
        () => authRepository.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          passwordConfirmation: any(named: 'passwordConfirmation'),
        ),
      ).thenAnswer((_) async => right(null));

      await pumpAuthApp(tester, const SignUpScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Louis'),
        'Jane',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Becket'),
        'Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Louisbecket@gmail.com'),
        'jane@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '9801234567'),
        '9801234567',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '*******'),
        'Password1!',
      );

      await tester.ensureVisible(find.text('Register'));
      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Setup your profile'), findsOneWidget);
      expect(find.text('Sign in to your Account'), findsNothing);
    });

    testWidgets('login success navigates to dashboard', (
      WidgetTester tester,
    ) async {
      when(
        () => authRepository.login(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => right(null));

      await pumpAuthApp(tester, const LoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter password'),
        'Password1!',
      );

      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sign in to your Account'), findsNothing);
    });
  });
}
