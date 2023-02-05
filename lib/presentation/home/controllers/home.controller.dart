import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final isDark = false.obs;
  var tabIndex = 0;
  void increment() => count.value++;
  switchTheme(bool themeMode) {
    isDark.value = themeMode;
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
