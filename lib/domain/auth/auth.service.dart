import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';
import 'auth.model.dart';
import 'token.model.dart';
import 'token.service.dart';

class AuthService {
  late ApiClient _api;
  final TokenService _tokenService = TokenService();

  // singleton boilerplate
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _api = ApiClient();
  }

  static AuthService getInstance() {
    return _instance;
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final res = await _api.http.post(EndPoints.login, data: {
        "email": email,
        "password": password,
      });
      final body = AuthResponse.fromJson(res.data);
      _tokenService.saveToken(body.access.toString());
      _tokenService.saveRefreshToken(body.refresh.toString());
      return body;
    } on DioError {
      rethrow;
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      String token = _tokenService.refreshToken;
      final res =
          await _api.http.post(EndPoints.jwtRefresh, data: {"refresh": token});
      final body = AuthResponse.fromJson(res.data);
      _tokenService.saveToken(body.access.toString());
      return body;
    } on DioError {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _tokenService.deleteToken();
      _tokenService.deleteRefreshToken();
    } on DioError {
      rethrow;
    }
  }

  bool isLoggedIn() {
    final token = _tokenService.token;
    final refreshToken = _tokenService.refreshToken;
    debugPrint('token: $token, refreshToken: $refreshToken');
    return (token.isNotEmpty && refreshToken.isNotEmpty);
  }

  TokenModel getJwtPayload() {
    return _tokenService.getJwtPayload();
  }
}
