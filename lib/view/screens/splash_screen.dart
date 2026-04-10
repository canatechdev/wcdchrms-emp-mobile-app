import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/utils/routes/app_routes.dart';
import 'package:wcdchrms/view_model/auth_provider.dart';
import 'package:wcdchrms/utils/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _checkAuth();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _checkAuth() async {
    try {
      // Show logo for 1 second
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      // Check auth status with a 5s timeout
      AppLogger.info('Checking session status...');
      final authStatus = await ref.read(authStatusProvider.future).timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      
      AppLogger.info('Auth status: ${authStatus ? 'Authenticated' : 'Not Authenticated'}');
      
      if (mounted) {
        if (authStatus) {
          context.goNamed(AppRoutes.mainScreen);
        } else {
          context.goNamed(AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      AppLogger.error('Splash Authentication Error', e);
      if (mounted) {
        context.goNamed(AppRoutes.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app_logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.business, size: 100, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
