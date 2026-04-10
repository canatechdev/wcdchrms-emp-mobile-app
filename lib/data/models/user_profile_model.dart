class UserProfileModel {
  bool? success;
  String? message;
  UserProfileData? data;

  UserProfileModel({this.success, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserProfileData.fromJson(json['data']) : null;
  }
}

class UserProfileData {
  int? employeeId;
  String? employeeCode;
  String? fullName;
  String? email;
  String? mobileNo;
  String? dob;
  String? gender;
  String? aadharNo;
  String? profileImage;
  String? address;
  String? employmentStatus;
  String? onboardingStatus;
  String? onboardingType;
  String? contractStartDate;
  String? contractEndDate;
  String? joiningDate;
  String? postName;

  UserProfileData({
    this.employeeId,
    this.employeeCode,
    this.fullName,
    this.email,
    this.mobileNo,
    this.dob,
    this.gender,
    this.aadharNo,
    this.profileImage,
    this.address,
    this.employmentStatus,
    this.onboardingStatus,
    this.onboardingType,
    this.contractStartDate,
    this.contractEndDate,
    this.joiningDate,
    this.postName,
  });

  UserProfileData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeCode = json['employee_code'];
    fullName = json['full_name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    dob = json['dob'];
    gender = json['gender'];
    aadharNo = json['aadhar_no'];
    profileImage = json['profile_image'];
    address = json['address'];
    employmentStatus = json['employment_status'];
    onboardingStatus = json['onboarding_status'];
    onboardingType = json['onboarding_type'];
    contractStartDate = json['contract_start_date'];
    contractEndDate = json['contract_end_date'];
    joiningDate = json['joining_date'];
  }
}
