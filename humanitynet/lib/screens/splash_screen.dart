import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      // Not logged in
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_done') ?? false;
      if (!mounted) return;
      if (!onboardingDone) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
      return;
    }

    // Logged in — check verification
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        return;
      }

      final user = UserModel.fromMap(doc.data()!);

      if (!mounted) return;

      // Admin seedha home
      if (user.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return;
      }

      // Verification check
      switch (user.verificationStatus) {
        case 'approved':
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          break;
        case 'pending':
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          _showPendingSnack();
          break;
        case 'rejected':
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          break;
        default:
          Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _showPendingSnack() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '⏳ Tumhara account review mein hai — jald approve hoga',
          style: GoogleFonts.outfit(),
        ),
        backgroundColor: const Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071A0E),
      body: Stack(
        children: [
          // Glow
          Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1DB954).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Logo
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1DB954)
                                .withOpacity(0.5),
                            blurRadius: 30,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'HumanityNet',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1DB954),
                        shadows: [
                          Shadow(
                            color: const Color(0xFF1DB954)
                                .withOpacity(0.5),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CONNECTING HEARTS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        letterSpacing: 4,
                        color: const Color(0xFF4A7A52),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading dots
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration:
                        Duration(milliseconds: 500 + i * 200),
                    builder: (_, val, __) => Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      width: i == 0 ? 20 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954)
                            .withOpacity(val),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}