import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  String? _leaveType;
  DateTime? _fromDate;
  DateTime? _toDate;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply for Leave", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeaveBalanceRow(),
            SizedBox(height: 32.h),
            _buildFormHeader("Leave Type"),
            _buildDropdown(),
            SizedBox(height: 24.h),
            _buildFormHeader("From Date"),
            _buildDatePicker(true),
            SizedBox(height: 24.h),
            _buildFormHeader("To Date"),
            _buildDatePicker(false),
            SizedBox(height: 24.h),
            _buildFormHeader("Reason"),
            _buildTextField(),
            SizedBox(height: 24.h),
            _buildFormHeader("Attachment (Optional)"),
            _buildAttachmentPicker(),
            SizedBox(height: 48.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 54.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Submit Request", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Leave Balance",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildBalanceCard("Casual", "6 Days", Colors.blue.shade50, Colors.blue),
            SizedBox(width: 12.w),
            _buildBalanceCard("Sick", "4 Days", Colors.green.shade50, Colors.green),
            SizedBox(width: 12.w),
            _buildBalanceCard("Privilege", "8 Days", Colors.orange.shade50, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String label, String count, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 12.sp, color: textColor)),
            SizedBox(height: 4.h),
            Text(count, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _leaveType,
          isExpanded: true,
          hint: Text("Select leave type", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
          items: ["Sick Leave", "Casual Leave", "Annual Leave"].map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (v) => setState(() => _leaveType = v),
        ),
      ),
    );
  }

  Widget _buildDatePicker(bool isFrom) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) setState(() => isFrom ? _fromDate = date : _toDate = date);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isFrom
                  ? (_fromDate == null ? "Select date" : _fromDate.toString().split(' ')[0])
                  : (_toDate == null ? "Select date" : _toDate.toString().split(' ')[0]),
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _reasonController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Write reason for leave...",
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
      ),
    );
  }

  Widget _buildAttachmentPicker() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_upload_outlined, size: 18),
            label: const Text("Choose File"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "No file chosen",
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
