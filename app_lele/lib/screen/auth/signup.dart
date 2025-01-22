import 'package:app_lele/components/custom_text_field.dart';
import 'package:app_lele/screen/auth/signin.dart';
import 'package:app_lele/service/auth_service.dart';
import 'package:app_lele/components/custom_toast.dart';
import 'package:app_lele/components/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  void register() async {
    try {
      UserCredential res = await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      if (res.user != null) {
        await AuthService().createUser(_emailController.text, res.user!.uid,
            _usernameController.text, _phoneController.text);
        if (mounted) {
          ToastHelper.showSuccess(
              context: context, message: 'Berhasil buat akun');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (mounted) {
          ToastHelper.showError(
              context: context,
              message: 'Email sudah terdaftar. Mohon gunakan email lain.');
        }
      } else {
        if (mounted) {
          ToastHelper.showError(context: context, message: 'Registrasi gagal');
        }
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context: context, message: 'Terjadi Kesalahan');
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
            top: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.curelean.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.icicle.withOpacity(0.1),
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
                        // Logo Section
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
                                      color:
                                          AppColors.bluetopaz.withOpacity(0.2),
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
                            colors: [AppColors.bluetopaz, AppColors.curelean],
                          ).createShader(bounds),
                          child: const Text(
                            "Create Account",
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
                          "Start your journey with us",
                          style: TextStyle(
                            color: AppColors.bluetopaz,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 20),

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

                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hint: 'Enter your Username',
                          icon: Icons.phone,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
                          icon: Icons.phone,
                          isInputNumber: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Phone Number is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(color: AppColors.bluetopaz),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.curelean,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Sign Up Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [AppColors.bluetopaz, AppColors.curelean],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.curelean.withOpacity(0.3),
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
                                register();
                              }
                            },
                            child: const Text(
                              'Sign Up',
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
