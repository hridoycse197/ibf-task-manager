import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// HTTP client configured for JSONPlaceholder API
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  /// Get the Dio instance for making API calls
  Dio get dio => _dio;
}
