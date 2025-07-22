import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:loyalty_program/components/constants.dart';

class NetworkClient {
  static Dio getDio() {
    return Dio(
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
  }
}
