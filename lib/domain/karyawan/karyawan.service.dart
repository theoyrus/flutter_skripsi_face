import 'package:dio/dio.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';
import '../auth/token.service.dart';
import 'models/karyawan_me.model.dart';

class KaryawanService {
  late ApiClient _api;

  // singleton boilerplate
  static final KaryawanService _instance = KaryawanService._internal();

  factory KaryawanService() {
    return _instance;
  }

  KaryawanService._internal() {
    _api = ApiClient();
  }

  static KaryawanService getInstance() {
    return _instance;
  }

  Future<KaryawanMe> saya() async {
    try {
      final res = await _api.dio.get(EndPoints.karyawanMe);
      final data = KaryawanMe.fromJson(res.data['data']);
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future updateMe(KaryawanRequest data) async {
    try {
      final res =
          await _api.put(EndPoints.karyawanMe, karyawanRequestToJson(data));
      return res;
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    }
  }
}
