import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent_rounded, size: 60, color: AppColors.primary),
                  SizedBox(height: 16.h),
                  Text(
                    "How can we help you?",
                    style: GoogleFonts.outfit(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Our support team is available from 10:00 AM to 6:00 PM",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _buildContactMethod(Icons.email_outlined, "Email Support", "support@wcd.gov.in"),
            _buildContactMethod(Icons.phone_outlined, "Phone Support", "+91 22 1234 5678"),
            _buildContactMethod(Icons.language_outlined, "Visit Website", "www.wcd.maharashtra.gov.in"),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Frequently Asked Questions", style: GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 16.h),
            _buildFAQ("How to mark attendance?", "Go to Dashboard and click on 'Check In' button when you are within the geofence range."),
            _buildFAQ("How to apply for leave?", "Go to Leave section from the bottom navigation and fill out the leave application form."),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textSecondary)),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Text(answer, style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
