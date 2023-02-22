import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';
import '../../presentation/widgets/gridView.widget.dart';
import '../auth/auth.service.dart';
import 'models/citrawajah.model.dart';
import 'models/recognize.model.dart';

class CitraWajahService {
  late ApiClient _api;

  // singleton boilerplate
  static final CitraWajahService _instance = CitraWajahService._internal();

  factory CitraWajahService() {
    return _instance;
  }

  CitraWajahService._internal() {
    _api = ApiClient();
  }

  static CitraWajahService getInstance() {
    return _instance;
  }

  Future<List<CitraWajah>> list({limit = 10, page = 1}) async {
    try {
      final res = await _api.get(EndPoints.citrawajah,
          queryParameters: {'limit': limit, 'page': page});
      List<CitraWajah> items = (res?.data['data'] as List)
          .map((item) => CitraWajah.fromJson(item))
          .toList();
      return items;
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }

  Future hapus(int id) async {
    try {
      final res = await _api.delete('${EndPoints.citrawajah}/$id');
      training();
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }

  Future uploadCitra(List<ImageItem> croppedImageItems) async {
    await _api.clearFiles();
    try {
      await Future.forEach(croppedImageItems, (ImageItem item) async {
        try {
          final file = File(item.image);
          _api.addFiles(file, 'nama');
          final res = await _api.postMultipartData(EndPoints.citrawajah, {});
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }

  Future training() async {
    try {
      await _api.post(EndPoints.training, {});
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }

  Future recognize(ImageItem citra) async {
    try {
      final file = File(citra.image);
      await _api.clearFiles();
      await _api.addFiles(file, 'citra');
      debugPrint('citra: ${citra.name}');
      var sesi = AuthService().getJwtPayload();

      final res = await _api.postMultipartData(EndPoints.recognize, {});
      debugPrint(res.data.toString());
      final body = RecognizeResponse.fromJson(res.data['data']);
      if (body.karyawan?.karyawanId == sesi.karyawanId) {
        // jika dikenali & sama dengan sesi
        var karyawan = body.karyawan;
        // print('karyawan : $karyawan');
        return karyawan;
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }
}
