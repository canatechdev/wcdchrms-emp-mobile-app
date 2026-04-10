import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcdchrms/res/colors/app_colors.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late GoogleMapController mapController;
  final LatLng _officeLocation = const LatLng(18.6298, 73.7997);
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  
  XFile? _selfieImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('office'),
        position: _officeLocation,
        infoWindow: const InfoWindow(title: 'Swayambhoo Infotech Office Location'),
      ),
    );
    _circles.add(
      Circle(
        circleId: const CircleId('geofence'),
        center: _officeLocation,
        radius: 100, // 100 meters
        fillColor: const Color(0xFF2196F3).withOpacity(0.15),
        strokeColor: const Color(0xFF2196F3).withOpacity(0.5),
        strokeWidth: 2,
      ),
    );
  }

  Future<void> _pickSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selfieImage = image;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            color: AppColors.present.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: AppColors.present, size: 18),
                SizedBox(width: 8.w),
                Text(
                  "You are within office location",
                  style: TextStyle(color: AppColors.present, fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(target: _officeLocation, zoom: 16),
                  markers: _markers,
                  circles: _circles,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  right: 16.w,
                  bottom: 240.h,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location, color: AppColors.primary),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildLocationStatusCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      "Accuracy: 10 m",
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, color: AppColors.primary, size: 20)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "Swayambhoo Infotech, Pimpri Chinchwad, Pune 411033",
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: 16.h),
          
          // Selfie Proof Section
          _buildSelfieSection(),
          
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildSimpleTimeBox("Check-In", "09:15 AM")),
              SizedBox(width: 20.w),
              Expanded(child: _buildSimpleStatusBox("Status", "Present", AppColors.present)),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selfieImage != null ? AppColors.primaryGradient : [Colors.grey.shade400, Colors.grey.shade500],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _selfieImage != null ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: ElevatedButton.icon(
              onPressed: _selfieImage != null ? () {
                // Handle marked attendance
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Attendance Marked Successfully with Selfie Proof!")),
                );
              } : null,
              icon: const Icon(Icons.fingerprint, size: 24),
              label: Text("Mark Attendance", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfieSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickSelfie,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                image: _selfieImage != null
                    ? DecorationImage(
                        image: FileImage(File(_selfieImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _selfieImage == null
                  ? Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 30.sp)
                  : null,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selfie Proof",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 4.h),
                Text(
                  _selfieImage == null 
                      ? "Capture selfie to enable attendance" 
                      : "Selfie captured successfully",
                  style: TextStyle(
                    fontSize: 11.sp, 
                    color: _selfieImage == null ? AppColors.absent : AppColors.present,
                    fontWeight: _selfieImage == null ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                if (_selfieImage != null) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _pickSelfie,
                    child: Text(
                      "Retake Selfie",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTimeBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildSimpleStatusBox(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

