import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  // ── Text Styles ──────────────────────
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 38,
    fontWeight: FontWeight.w900,
    color: AppConstants.primary,
    letterSpacing: -1,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppConstants.textDark,
  );

  static TextStyle get headingLarge => GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppConstants.textDark,
  );

  static TextStyle get headingMedium => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppConstants.textDark,
  );

  static TextStyle get cardTitle => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppConstants.textDark,
  );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppConstants.textMedium,
    height: 1.6,
  );

  static TextStyle get bodySmall => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppConstants.textLight,
  );

  static TextStyle get buttonText => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle get caption => GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppConstants.textLight,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppConstants.textLight,
  );

  // ── Shadows ──────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withAlpha(15),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get cardShadowHover => [
    BoxShadow(
      color: Colors.black.withAlpha(31),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get primaryButtonShadow => [
    BoxShadow(
      color: AppConstants.primary.withAlpha(89),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get urgentShadow => [
    BoxShadow(
      color: AppConstants.urgent.withAlpha(51),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get bottomSheetShadow => [
    BoxShadow(
      color: Colors.black.withAlpha(41),
      blurRadius: 32,
      offset: const Offset(0, -8),
    ),
  ];

  // ── Input Decoration ─────────────────
  static InputDecoration inputDecoration({
    required String hint,
    String? label,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: GoogleFonts.outfit(
        fontSize: 14,
        color: AppConstants.textHint,
      ),
      labelStyle: GoogleFonts.outfit(
        fontSize: 14,
        color: AppConstants.textLight,
      ),
      filled: true,
      fillColor: AppConstants.surfaceGrey,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        borderSide: const BorderSide(
          color: AppConstants.border,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        borderSide: const BorderSide(
          color: AppConstants.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        borderSide: const BorderSide(
          color: AppConstants.urgent,
          width: 1,
        ),
      ),
    );
  }

  // ── Main Theme ───────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppConstants.background,
    colorScheme: const ColorScheme.light(
      primary: AppConstants.primary,
      secondary: AppConstants.accent,
      surface: AppConstants.surface,
      error: AppConstants.urgent,
    ),
    textTheme: GoogleFonts.outfitTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppConstants.surface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppConstants.textDark,
      ),
      iconTheme: const IconThemeData(
        color: AppConstants.textDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppConstants.surface,
      selectedItemColor: AppConstants.primary,
      unselectedItemColor: AppConstants.textLight,
      selectedLabelStyle: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.outfit(
        fontSize: 11,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppConstants.surfaceGrey,
      selectedColor: AppConstants.primary,
      labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppConstants.borderLight,
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppConstants.textDark,
      contentTextStyle: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}