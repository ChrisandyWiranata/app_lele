import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_lele/screen/auth/signin.dart';
import 'package:app_lele/screen/auth/signup.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  group('SignInScreen Widget Tests', () {
    testWidgets('SignInScreen displays logo and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text("Welcome Back!"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('SignInScreen navigates to SignUpScreen when Sign Up is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
