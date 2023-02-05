import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/splashscreen.controller.dart';

class SplashscreenScreen extends GetView<SplashscreenController> {
  const SplashscreenScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.onSplash();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/face-icon.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Presensi Wajah Karyawan',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
