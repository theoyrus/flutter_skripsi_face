import 'package:get/get.dart';

import '../../../../presentation/presensi/utama/controllers/presensi_utama.controller.dart';

class PresensiUtamaControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiUtamaController>(
      () => PresensiUtamaController(),
    );
  }
}
