import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/utils/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wcdchrms/view_model/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, ref),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  _buildLiveLocationCard(),
                  SizedBox(height: 16.h),
                  _buildAttendanceSummaryCard(),
                  SizedBox(height: 16.h),
                  _buildMonthlySummaryRow(),
                  SizedBox(height: 16.h),
                  _buildRecentNotifications(),
                  SizedBox(height: 20.h),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userNameAsync = ref.watch(userNameProvider);
    final codeAsync = ref.watch(userEmployeeCodeProvider);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 40.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: 22.r,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userNameAsync.when(
                    data: (name) => "$name 👋",
                    loading: () => "Loading...",
                    error: (e, s) => "User",
                  ),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  codeAsync.when(
                    data: (code) => "Emp ID: $code",
                    loading: () => "Emp ID: ...",
                    error: (e, s) => "Emp ID: EMP----",
                  ),
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Have a productive day!",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.notificationsScreen),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveLocationCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
              SizedBox(width: 8.w),
              Text(
                "Live Location",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.present.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Within Range",
                  style: GoogleFonts.inter(
                    color: AppColors.present,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.business_rounded, color: AppColors.textSecondary, size: 16.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Swayambhoo Infotech, Pimpri Chinchwad, Pune 411033",
                  style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 140.h,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(18.6298, 73.7997),
                      zoom: 15,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    markers: {
                      const Marker(
                        markerId: MarkerId('current_loc'),
                        position: LatLng(18.6298, 73.7997),
                      ),
                    },
                  ),
                  Center(
                    child: Container(
                      width: 80.r,
                      height: 80.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Attendance",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View History",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttendanceTimeBox("Check-In", "09:15 AM", AppColors.present),
              _buildDivider(),
              _buildAttendanceTimeBox("Check-Out", "--:--", AppColors.textSecondary),
              _buildDivider(),
              _buildAttendanceTimeBox("Total Hours", "--:--", AppColors.textSecondary),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  "Check In",
                  Icons.login_rounded,
                  AppColors.present,
                  () {},
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildActionButton(
                  "Check Out",
                  Icons.logout_rounded,
                  AppColors.absent,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Widget _buildAttendanceTimeBox(String label, String time, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          time,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlySummaryRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            "Monthly Summary",
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildSummaryCard("20", "Present", AppColors.present),
            SizedBox(width: 12.w),
            _buildSummaryCard("2", "Leave", AppColors.leave),
            SizedBox(width: 12.w),
            _buildSummaryCard("1", "Absent", AppColors.absent),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.outfit(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            "Recent Notifications",
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _buildNotificationItem(
          "Leave request for 24 Dec is approved",
          "2h ago",
          Icons.check_circle_rounded,
          AppColors.present,
        ),
        _buildNotificationItem(
          "Monthly report is available",
          "1d ago",
          Icons.description_rounded,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildNotificationItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 22),
        ],
      ),
    );
  }
}
