import 'package:wcdchrms/data/models/login_response_model.dart';
import 'package:wcdchrms/data/models/user_profile_model.dart';
import 'package:wcdchrms/data/network/network_api_service.dart';
import 'package:wcdchrms/res/constants/app_urls.dart';
import 'package:wcdchrms/utils/logger.dart';

class AuthRepository {
  final NetworkApiService _apiService;

  AuthRepository(this._apiService);

  Future<LoginResponseModel> loginApi(dynamic data) async {
    try {
      final response = await _apiService.postApiResponse(AppUrls.loginUrl, data);
      return LoginResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfileModel> getUserProfile() async {
    try {
      AppLogger.info('Fetching user profile from API...');
      final response = await _apiService.getApiResponse(AppUrls.userProfileUrl);
      AppLogger.success('User profile retrieved successfully');
      return UserProfileModel.fromJson(response);
    } catch (e) {
      AppLogger.error('Failed to retrieve user profile', e);
      rethrow;
    }
  }
}
