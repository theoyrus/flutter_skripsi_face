import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'divisi.service.dart';
import 'models/divisi.model.dart';

class DivisiProvider extends GetxController {
  final DivisiService _divisiService = DivisiService();
  final divisiList = <Divisi>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void listState() async {
    var data = await _divisiService.listDivisi();
    divisiList.assignAll(data);

    debugPrint('divisiList: ${divisiList.map((element) => element).toList()}');
    update();
  }
}
