import 'package:dio/dio.dart';
import 'package:eat_incredible_app/api/interceptor.dart' as interceptor;

class ApiHelper {
  Dio _dio = Dio();
  late BaseOptions baseOptions;
  ApiHelper() {
    setUpOptions();
  }

  setUpOptions() {
    baseOptions = BaseOptions(
      baseUrl: 'https://eatincredible.in/api/',
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.add(interceptor.Interceptors());
  }

  Future<dynamic> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response result = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response result = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required Map<String, dynamic> body,
  }) async {
    try {
      final Response result = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response result = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patchRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response result = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
