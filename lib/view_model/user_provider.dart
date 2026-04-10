import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wcdchrms/data/models/login_response_model.dart';
import 'package:wcdchrms/utils/logger.dart';

final userViewModelProvider = Provider<UserViewModel>((ref) {
  return UserViewModel();
});

class UserViewModel {
  
  Future<bool> saveUser(LoginResponseModel model) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      
      final token = model.data?.token;
      final user = model.data?.user;

      AppLogger.info('Saving user session and model...');

      if (token != null) await sp.setString('token', token);
      if (user != null) {
        await sp.setString('user_model', jsonEncode(user.toJson()));
      }
      
      AppLogger.success('User model saved successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to save user model', e);
      return true; 
    }
  }

  Future<User?> getUser() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final userStr = sp.getString('user_model');
      if (userStr != null) {
        return User.fromJson(jsonDecode(userStr));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      return sp.getString('token');
    } catch (e) {
      AppLogger.error('Failed to get token', e);
      return null;
    }
  }

  Future<bool> removeUser() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.remove('token');
      await sp.remove('user_model');
      AppLogger.info('Session cleared');
      return true;
    } catch (e) {
      AppLogger.error('Failed to remove user', e);
      return false;
    }
  }
}
