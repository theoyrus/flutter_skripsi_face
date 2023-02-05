import 'package:get/get.dart';

import '../../../../presentation/beranda/controllers/beranda.controller.dart';

class BerandaControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaController>(
      () => BerandaController(),
    );
  }
}
