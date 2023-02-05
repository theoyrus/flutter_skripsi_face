import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmCloseAppWidget extends StatelessWidget {
  final Widget child;

  const ConfirmCloseAppWidget({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: child,
        onWillPop: () async {
          return await Get.defaultDialog(
            title: 'Keluar Aplikasi',
            content: const Text('Anda yakin?'),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('Keluar')),
            cancel: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('Batal')),
          );
        });
  }
}
