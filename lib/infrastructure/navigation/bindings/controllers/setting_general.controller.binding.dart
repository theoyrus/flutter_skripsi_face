import 'package:get/get.dart';

import '../../../../presentation/auth/login/controllers/auth_login.controller.dart';
import '../../../../presentation/setting/general/controllers/setting_general.controller.dart';

class SettingGeneralControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingGeneralController>(
      () => SettingGeneralController(),
    );

    Get.lazyPut(() => AuthLoginController(), fenix: true);
  }
}
