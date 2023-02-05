import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../widgets/gridView.widget.dart';
import '../../widgets/menu.widget.dart';
import 'controllers/citrawajah_my.controller.dart';

class CitrawajahMyScreen extends GetView<CitrawajahMyController> {
  const CitrawajahMyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Citra Wajah Saya'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.CITRAWAJAH_TAMBAH),
        tooltip: 'Tambah Citra Wajah',
        child: const Icon(Icons.camera_front_outlined),
      ),
      body: Column(
        children: [
          const MenuTitleWidget(title: 'Citra wajah yang sudah di-train'),
          Expanded(
            child: GridViewWidget(
              items: GridViewWidget.sampleItems,
              onTap: controller.detailImage,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
