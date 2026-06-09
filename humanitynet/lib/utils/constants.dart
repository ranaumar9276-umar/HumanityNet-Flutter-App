import 'package:flutter/material.dart';

// ══════════════════════════════════════
//  ROUTES
// ══════════════════════════════════════
class AppRoutes {
  static const String splash        = '/splash';
  static const String onboarding    = '/onboarding';
  static const String login         = '/login';
  static const String register      = '/register';
  static const String home          = '/home';
  static const String postRequest   = '/post-request';
  static const String reqDetail     = '/request-detail';
  static const String myRequests    = '/my-requests';
  static const String myResponses   = '/my-responses';
  static const String profile       = '/profile';
  static const String notifications = '/notifications';
  static const String admin         = '/admin';
  // Chat routes HATAYE — admin flow use hoga
}

// ══════════════════════════════════════
//  COLORS & DIMENSIONS
// ══════════════════════════════════════
class AppConstants {
  // Primary Colors
  static const Color primary       = Color(0xFF1DB954);
  static const Color primaryDark   = Color(0xFF0F9C3F);
  static const Color primaryLight  = Color(0xFFE8F8EF);

  // Accent
  static const Color accent        = Color(0xFFFF6B35);
  static const Color accentGold    = Color(0xFFFFD166);

  // Status Colors
  static const Color urgent        = Color(0xFFEF4444);
  static const Color urgentLight   = Color(0xFFFEF2F2);
  static const Color success       = Color(0xFF16A34A);
  static const Color successLight  = Color(0xFFF0FDF4);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color warningLight  = Color(0xFFFFFBEB);

  // Background & Surface
  static const Color background    = Color(0xFFF8FAFC);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceGrey   = Color(0xFFF1F5F9);

  // Text
  static const Color textDark      = Color(0xFF1A1A2E);
  static const Color textMedium    = Color(0xFF475569);
  static const Color textLight     = Color(0xFF94A3B8);
  static const Color textHint      = Color(0xFFCBD5E1);

  // Border
  static const Color border        = Color(0xFFE2E8F0);
  static const Color borderLight   = Color(0xFFF1F5F9);

  // Splash
  static const Color splashBg      = Color(0xFF071A0E);
  static const Color splashBg2     = Color(0xFF050D07);

  // Category Colors
  static const Color foodColor      = Color(0xFFFF6B35);
  static const Color foodLight      = Color(0xFFFFF7ED);
  static const Color healthColor    = Color(0xFFEF4444);
  static const Color healthLight    = Color(0xFFFEF2F2);
  static const Color educationColor = Color(0xFF3B82F6);
  static const Color educationLight = Color(0xFFEFF6FF);
  static const Color clothingColor  = Color(0xFFA855F7);
  static const Color clothingLight  = Color(0xFFFAF5FF);

  // Dimensions
  static const double buttonHeight   = 52.0;
  static const double cardRadius     = 16.0;
  static const double screenPadding  = 16.0;
  static const double cardPadding    = 16.0;
  static const double cardSpacing    = 12.0;
  static const double inputRadius    = 14.0;

  // Categories List
  static const List<String> categories = [
    'All',
    'Food',
    'Health',
    'Education',
    'Clothing',
  ];

  // Category Icons
  static const Map<String, String> categoryIcons = {
    'All':       '🌍',
    'Food':      '🍎',
    'Health':    '🏥',
    'Education': '📚',
    'Clothing':  '👕',
  };

  // Category Colors Map
  static const Map<String, Color> categoryColors = {
    'Food':      foodColor,
    'Health':    healthColor,
    'Education': educationColor,
    'Clothing':  clothingColor,
  };

  static const Map<String, Color> categoryLightColors = {
    'Food':      foodLight,
    'Health':    healthLight,
    'Education': educationLight,
    'Clothing':  clothingLight,
  };

  // Badge Rules — helpCount: badgeName
  static const Map<int, String> badgeRules = {
    1:  '🌱 First Helper',
    5:  '⭐ Active Helper',
    15: '💪 Dedicated Helper',
    30: '🏆 Super Helper',
    50: '👑 Humanity Hero',
  };

  // Status Labels
  static const Map<String, String> statusLabels = {
    'pending':     'Pending',
    'in_progress': 'In Progress',
    'completed':   'Completed',
  };

  static const Map<String, Color> statusColors = {
    'pending':     Color(0xFFF59E0B),
    'in_progress': Color(0xFF3B82F6),
    'completed':   Color(0xFF16A34A),
  };

  static const Map<String, Color> statusLightColors = {
    'pending':     Color(0xFFFFFBEB),
    'in_progress': Color(0xFFEFF6FF),
    'completed':   Color(0xFFF0FDF4),
  };

  // Max active requests per user
  static const int maxActiveRequests = 5;

  // Admin email
  static const String adminEmail = 'admin@humanitynet.com';
}