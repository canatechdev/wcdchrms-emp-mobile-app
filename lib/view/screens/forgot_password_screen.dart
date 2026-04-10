import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/utils/app_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                width: double.infinity,
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Header
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Enter your registered email to reset your password.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                    
                    SizedBox(height: 48.h),
                    
                    // Input Card
                    Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            label: "Email Address",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 32.h),
                          SizedBox(
                            width: double.infinity,
                            height: 56.h,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_emailController.text.trim().isEmpty) {
                                  AppSnackbar.showWarning(
                                    context: context,
                                    title: "Required",
                                    message: "Please enter your email address",
                                  );
                                  return;
                                }
                                // Implement Reset Logic
                                AppSnackbar.showSuccess(
                                  context: context,
                                  title: "Email Sent",
                                  message: "Reset instructions have been sent to your email.",
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Send Reset Instructions",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1),
                    
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20.sp),
              hintText: "Enter your $label",
              hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 14.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ),
      ],
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
}
