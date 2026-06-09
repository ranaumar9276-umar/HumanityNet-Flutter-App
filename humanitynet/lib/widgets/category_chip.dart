import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = AppConstants.categoryIcons[label] ?? '🌍';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primary : AppConstants.surfaceGrey,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected
                ? AppConstants.primary
                : AppConstants.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primary.withAlpha(64),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : AppConstants.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}