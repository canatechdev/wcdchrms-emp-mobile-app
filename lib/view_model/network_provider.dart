import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wcdchrms/data/network/network_api_service.dart';

final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService();
});
