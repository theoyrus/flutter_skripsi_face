import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/presensi_utama.controller.dart';

class PresensiUtamaScreen extends GetView<PresensiUtamaController> {
  const PresensiUtamaScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PresensiUtamaScreen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Obx(() => Text(
                  'PresensiUtamaScreen is working. counter ${controller.count}',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Obx(() => ElevatedButton(
              onPressed:
                  controller.count > 5 ? null : () => controller.increment(),
              child: Text('increment'))),
        ],
      ),
    );
  }
}
