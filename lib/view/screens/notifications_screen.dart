import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Mark all read",
              style: TextStyle(color: AppColors.primary, fontSize: 13.sp),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 10,
        itemBuilder: (context, index) {
          final isUnread = index < 3;
          return _NotificationCard(
            isUnread: isUnread,
            index: index,
          ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final bool isUnread;
  final int index;

  const _NotificationCard({
    required this.isUnread,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (isUnread)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: isUnread ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: _getIconColor(index).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(index),
              color: _getIconColor(index),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getTitle(index),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "2h ago",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  _getSubtitle(index),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread) ...[
            SizedBox(width: 8.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    if (index % 3 == 0) return Icons.event_note_outlined;
    if (index % 3 == 1) return Icons.check_circle_outline;
    return Icons.info_outline;
  }

  Color _getIconColor(int index) {
    if (index % 3 == 0) return AppColors.primary;
    if (index % 3 == 1) return Colors.green;
    return Colors.orange;
  }

  String _getTitle(int index) {
    if (index % 3 == 0) return "Leave Approved";
    if (index % 3 == 1) return "Attendance Marked";
    return "Profile Update";
  }

  String _getSubtitle(int index) {
    if (index % 3 == 0) return "Your leave request for April 10th has been approved by Admin.";
    if (index % 3 == 1) return "Successfully marked check-in at 09:30 AM.";
    return "Your profile details have been successfully updated in the system.";
  }
}
