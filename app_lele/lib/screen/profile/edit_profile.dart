import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/components/custom_text_field.dart';
import 'package:app_lele/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.userData['username']);
    _phoneController =
        TextEditingController(text: widget.userData['phoneNumber']);
    _imageController =
        TextEditingController(text: widget.userData['imageProfile']);
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await AuthService().updateUser(
        FirebaseAuth.instance.currentUser!.uid,
        _usernameController.text,
        _phoneController.text,
        _imageController.text,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.icicle,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.curelean),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.curelean),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter your Username',
                icon: Icons.person,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Username is required';
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
                  if (value?.isEmpty ?? true) return 'Phone Number is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _imageController,
                label: 'Image Profile',
                hint: 'https://',
                icon: Icons.camera,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.curelean,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
