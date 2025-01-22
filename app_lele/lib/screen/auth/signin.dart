import 'package:app_lele/components/custom_text_field.dart';
import 'package:app_lele/screen/main_screen.dart';
import 'package:app_lele/screen/auth/signup.dart';
import 'package:app_lele/components/custom_toast.dart';
import 'package:app_lele/components/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInPage1State();
}

class _SignInPage1State extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  FirebaseAuth auth = FirebaseAuth.instance;

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
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void login() async {
    try {
      final res = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      if (res.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', true);
        if (mounted) {
          ToastHelper.showSuccess(context: context, message: 'Log In Berhasil');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ToastHelper.showError(
              context: context, message: 'Email tidak ditemukan');
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          ToastHelper.showError(context: context, message: 'Password salah');
        }
      } else {
        if (mounted) {
          ToastHelper.showError(context: context, message: 'Login Gagal');
        }
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context: context, message: 'Terjadi Kesalahan !');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.icicle,
      body: Stack(
        children: [
          // Background Design Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sunrise.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bluetopaz.withOpacity(0.1),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section with Animation
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 1000),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.sunrise.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Welcome Text
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.curelean, AppColors.bluetopaz],
                          ).createShader(bounds),
                          child: const Text(
                            "Welcome Back!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "Sign in to continue your journey",
                          style: TextStyle(
                            color: AppColors.bluetopaz,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email Field
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Password is required';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.bluetopaz),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.curelean,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Sign In Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [AppColors.bluetopaz, AppColors.curelean],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.bluetopaz.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                login();
                              }
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
