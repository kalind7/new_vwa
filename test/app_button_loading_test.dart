import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/shared/widgets/app_logo_progress_indicator.dart';

void main() {
  testWidgets('AppLogoProgressIndicator renders logo inside progress ring', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppLogoProgressIndicator(size: 48)),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
