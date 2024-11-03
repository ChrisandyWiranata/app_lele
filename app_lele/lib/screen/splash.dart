import 'package:app_lele/screen/main_screen.dart';
import 'package:app_lele/screen/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initialApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('login');

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isLogin ?? false ? const MainScreen() : const SignInScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initialApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Lele\'s',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
