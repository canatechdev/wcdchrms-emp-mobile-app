import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wcdchrms/utils/routes/app_routes.dart';
import 'package:wcdchrms/view/screens/change_password_screen.dart';
import 'package:wcdchrms/view/screens/splash_screen.dart';
import 'package:wcdchrms/view/screens/login_screen.dart';
import 'package:wcdchrms/view/screens/main_screen.dart';
import 'package:wcdchrms/view/screens/forgot_password_screen.dart';
import 'package:wcdchrms/view/screens/notifications_screen.dart';
import 'package:wcdchrms/view/screens/help_support_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/main',
        name: AppRoutes.mainScreen,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRoutes.notificationsScreen,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: AppRoutes.changePasswordScreen,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/help-support',
        name: AppRoutes.helpSupportScreen,
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri}')),
    ),
  );
});
 