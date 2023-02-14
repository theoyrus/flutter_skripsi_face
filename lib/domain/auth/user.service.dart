import 'package:dio/dio.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';

import 'user.model.dart';

class UserMeService {
  late ApiClient _api;

  // singleton boilerplate
  static final UserMeService _instance = UserMeService._internal();

  factory UserMeService() {
    return _instance;
  }

  UserMeService._internal() {
    _api = ApiClient();
  }

  static UserMeService getInstance() {
    return _instance;
  }

  Future<UserMe> saya() async {
    try {
      final res = await _api.dio.get(EndPoints.userMe);
      final data = UserMe.fromJson(res.data);
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future updateMe(UserMePut data) async {
    try {
      final res = await _api.put(EndPoints.userMe, userMePutToJson(data));
      return res;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    }
  }

  Future changeMePass(UserMeChangePass data) async {
    try {
      final res = await _api.post(
        EndPoints.userChangePass,
        userMeChangePassToJson(data),
      );
      return res;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    }
  }

  Future changeMeMail(UserMeChangeEmail data) async {
    try {
      final res = await _api.post(
        EndPoints.userChangeEmail,
        userMeChangeEmailToJson(data),
      );
      return res;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    }
  }
}
