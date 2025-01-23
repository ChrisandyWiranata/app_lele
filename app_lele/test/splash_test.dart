import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_lele/screen/splash.dart';
import 'package:app_lele/screen/terms_and_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Widget Tests', () {
    testWidgets('SplashScreen displays logo and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Welcome to Lele\'s'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'SplashScreen navigates to TermsAndConditionsScreen if first time',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'firstTime': true});
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(TermsAndConditionsScreen), findsOneWidget);
    });
  });
}
