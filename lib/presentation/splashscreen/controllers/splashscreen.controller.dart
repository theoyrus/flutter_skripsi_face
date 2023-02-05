import 'package:get/get.dart';

import '../../../domain/auth/auth.service.dart';
import '../../../infrastructure/navigation/routes.dart';

class SplashscreenController extends GetxController {
  final AuthService _authService = AuthService();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onSplash() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_authService.isLoggedIn()) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTH_LOGIN);
      }
    });
  }
}
