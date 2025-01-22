import 'package:app_lele/screen/main_screen.dart';
import 'package:app_lele/screen/auth/signin.dart';
import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/screen/terms_and_condition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Future<void> initialApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('login') ?? false;
    final isFirstTime = prefs.getBool('firstTime') ?? true;

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (isFirstTime) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen()));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    isLogin ? const MainScreen() : const SignInScreen()),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    initialApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.icicle,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bluetopaz.withOpacity(0.1),
              AppColors.icicle,
              AppColors.curelean.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.bluetopaz.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Welcome to Lele\'s',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluetopaz,
                      shadows: [
                        Shadow(
                          color: AppColors.curelean.withOpacity(0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.bluetopaz),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
