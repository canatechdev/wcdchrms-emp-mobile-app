import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/utils/routes/app_routes.dart';
import 'package:wcdchrms/view_model/auth_provider.dart';
import 'package:wcdchrms/view_model/user_provider.dart';
import 'package:wcdchrms/utils/app_snackbar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildProfileHeader(ref),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoCard(ref),
                  _buildMenuSection(context, ref),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final nameAsync = ref.watch(userNameProvider);
    final codeAsync = ref.watch(userEmployeeCodeProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 32.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              "My Profile",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white.withOpacity(0.2),
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            nameAsync.when(
              data: (name) => name,
              loading: () => "Loading...",
              error: (e, s) => "User",
            ),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            codeAsync.when(
              data: (code) => "Employee ID: $code",
              loading: () => "Loading...",
              error: (e, s) => "EMP----",
            ),
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(WidgetRef ref) {
    final emailAsync = ref.watch(userEmailProvider);
    final codeAsync = ref.watch(userEmployeeCodeProvider);
    final genderAsync = ref.watch(userGenderProvider);
    final dobAsync = ref.watch(userDobProvider);

    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, "Email Address", emailAsync.when(
            data: (email) => email,
            loading: () => "Loading...",
            error: (e, s) => "---@---.com",
          )),
          const Divider(height: 32),
          _buildInfoRow(Icons.badge_outlined, "Employee Code", codeAsync.when(
            data: (code) => code,
            loading: () => "Loading...",
            error: (e, s) => "EMP----",
          )),
          const Divider(height: 32),
          _buildInfoRow(Icons.person_outline_rounded, "Gender", genderAsync.when(
            data: (gender) => gender,
            loading: () => "Loading...",
            error: (e, s) => "Not Specified",
          )),
          const Divider(height: 32),
          _buildInfoRow(Icons.calendar_today_outlined, "Date of Birth", dobAsync.when(
            data: (dob) => dob,
            loading: () => "Loading...",
            error: (e, s) => "Not Specified",
          )),
          const Divider(height: 32),
          _buildInfoRow(Icons.phone_android_outlined, "Mobile Number", "+91 98765 43210"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuItem(Icons.lock_reset_rounded, "Change Password", () => context.pushNamed(AppRoutes.changePasswordScreen)),
        _buildMenuItem(Icons.help_outline_rounded, "Help & Support", () => context.pushNamed(AppRoutes.helpSupportScreen)),
        _buildMenuItem(Icons.logout_rounded, "Logout", () => _showLogoutDialog(context, ref), isLogout: true),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isLogout ? Colors.transparent : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isLogout ? AppColors.logout : AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15.sp,
          color: isLogout ? AppColors.logout : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: isLogout ? null : Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 24),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(userViewModelProvider).removeUser();
              if (context.mounted) {
                AppSnackbar.showSuccess(
                  context: context,
                  title: "Goodbye!",
                  message: "Logged out successfully",
                );
                context.goNamed(AppRoutes.loginScreen);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.logout,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
