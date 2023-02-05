import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final isDark = Get.isDarkMode.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Load value of isDark from local storage
    isDark.value = _box.read('isDark') ?? false;
  }

  switchTheme(bool themeMode) {
    isDark.value = themeMode;
    update();
    // Save value of isDark to local storage
    debugPrint('isDark: ${isDark.value}');
    _box.write('isDark', isDark.value);
  }
}
