import 'package:dio/dio.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';
import 'models/kehadiranbulanini.model.dart';
import 'models/presensi.model.dart';

class PresensiService {
  late ApiClient _api;

  // singleton boilerplate
  static final PresensiService _instance = PresensiService._internal();

  factory PresensiService() {
    return _instance;
  }

  PresensiService._internal() {
    _api = ApiClient();
  }

  static PresensiService getInstance() {
    return _instance;
  }

  Future rekam(String jenis) async {
    try {
      await _api.post(EndPoints.kehadiran, {'jenis': jenis});
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Kehadiran> kehadiranHariIni() async {
    try {
      final res = await _api.dio.get('${EndPoints.kehadiran}/hariini');
      final data = Kehadiran.fromJson(res.data['data']);
      return data;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<KehadiranBulanIni> kehadiranBulanIni() async {
    try {
      final res = await _api.dio.get('${EndPoints.kehadiran}/bulanini');
      final data = KehadiranBulanIni.fromJson(res.data['data']);
      return data;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Kehadiran>> kehadiranList({
    limit = 10,
    page = 1,
    tahun,
    bulan,
  }) async {
    try {
      tahun ??= DateTime.now().year;
      bulan ??= DateTime.now().month;
      final res = await _api.dio.get(EndPoints.kehadiran, queryParameters: {
        'limit': limit,
        'page': page,
        'tahun': tahun,
        'bulan': bulan
      });
      List<Kehadiran> items = (res.data['data'] as List)
          .map((item) => Kehadiran.fromJson(item))
          .toList();
      return items;
    } on DioError catch (e) {
      throw ApiClient.getErrorPesan(e);
    } catch (e) {
      rethrow;
    }
  }
}
