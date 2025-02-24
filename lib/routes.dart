import 'package:firebase/add_phone_number_screen.dart';
import 'package:firebase/confirm_phone_number_screen.dart';
import 'package:firebase/student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'onboarding_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'sync_status_screen.dart';
import 'about_screen.dart';
import 'sentry_test_screen.dart';
import 'splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String onboarding = '/onboarding';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String studentDashboard = '/student-dashboard';
  static const String markAttendance = '/mark-attendance';
  static const String syncStatus = '/sync-status';
  static const String about = '/about';
  static const String sentryTest = '/sentry-test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/add-phone-number':
        final args = settings.arguments as RegistrationArguments;
        return MaterialPageRoute(
          builder:
              (_) => AddPhoneNumberScreen(
                email: args.email,
                password: args.password,
                username: args.username,
              ),
        );
      case '/confirm-phone-number':
        final args = settings.arguments as VerificationArguments;
        return MaterialPageRoute(
          builder:
              (_) => ConfirmPhoneNumberScreen(
                verificationId: args.verificationId,
                email: args.email,
                password: args.password,
                username: args.username,
              ),
        );
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/student-dashboard':
        return MaterialPageRoute(
          builder: (_) => const StudentDashboardScreen(),
        );
      case '/sync-status':
        return MaterialPageRoute(builder: (_) => const SyncStatusScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case '/sentry-test':
        return MaterialPageRoute(builder: (_) => const SentryTestScreen());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  static void navigateToAndRemove(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          switch (routeName) {
            case '/login':
              return const LoginScreen();
            case '/register':
              return const RegisterScreen();
            case '/add-phone-number':
              final email = arguments as String;
              final password = arguments;
              final username = arguments;
              return AddPhoneNumberScreen(
                email: email,
                password: password,
                username: username,
              );
            case '/confirm-phone-number':
              final verificationId = arguments as String;
              final email = arguments;
              final password = arguments;
              final username = arguments;
              return ConfirmPhoneNumberScreen(
                verificationId: verificationId,
                email: email,
                password: password,
                username: username,
              );
            case '/forgot-password':
              return const ForgotPasswordScreen();
            case '/onboarding':
              return const OnboardingScreen();
            case '/profile':
              return const ProfileScreen();
            case '/settings':
              return const SettingsScreen();
            case '/student-dashboard':
              return const StudentDashboardScreen();

            case '/sync-status':
              return const SyncStatusScreen();
            case '/about':
              return const AboutScreen();
            case '/sentry-test':
              return const SentryTestScreen();
            default:
              throw Exception('Invalid route: $routeName');
          }
        },
      ),
      (route) => false,
    );
  }
}

class RegistrationArguments {
  final String email;
  final String password;
  final String username;

  RegistrationArguments({
    required this.email,
    required this.password,
    required this.username,
  });
}

class VerificationArguments {
  final String verificationId;
  final String email;
  final String password;
  final String username;

  VerificationArguments({
    required this.verificationId,
    required this.email,
    required this.password,
    required this.username,
  });
}
