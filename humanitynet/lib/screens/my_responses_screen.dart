import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class MyResponsesScreen extends StatelessWidget {
  const MyResponsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(
          'My Help History',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤝', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              'Help Count: ${auth.user?.helpCount ?? 0}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppConstants.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tumne itne logon ki madad ki hai!',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppConstants.textLight,
              ),
            ),
            const SizedBox(height: 24),
            // Badges
            if (auth.user?.badges.isNotEmpty == true)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: auth.user!.badges
                    .map(
                      (b) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFFFBBF24),
                          ),
                        ),
                        child: Text(
                          b,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}