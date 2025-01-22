import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/screen/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildPage(
                  title: 'Selamat Datang!',
                  content:
                      'Terima kasih telah menggunakan aplikasi kami. Mohon baca syarat dan ketentuan dengan seksama sebelum menggunakan aplikasi ini.',
                  color: AppColors.bluetopaz,
                  image: 'assets/images/welcome.png',
                ),
                _buildPage(
                  title: 'Penerimaan Syarat dan Ketentuan',
                  content:
                      'Dengan mengakses aplikasi kami, Anda menyetujui semua syarat dan ketentuan yang berlaku. Jika tidak setuju, Anda tidak dapat menggunakan aplikasi ini.',
                  color: AppColors.bluetopaz,
                  image: 'assets/images/accept.png',
                ),
                _buildPage(
                  title: 'Kebijakan Privasi',
                  content:
                      'Kami melindungi privasi Anda. Data pribadi akan dikelola sesuai kebijakan privasi kami. Harap baca lebih lanjut di aplikasi.',
                  color: AppColors.bluetopaz,
                  image: 'assets/images/privacy.png',
                ),
                _buildPage(
                  title: 'Akun Pengguna',
                  content:
                      'Anda bertanggung jawab atas semua aktivitas pada akun Anda. Pastikan untuk memberikan informasi yang akurat saat pendaftaran.',
                  color: AppColors.bluetopaz,
                  image: 'assets/images/account.png',
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String content,
    required Color color,
    required String image,
  }) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final isLastPage = _currentIndex == 3;

    return Container(
      color: AppColors.bluetopaz,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentIndex != 0
              ? TextButton(
                  onPressed: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                )
              : const SizedBox(
                  width: 60,
                ),
          Row(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: _currentIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          isLastPage
              ? TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('firstTime', false);
                    if (mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    }
                  },
                  child: const Text(
                    'Setuju',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    if (_currentIndex < 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Icon(Icons.chevron_right, color: Colors.white),
                ),
        ],
      ),
    );
  }
}
