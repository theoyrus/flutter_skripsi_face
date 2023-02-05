import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'token.model.dart';

class TokenService {
  static GetStorage _prefs = GetStorage();
  // singleton boilerplate
  static final TokenService _instance = TokenService._internal();

  factory TokenService() {
    return _instance;
  }

  TokenService._internal() {
    _prefs = GetStorage();
  }

  static TokenService getInstance() {
    return _instance;
  }

  Future<void> saveToken(String token) async {
    await _prefs.write("token", token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.write("refresh_token", refreshToken);
  }

  String get token => _prefs.read("token") ?? '';

  String get refreshToken => _prefs.read("refresh_token") ?? '';

  Future<void> deleteToken() async {
    await _prefs.remove("token");
  }

  Future<void> deleteRefreshToken() async {
    await _prefs.remove("refresh_token");
  }

  TokenModel getJwtPayload() {
    Map<String, dynamic> payload = Jwt.parseJwt(_instance.token);
    return TokenModel.fromJson(payload);
  }
}
