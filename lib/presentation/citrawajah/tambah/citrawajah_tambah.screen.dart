import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../domain/face_detect/views/camera.screen.dart';
import '../../../domain/face_detect/views/live_camera.widget.dart';
import '../../widgets/gridView.widget.dart';
import '../../widgets/slideUp.widget.dart';
import 'controllers/citrawajah_tambah.controller.dart';

class CitrawajahTambahScreen extends GetView<CitrawajahTambahController> {
  const CitrawajahTambahScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PanelController panelCtrl = PanelController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Citra Wajah'),
        centerTitle: true,
      ),
      body: GetBuilder<CitrawajahTambahController>(
        init: CitrawajahTambahController(),
        initState: (_) {},
        builder: (_) {
          return Stack(children: [
            CameraScreen(
              onFaceDetected: ({cameraImage, faces, statusProses}) {
                controller.onFaceDetected(
                  faces: faces,
                  camImg: cameraImage,
                  statusProses: statusProses,
                );
                if (statusProses == 'ONDONE') panelCtrl.open();
              },
            ),
            SlideUpWidget(
              panelCtrl: panelCtrl,
              panel: panelSlideUp(),
            ),
          ]);
        },
      ),
    );
  }

  List<Widget> panelSlideUp() {
    return [
      const SizedBox(
        height: 12.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          ),
        ],
      ),
      const SizedBox(
        height: 18.0,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Daftar Citra Siap Training",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttonPanel(
            label: 'Proses Semua',
            icon: Icons.check,
            color: Colors.green,
            onTap: () => controller.tambahCitra,
          ),
          buttonPanel(
            label: 'Ulangi',
            icon: Icons.replay_outlined,
            color: Colors.amber,
            onTap: () {
              controller.ulangProses();
            },
          ),
        ],
      ),
      const SizedBox(
        height: 20.0,
      ),
      Container(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridViewWidget(
              items: controller.croppedImageItems,
              onDoubleTap: (id) {
                debugPrint('idnya $id');
                controller.hapusCitra(id);
              },
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 24,
      ),
    ];
  }
}
