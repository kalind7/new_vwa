import 'package:flutter_test/flutter_test.dart';

import 'package:vwa/app/vwa_app.dart';

void main() {
  testWidgets('Splash routes to onboarding smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VwaApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Find nearby washing station'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets);
  });
}
