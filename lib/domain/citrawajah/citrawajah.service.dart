import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../infrastructure/network/api_client.dart';
import '../../infrastructure/network/endpoints.dart';
import '../../presentation/widgets/gridView.widget.dart';
import 'models/citrawajah.model.dart';

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
    } on DioError catch (e) {
      throw ApiClient.getErrorString(e);
    } catch (e) {
      rethrow;
    }
  }

  Future uploadCitra(List<ImageItem> croppedImageItems) async {
    try {
      print('citra siap proses: $croppedImageItems');
      await Future.forEach(croppedImageItems, (ImageItem item) async {
        try {
          print('====> mengupload ${item.image} ... ${item.name}');
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
}
