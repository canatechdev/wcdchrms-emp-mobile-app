import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  bool isCalendarView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month_outlined))],
      ),
      body: Column(
        children: [
          _buildToggleSwitch(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  if (isCalendarView) _buildCalendarPlaceholder(),
                  SizedBox(height: 20.h),
                  _buildMonthlyReportRow(),
                  SizedBox(height: 20.h),
                  _buildDailyHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleOption("Calendar", isCalendarView, () => setState(() => isCalendarView = true)),
          _buildToggleOption("List", !isCalendarView, () => setState(() => isCalendarView = false)),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarPlaceholder() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
              Text("November 2025", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
            ],
          ),
          // Simple calendar grid placeholder
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: 35,
            itemBuilder: (context, index) {
              final day = (index - 4) + 1;
              if (day < 1 || day > 30) return const SizedBox();
              
              bool isSelected = day == 28;
              bool isPresent = [2, 3, 4, 11, 15, 20].contains(day);
              bool isLeave = [25].contains(day);

              return Center(
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isPresent && !isSelected)
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.present, shape: BoxShape.circle)),
                      if (isLeave && !isSelected)
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.leave, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyReportRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("28 November 2025", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            Text("Present", style: TextStyle(fontSize: 12.sp, color: AppColors.present, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHistorySummaryBox("Check-In", "09:15 AM", AppColors.present),
            _buildHistorySummaryBox("Check-Out", "06:05 PM", AppColors.absent),
            _buildHistorySummaryBox("Working Hours", "08h 50m", AppColors.textPrimary),
          ],
        ),
      ],
    );
  }

  Widget _buildHistorySummaryBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDailyHistoryList() {
    return Column(
      children: [
        _buildHistoryListItem("27 Nov 2025", "Present", "09:10 AM - 06:00 PM", "08h 50m"),
        _buildHistoryListItem("26 Nov 2025", "Leave", "Casual Leave", ""),
        _buildHistoryListItem("25 Nov 2025", "Present", "09:05 AM - 06:15 PM", "09h 10m"),
        _buildHistoryListItem("24 Nov 2025", "Absent", "--", "--"),
      ],
    );
  }

  Widget _buildHistoryListItem(String date, String status, String time, String hours) {
    Color statusColor = status == "Present" ? AppColors.present : (status == "Leave" ? AppColors.leave : AppColors.absent);
    
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text(time, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(status, style: TextStyle(fontSize: 12.sp, color: statusColor, fontWeight: FontWeight.bold)),
              if (hours.isNotEmpty)
                Text(hours, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
