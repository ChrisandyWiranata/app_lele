import 'package:app_lele/screen/home/home.dart';
import 'package:app_lele/screen/home/add_product.dart';
import 'package:app_lele/screen/profile/profile.dart';
import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic> currentUser = {};
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    AuthService().saveToken();

    if (auth.currentUser != null) {
      firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            currentUser = snapshot.data()!;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.icicle,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: currentUser['role'] == 'admin'
          ? _currentIndex == 0
              ? Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.bluetopaz, AppColors.curelean],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.curelean.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddProductScreen()));
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(Icons.add, size: 28),
                  ),
                )
              : null
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.bluetopaz.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            items: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profile'),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.curelean,
            unselectedItemColor: AppColors.bluetopaz.withOpacity(0.5),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: _onTap,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData unselectedIcon, IconData selectedIcon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(unselectedIcon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.bluetopaz.withOpacity(0.2),
              AppColors.curelean.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(selectedIcon),
      ),
      label: label,
    );
  }
}
