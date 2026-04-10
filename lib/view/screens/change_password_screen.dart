import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            _buildPasswordField("Old Password", _obscureOld, () => setState(() => _obscureOld = !_obscureOld)),
            SizedBox(height: 20.h),
            _buildPasswordField("New Password", _obscureNew, () => setState(() => _obscureNew = !_obscureNew)),
            SizedBox(height: 20.h),
            _buildPasswordField("Confirm New Password", _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
            SizedBox(height: 60.h),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password changed successfully")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56.h),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text("Update Password", style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, bool obscure, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        TextFormField(
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
          style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
