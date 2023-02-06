import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';

import '../../domain/auth/auth.service.dart';
import '../../domain/auth/token.service.dart';
import '../../env/env.dart';
import '../logs/sentry/sentry.service.dart';
import '../navigation/routes.dart';
import 'api_exception.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor({
    required this.dio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${TokenService().token}';
    debugPrint('REQUEST[${options.method}], URI: ${options.uri} with Auth');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}], URI: ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    var uri = err.requestOptions.uri;
    var msg = '${DateTime.now()} ERROR[${err.response?.statusCode}]';
    var errData = DioExceptions.fromDioError(err);
    var exception = 'URI: $uri => ${errData.message}: ${errData.error}';
    debugPrint('$msg => $exception');

    if (isSentryAble()) {
      SentryService.captureException(exception, stackTrace: err.stackTrace);
    }

    if (err.response?.statusCode == 401) {
      // Unauthorized, coba refresh token, apabila refresh tetap gagal maka logout
      // Get.snackbar('Me-refresh', 'Sesi ...');
      AuthService().refreshToken().then((res) {
        // ketika sukses refresh token, coba retry
        // _retry(err.requestOptions);
      }).catchError((_) {
        // jika tidak bisa refresh token, arahkan ke login
        Get.offAllNamed(Routes.AUTH_LOGIN);
      });
      return handler.next(err);
    } else if (err.response?.statusCode == 404) {
      return;
    }
    // return handler.next(err);
  }

  /// For retrying request with new token
  ///
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}

class NonAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        '${DateTime.now()} REQUEST[${options.method}], URI: ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '${DateTime.now()} RESPONSE[${response.statusCode}], URI: ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var uri = err.requestOptions.uri;
    var msg = '${DateTime.now()} ERROR[${err.response?.statusCode}]';
    var errData = DioExceptions.fromDioError(err);
    var exception = 'URI: $uri => ${errData.message}: ${errData.error}';
    debugPrint('$msg => $exception');

    if (isSentryAble()) {
      SentryService.captureException(exception, stackTrace: err.stackTrace);
    }
    super.onError(err, handler);
  }
}
