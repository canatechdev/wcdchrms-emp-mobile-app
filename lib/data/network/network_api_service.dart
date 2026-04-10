import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wcdchrms/res/constants/app_urls.dart';
import 'package:wcdchrms/utils/logger.dart';

abstract class BaseApiService {
  Future<dynamic> getApiResponse(String url);
  Future<dynamic> postApiResponse(String url, dynamic data);
}

class NetworkApiService extends BaseApiService {
  late final Dio _dio;

  NetworkApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppUrls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final SharedPreferences sp = await SharedPreferences.getInstance();
          final token = sp.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future getApiResponse(String url) async {
    try {
      AppLogger.request(url, 'GET');
      final response = await _dio.get(url);
      AppLogger.response(url, response.data);
      return returnResponse(response);
    } on DioException catch (e) {
      AppLogger.error('GET Error: $url', e);
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected GET Error: $url', e);
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future postApiResponse(String url, data) async {
    try {
      AppLogger.request(url, data);
      final response = await _dio.post(url, data: data);
      AppLogger.response(url, response.data);
      return returnResponse(response);
    } on DioException catch (e) {
      AppLogger.error('POST Error: $url', e);
      return _handleDioError(e);
    } catch (e) {
      AppLogger.error('Unexpected POST Error: $url', e);
      throw Exception('Unexpected Error: $e');
    }
  }

  dynamic returnResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  dynamic _handleDioError(DioException e) {
    if (e.response != null) {
      // Return the response data even if it's an error status code, 
      // as it might contain the success: false and message fields
      return e.response!.data;
    } else {
      throw Exception('Network Error: ${e.message}');
    }
  }
}
