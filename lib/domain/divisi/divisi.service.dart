import 'package:dio/dio.dart';
import 'models/divisi.model.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';

class DivisiService {
  late ApiClient _api;

  // singleton boilerplate
  static final DivisiService _instance = DivisiService._internal();

  factory DivisiService() {
    return _instance;
  }

  DivisiService._internal() {
    _api = ApiClient();
  }

  static DivisiService getInstance() {
    return _instance;
  }

  Future<DivisiList> list() async {
    try {
      final res = await _api.dio.get(EndPoints.divisi);
      final data = DivisiList.fromJson(res.data['data']);
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future<List<Divisi>> listDivisi() async {
    final res = await _api.dio.get(EndPoints.divisi);
    List<Divisi> items = (res.data['data'] as List)
        .map((item) => Divisi.fromJson(item))
        .toList();
    return items;
  }
}
