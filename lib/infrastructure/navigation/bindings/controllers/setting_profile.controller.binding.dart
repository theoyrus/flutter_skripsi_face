import 'package:get/get.dart';

import '../../../../domain/divisi/divisi.provider.dart';
import '../../../../presentation/setting/profile/controllers/setting_profile.controller.dart';

class SettingProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingProfileController>(
      () => SettingProfileController(),
    );
    Get.lazyPut(() => DivisiProvider());
  }
}
