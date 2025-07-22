import 'package:dio/dio.dart';
import 'network_client.dart';

enum RequestType { get, post }

class ApiService {
  final Dio _dio = NetworkClient.getDio();

  Future<Response<T>> request<T>({
    required String path,
    required RequestType type,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    bool useFormData = false,
  }) async {
    try {
      final Options options = Options(
        headers: {
          'Content-Type': useFormData
              ? 'application/x-www-form-urlencoded'
              : 'application/json',
        },
      );

      Response<T> response;

      switch (type) {
        case RequestType.get:
          response = await _dio.get<T>(
            path,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case RequestType.post:
          response = await _dio.post<T>(
            path,
            data: useFormData ? FormData.fromMap(data ?? {}) : data,
            options: options,
          );
          break;
      }
      return response;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
