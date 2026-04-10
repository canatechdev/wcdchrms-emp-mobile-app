class LoginResponseModel {
  bool? success;
  String? message;
  LoginData? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? token;
  User? user;

  LoginData({this.token, this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? employeeId;
  String? employeeCode;
  int? applicantId;
  String? email;
  String? fullName;
  String? mobileNumber;
  bool? isEmployee;

  User(
      {this.employeeId,
      this.employeeCode,
      this.applicantId,
      this.email,
      this.fullName,
      this.mobileNumber,
      this.isEmployee});

  User.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeCode = json['employee_code'];
    applicantId = json['applicant_id'];
    email = json['email'];
    fullName = json['full_name'];
    mobileNumber = json['mobile_number'];
    isEmployee = json['is_employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['employee_code'] = employeeCode;
    data['applicant_id'] = applicantId;
    data['email'] = email;
    data['full_name'] = fullName;
    data['mobile_number'] = mobileNumber;
    data['is_employee'] = isEmployee;
    return data;
  }
}
