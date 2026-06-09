import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'emoji': '🙏',
      'title': 'Request Help',
      'desc':
          'Ghar mein khana nahi? Dawa chahiye? Education ke liye kuch chahiye?\nBas ek request post karo.',
    },
    {
      'emoji': '🤝',
      'title': 'Offer Help',
      'desc':
          'Nearby logon ki requests dekho. Jo tumse ban sake woh madad karo.\nEk click se connect ho jao.',
    },
    {
      'emoji': '💚',
      'title': 'Change Lives',
      'desc':
          'Har madad se ek zindagi badal sakti hai.\nHumanityNet — Connecting Hearts, Changing Lives.',
    },
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: GoogleFonts.outfit(
                    color: AppConstants.textLight,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppConstants.primary
                        : AppConstants.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageCtrl.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finish();
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: AppConstants.buttonHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppConstants.primary,
                        AppConstants.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      _currentPage < _pages.length - 1
                          ? 'Next →'
                          : 'Get Started',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(page['emoji']!, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 32),
          Text(
            page['title']!,
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page['desc']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: AppConstants.textMedium,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}