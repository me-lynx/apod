import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

InterceptorsWrapper createDioInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      const apiKey = '4jfOCSHvKexsD2EtE5ao1FpXkkUuI2J9tzvYguCA';

      options.queryParameters['api_key'] = apiKey;

      if (kDebugMode) {
        print('Request[${options.method}] ${options.uri}');
      }

      return handler.next(options);
    },
    onResponse: (response, handler) {
      if (kDebugMode) {
        print('Response[${response.statusCode}] ${response.data}');
      }

      return handler.next(response);
    },
    onError: (error, handler) {
      if (kDebugMode) {
        print('Error: $error');
      }

      return handler.next(error);
    },
  );
}
