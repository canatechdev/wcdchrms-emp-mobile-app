import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wcdchrms/data/models/login_response_model.dart';
import 'package:wcdchrms/data/models/user_profile_model.dart';
import 'package:wcdchrms/data/repository/auth_repository.dart';
import 'package:wcdchrms/view_model/network_provider.dart';
import 'package:wcdchrms/view_model/user_provider.dart';
import 'package:wcdchrms/utils/logger.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(networkApiServiceProvider);
  return AuthRepository(apiService);
});

final loginProvider = AsyncNotifierProvider<LoginViewModel, LoginResponseModel?>(() {
  return LoginViewModel();
});

final authStatusProvider = FutureProvider<bool>((ref) async {
  final token = await ref.read(userViewModelProvider).getToken();
  return token != null;
});

final userProfileProvider = FutureProvider<UserProfileData?>((ref) async {
  final repository = ref.read(authRepositoryProvider);
  try {
    final response = await repository.getUserProfile();
    return response.data;
  } catch (e) {
    AppLogger.error('Error fetching user profile', e);
    return null;
  }
});

final userModelProvider = FutureProvider<User?>((ref) async {
  return await ref.read(userViewModelProvider).getUser();
});

final userNameProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile != null && profile.fullName != null) return profile.fullName!;
  
  final user = await ref.watch(userModelProvider.future);
  return user?.fullName ?? "User";
});

final userEmployeeCodeProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile != null && profile.employeeCode != null) return profile.employeeCode!;

  final user = await ref.watch(userModelProvider.future);
  return user?.employeeCode ?? "EMP----";
});

final userEmailProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile != null && profile.email != null) return profile.email!;

  final user = await ref.watch(userModelProvider.future);
  return user?.email ?? "---@---.com";
});

final userGenderProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  return profile?.gender ?? "Not Specified";
});

final userDobProvider = FutureProvider<String>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  return profile?.dob ?? "Not Specified";
});

class LoginViewModel extends AsyncNotifier<LoginResponseModel?> {
  
  @override
  FutureOr<LoginResponseModel?> build() {
    return null;
  }

  Future<void> login(String loginId, String password) async {
    state = const AsyncLoading<LoginResponseModel?>();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final data = {
        'email': loginId,
        'password': password,
      };
      
      AppLogger.info('Attempting login for: $loginId');
      final response = await repository.loginApi(data);
      
      if (response.success == true) {
        AppLogger.success('Login successful, saving session...');
        await ref.read(userViewModelProvider).saveUser(response);
        // Refresh providers to show new user data
        ref.invalidate(userModelProvider);
        ref.invalidate(userProfileProvider);
        ref.invalidate(authStatusProvider);
      } else {
        AppLogger.log('Login failed: ${response.message}');
      }
      
      return response;
    });
  }
}
