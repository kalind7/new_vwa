import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:vwa/app/vwa_app.dart';
import 'package:vwa/core/di/app_dependencies.dart';
import 'package:vwa/features/auth/domain/repositories/auth_repository.dart';
import 'package:vwa/features/main/data/wash_station_repository.dart';

Future<void> pumpVwaApp(
  WidgetTester tester, {
  Map<String, Object> initialValues = const {},
}) async {
  final dependencies = await AppDependencies.testing(
    initialValues: initialValues,
  );
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<AppDependencies>.value(value: dependencies),
        Provider<AuthRepository>.value(value: dependencies.authRepository),
        Provider<WashStationRepository>.value(
          value: dependencies.washStationRepository,
        ),
      ],
      child: const VwaApp(),
    ),
  );
}

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: 'assets/env/.env');
  });

  group('Splash auth routing', () {
    testWidgets('routes first-time users to onboarding', (
      WidgetTester tester,
    ) async {
      await pumpVwaApp(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Find nearby washing station'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign Up'), findsWidgets);
    });

    testWidgets('routes returning users without token to login', (
      WidgetTester tester,
    ) async {
      await pumpVwaApp(
        tester,
        initialValues: const {'has_seen_onboarding': true},
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Sign in to your Account'), findsOneWidget);
      expect(find.text('Find nearby washing station'), findsNothing);
    });

    testWidgets('routes authenticated users to main shell', (
      WidgetTester tester,
    ) async {
      await pumpVwaApp(
        tester,
        initialValues: const {
          'access_token': 'saved-token',
          'has_seen_onboarding': true,
        },
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sign in to your Account'), findsNothing);
    });
  });
}
