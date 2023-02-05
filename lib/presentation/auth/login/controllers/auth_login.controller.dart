import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../domain/auth/auth.service.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/network/api_client.dart';
import '../../../../utils/snackbar.utils.dart';

class AuthLoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late TextEditingController emailCtrl, passwordCtrl;
  var email = '', password = '';
  var hiddenPass = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // emailCtrl.dispose();
    // passwordCtrl.dispose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return 'Mohon isikan email yang valid';
    }
    return null;
  }

  String? validatePass(String value) {
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  void checkLogin() async {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) return;
    loginFormKey.currentState!.save();

    isLoading.value = true;
    try {
      await _authService.login(email, password);
      Get.offAllNamed(Routes.HOME);
    } on DioError catch (e) {
      var err = ApiClient.getErrorString(e);
      AppSnackBar.showErrorSnackBar(title: 'Autentikasi Gagal', message: err);
    } finally {
      Future.delayed(const Duration(milliseconds: 1000), () {
        isLoading.value = false;
      });
    }
  }

  void authLogout() {
    // Get.toNamed(Routes.AUTH_LOGIN);
    // Get.deleteAll();
    Get.offAllNamed(Routes.AUTH_LOGIN);
    _authService.logout();
  }
}
