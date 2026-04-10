import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';
import 'package:wcdchrms/view/screens/dashboard_screen.dart';
import 'package:wcdchrms/view/screens/mark_attendance_screen.dart';
import 'package:wcdchrms/view/screens/leave_screen.dart';
import 'package:wcdchrms/view/screens/history_screen.dart';
import 'package:wcdchrms/view/screens/profile_screen.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final navigationIndexProvider = NotifierProvider<NavigationNotifier, int>(NavigationNotifier.new);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const DashboardScreen(),
      const MarkAttendanceScreen(),
      const ApplyLeaveScreen(),
      const AttendanceHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => ref.read(navigationIndexProvider.notifier).setIndex(index),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary.withOpacity(0.5),
              selectedFontSize: 12.sp,
              unselectedFontSize: 12.sp,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                _buildNavItem(Icons.home_rounded, Icons.home_outlined, "Home", selectedIndex == 0),
                _buildNavItem(Icons.event_available_rounded, Icons.event_available_outlined, "Attendance", selectedIndex == 1),
                _buildNavItem(Icons.event_busy_rounded, Icons.event_busy_outlined, "Leave", selectedIndex == 2),
                _buildNavItem(Icons.history_rounded, Icons.history_outlined, "History", selectedIndex == 3),
                _buildNavItem(Icons.person_rounded, Icons.person_outline, "Profile", selectedIndex == 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Icon(isSelected ? activeIcon : inactiveIcon, size: 24.w),
      ),
      label: label,
    );
  }
}
