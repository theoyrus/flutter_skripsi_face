import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../domain/auth/token.service.dart';
import '../../env/env.dart';
import 'api_error.model.dart';
import 'api_exception.dart';
import 'api_interceptor.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  ));

  final Dio http = Dio(BaseOptions(
    // custom interceptor
    baseUrl: Env.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  ));
  Dio get dio => _dio;

  late Map<String, MultipartFile> multipartData = {};

  final TokenService tokenSrvc = TokenService();

  ApiClient() {
    dio.interceptors.add(ApiInterceptor(dio: dio));
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function (optional)
      retries: 2, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 3), // wait 5 sec before first retry
        Duration(seconds: 6), // wait 6 sec before second retry
        // Duration(seconds: 10), // wait 3 sec before third retry
      ],
      // retryEvaluator: null,
      // retryableExtraStatuses: {401},
    ));
    if (!isRelease) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
    http.interceptors.add(NonAuthInterceptor());
  }

  Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<Response?> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        Uri.encodeFull(endpoint),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      rethrow;
    } catch (e) {
      throw (e as Exception);
    }
  }

  Future<Response> post(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await dio.post(
        Uri.encodeFull(endpoint),
        data: data,
        options: Options(headers: headers ?? getHeaders()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('tipe: ${data.runtimeType}');
      final response = await dio.put(
        Uri.encodeFull(endpoint),
        data: data,
        options: Options(headers: headers ?? getHeaders()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        Uri.encodeFull(endpoint),
        options: Options(headers: headers ?? getHeaders()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postMultipartData(String endpoint, dynamic data) async {
    final formData = FormData.fromMap({...data, ...multipartData});
    return post(
      endpoint,
      formData,
      headers: {
        ...getHeaders(),
        ...{'Content-Type': 'multipart/form-data'}
      },
    );
  }

  addFiles(File file, String fieldName) async {
    String filename = file.path.split('/').last;
    final data = <String, MultipartFile>{
      fieldName:
          await MultipartFile.fromFile(file.uri.path, filename: filename),
    };
    multipartData = {...multipartData, ...data};
    return multipartData;
  }

  static getErrorString(DioError error) {
    var errData = DioExceptions.fromDioError(error);
    print(
        'errdata has response?: ${errData.errorResponse} isi errdata: $errData, isi error: ${errData.error} tipe error: ${errData.error.runtimeType}');
    if (errData.errorResponse) {
      if (errData.message.contains('Bad request')) {
        print('errdata non detail');
        var parsed = ApiError.fromJson(errData.error);

        return parsed.error?.data.toString();
      } else {
        print('errdata detail');
        var parsed = ApiError.fromJson(errData.error);

        return parsed.error?.data['detail'];
      }
    }
    return errData.message;
  }

  static getErrorMap(DioError error) {
    var errData = DioExceptions.fromDioError(error);
    if (errData.errorResponse) {
      var parsed = ApiError.fromJson(errData.error);
      return parsed.error?.data;
    }
  }
}
