import 'package:get/get.dart';

import '../../../../presentation/splashscreen/controllers/splashscreen.controller.dart';

class SplashscreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashscreenController>(
      () => SplashscreenController(),
    );
  }
}
