import 'package:get/get.dart';

import '../../../../presentation/presensi/rekam/controllers/presensi_rekam.controller.dart';

class PresensiRekamControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiRekamController>(
      () => PresensiRekamController(),
    );
  }
}
