import 'package:get/get.dart';

import 'karyawan.service.dart';
import 'models/karyawan_me.model.dart';

class KaryawanProvider extends GetxController {
  final KaryawanService _karyawanService = KaryawanService();
  final karyawanMe = KaryawanMe().obs;

  @override
  void onInit() {
    meState();
    super.onInit();
  }

  void meState() async {
    var me = await _karyawanService.saya();
    karyawanMe.update((val) {
      karyawanMe.value = me;
    });
    karyawanMe.refresh();
    update();
  }
}
