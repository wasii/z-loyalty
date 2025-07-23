import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:loyalty_program/components/constants.dart';

class NetworkClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: BaseURL,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('api_loyalty_z1:65Kj12gM8*9#2'))}',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('--- 🌐 API REQUEST ---');
            print('URL     : ${options.baseUrl}${options.path}');
            print('METHOD  : ${options.method}');
            print('HEADERS : ${options.headers}');
            print('QUERY   : ${options.queryParameters}');

            if (options.data is FormData) {
              final formData = options.data as FormData;
              final Map<String, dynamic> formMap = {};
              for (var field in formData.fields) {
                formMap[field.key] = field.value;
              }
              print('DATA    : $formMap');
            } else {
              print('DATA    : ${options.data}');
            }

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('--- ✅ API RESPONSE ---');
            print('STATUS  : ${response.statusCode}');
            print('DATA    : ${response.data}');
            return handler.next(response);
          },
          onError: (e, handler) {
            print('--- ❌ API ERROR ---');
            print('ERROR   : ${e.message}');
            if (e.response != null) {
              print('STATUS  : ${e.response?.statusCode}');
              print('DATA    : ${e.response?.data}');
            }
            return handler.next(e);
          },
        ),
      );
    }
    return dio;
  }
}
