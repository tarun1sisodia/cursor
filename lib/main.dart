import 'package:firebase/firebase_options.dart';
import 'package:firebase/login_screen.dart';
import 'package:firebase/onboarding_screen.dart';
import 'package:firebase/student_dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart' as app_routes;
import 'theme.dart' as app_theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Campus',
      theme: app_theme.AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: app_routes.Routes.generateRoute,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const StudentDashboardScreen(); // Direct to dashboard if logged in
          } else {
            return const OnboardingScreen(); // Show onboarding if not logged in
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final user =
        FirebaseAuth.instance.currentUser; // Check if user is logged in
    return hasSeenOnboarding &&
        user != null; // Return true if both conditions are met
  }
}
