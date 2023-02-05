import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CitrawajahMyController extends GetxController {
  final count = 0.obs;
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

  void increment() => count.value++;

  void detailImage(int index) {
    debugPrint('meng klik $index');
    update();
  }
}
