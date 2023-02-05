import 'package:get/get.dart';

import '../../../../presentation/setting/tampilan/controllers/setting_tampilan.controller.dart';

class SettingTampilanControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingTampilanController>(
      () => SettingTampilanController(),
    );
  }
}
