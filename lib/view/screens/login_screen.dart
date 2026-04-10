import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/utils/logger.dart';
import 'package:wcdchrms/utils/routes/app_routes.dart';
import 'package:wcdchrms/view_model/auth_provider.dart';
import 'package:wcdchrms/utils/app_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final loginId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      AppSnackbar.showWarning(context: context, title: "Empty Fields", message: "Please enter both ID and Password");
      return;
    }

    AppLogger.info('UI: Login button clicked. Starting login process...');
    
    try {
      await ref.read(loginProvider.notifier).login(loginId, password);
      
      if (mounted) {
        final loginState = ref.read(loginProvider);
        
        loginState.when(
          data: (data) {
            if (data == null) {
              AppSnackbar.showError(context: context, title: "Error", message: "No response from server");
              return;
            }

            if (data.success == true) {
              AppSnackbar.showSuccess(context: context, title: "Welcome!", message: "Login successful");
              context.goNamed(AppRoutes.mainScreen);
            } else {
              AppSnackbar.showError(context: context, title: "Login Failed", message: data.message ?? "Invalid credentials");
            }
          },
          loading: () {},
          error: (error, stack) {
            AppSnackbar.showError(context: context, title: "Network Error", message: error.toString());
          },
        );
      }
    } catch (e) {
      AppSnackbar.showError(context: context, title: "Critical Error", message: "An unexpected error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // Background decorations
          Positioned(
            top: -50,
            right: -50,
            child: _buildCircle(AppColors.primary.withOpacity(0.1), 200),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: _buildCircle(AppColors.secondary.withOpacity(0.1), 250),
          ),
          
          SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  maxWidth: 600, // Limit width on tablets
                ),
                child: Column(
                children: [
                  SizedBox(height: 60.h),
                  // Logo & Brand Header
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      height: 150.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.business, size: 60.h, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(delay: 200.ms, curve: Curves.easeOutBack),
                  SizedBox(height: 16.h),
                  Text(
                    "Women & Child Development",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "Maharashtra State",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Sign in to continue",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                  SizedBox(height: 40.h),
                  _buildTextField(
                    controller: _idController,
                    label: "Email",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24.w,
                            width: 24.w,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Remember me",
                            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => context.pushNamed(AppRoutes.forgotPasswordScreen),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Login",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                  SizedBox(height: 40.h),
                  Text.rich(
                    TextSpan(
                      text: "New user? ",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                      children: [
                        TextSpan(
                          text: "Contact Admin",
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 22, color: AppColors.primary.withOpacity(0.7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20, color: AppColors.textSecondary),
                  onPressed: onToggleObscure,
                )
              : null,
          hintText: label,
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
