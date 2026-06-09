import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/request_provider.dart';
import 'utils/constants.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_request_screen.dart';
import 'screens/request_detail_screen.dart';
import 'screens/my_requests_screen.dart';
import 'screens/my_responses_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/admin_screen.dart';

//void main() async {


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ← WEB KE LIYE ZAROORI
  );
  runApp(const HumanityNetApp());
}

class HumanityNetApp extends StatelessWidget {
  const HumanityNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
      ],
      child: MaterialApp(
        title: 'HumanityNet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash:
              (_) => const SplashScreen(),
          AppRoutes.onboarding:
              (_) => const OnboardingScreen(),
          AppRoutes.login:
              (_) => const LoginScreen(),
          AppRoutes.register:
              (_) => const RegisterScreen(),
          AppRoutes.home:
              (_) => const HomeScreen(),
          AppRoutes.postRequest:
              (_) => const PostRequestScreen(),
          AppRoutes.myRequests:
              (_) => const MyRequestsScreen(),
          AppRoutes.myResponses:
              (_) => const MyResponsesScreen(),
          AppRoutes.profile:
              (_) => const ProfileScreen(),
          AppRoutes.notifications:
              (_) => const NotificationScreen(),
          AppRoutes.admin:
              (_) => const AdminScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.reqDetail) {
            return MaterialPageRoute(
              builder: (_) => RequestDetailScreen(
                requestId: settings.arguments as String,
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}