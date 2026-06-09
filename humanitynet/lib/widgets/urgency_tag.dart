import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class UrgencyTag extends StatelessWidget {
  const UrgencyTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppConstants.urgentLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppConstants.urgent.withAlpha(77),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🚨', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 3),
          Text(
            'URGENT',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppConstants.urgent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}