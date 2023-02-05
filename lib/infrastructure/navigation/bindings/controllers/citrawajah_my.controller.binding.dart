import 'package:get/get.dart';

import '../../../../presentation/citrawajah/my/controllers/citrawajah_my.controller.dart';

class CitrawajahMyControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitrawajahMyController>(
      () => CitrawajahMyController(),
    );
  }
}
