import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
        onPressed: () async {
          var res = await Get.toNamed(Routes.CITRAWAJAH_TAMBAH);
          if (res) {
            controller.onInit();
          }
        },
        tooltip: 'Tambah Citra Wajah',
        child: const Icon(MdiIcons.faceRecognition),
      ),
      body: Column(
        children: [
          const MenuTitleWidget(title: 'Citra wajah yang sudah di-train'),
          Expanded(
            child: SmartRefresher(
              controller: controller.refreshCtrl,
              enablePullDown: true,
              enablePullUp: true,
              header: const ClassicHeader(
                refreshingText: 'Memuat ...',
                releaseText: 'Lepas untuk me-refresh',
                idleText: 'Tarik ke bawah untuk me-refresh',
                completeText: 'Selesai',
                failedText: 'Gagal :(',
              ),
              onRefresh: () => controller.refreshScreen(),
              onLoading: () => controller.loadMore(),
              child: Obx(
                () => GridViewWidget(
                  items: controller.citraItems.value,
                  onTap: controller.detailImage,
                  onDoubleTap: controller.hapus,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
