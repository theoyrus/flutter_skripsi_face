import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../domain/citrawajah/citrawajah.service.dart';
import '../../../../domain/face_detect/service/image.service.dart';
import '../../../../domain/face_detect/service/mlkit.service.dart';
import '../../../../domain/face_detect/views/camera.screen.dart';
import '../../../../utils/dialog.utils.dart';
import '../../../../utils/snackbar.utils.dart';
import '../../../widgets/gridView.widget.dart';

class CitrawajahTambahController extends GetxController {
  int maxImage = 10;
  int countImage = 0;
  int mataTertutup = 0;
  double kedipProb = 0.3;
  bool streamDone = false;
  bool cameraReady = false;
  bool isUlang = false;
  final faceCaptured = false.obs;

  final MLKitService _mlKitService = MLKitService();
  final CitraWajahService _citraWajahService = CitraWajahService();

  List<String> croppedImagesPath = [];
  List<ImageItem> croppedImageItems = [];
  // final _box = GetStorage();

  final PanelController panelCtrl = PanelController();
  final CameraScreenController cameraScreenController =
      Get.put(CameraScreenController());

  @override
  void onInit() async {
    maxImage = 10;
    countImage = 0;
    croppedImagesPath = [];
    croppedImageItems = [];
    streamDone = false;

    if (!isUlang) {
      dialogInfo(
        onOK: () {
          cameraReady = true;
          update();
        },
        title: 'Petunjuk',
        body:
            'Arahkan wajah anda pada kamera. Kamera dilengkapi fitur untuk memverifikasi keaslian wajah melalui teknologi liveness, '
            'silahkan kedipkan mata anda untuk meng-capture citra wajah.'
            '\n\nKetika cukup meng-capture, silahkan tekan tombol biru (Selesai), '
            'lalu tombol hijau (Proses) untuk mengunggah citra.',
      );
    } else {
      cameraReady = true;
      update();
    }

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

  void onFaceDetected({
    List<Face>? faces,
    CameraImage? camImg,
    String? statusProses,
  }) async {
    if (countImage < maxImage && !streamDone) {
      // imglib.Image cropppedImage =
      var cropppedImage = await _mlKitService.cropWajah(camImg!, faces);
      if (cropppedImage != null) {
        final leftEyeOpenProb = faces?[0].leftEyeOpenProbability ?? 0;
        final rightEyeOpenProb = faces?[0].rightEyeOpenProbability ?? 0;
        if (leftEyeOpenProb > kedipProb && rightEyeOpenProb > kedipProb) {
          // eyes are open
          debugPrint('====> MATA TERBUKA');
          if (mataTertutup != 0 && mataTertutup <= 3) {
            debugPrint('====> MATA TERBUKA KEMBALI, $mataTertutup kedipan');
            faceCaptured.value = true;
            // await Future.delayed(const Duration(milliseconds: 100));
            // simpan temporary
            var path = await saveImage(cropppedImage);
            croppedImagesPath.add(path);
            croppedImageItems.add(ImageItem(path, 'citra ${countImage + 1}'));
            countImage++;
            debugPrint('====> Path $countImage : $path');
            mataTertutup = 0;
            faceCaptured.value = false;
          }
        } else {
          // eyes are closed
          mataTertutup++;
          debugPrint('====> MATA TERTUTUP');
        }
      }
      statusProses = 'ONPROCESS';
    } else if (countImage == maxImage || streamDone) {
      // statusProses = 'ONDONE';
      onDone();
    }
  }

  void onDone() {
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
    // _box.write('cameraProcess', 'ONDONE');
    cameraScreenController.updateCameraStatus('ONDONE');
    update();
  }

  void streamFinish() {
    streamDone = true;
    update();
    // debugPrint('aku di klik');
  }

  tambahCitra() async {
    if (croppedImageItems.isEmpty) {
      return AppSnackBar.showErrorToast(
          message: 'Mohon siapkan citra wajah :)');
    }
    return await Get.defaultDialog(
      title: 'Proses Citra',
      content: const Text('Anda yakin memproses semua citra ini?'),
      confirm: ElevatedButton(
        onPressed: () async {
          // int id = citraItems[index].data?['citrawajah_id'];
          SmartDialog.showLoading(msg: 'Mengunggah citra ...');
          await _citraWajahService.uploadCitra(croppedImageItems).then((_) {
            AppSnackBar.showSnackBar(
                title: "Done", message: 'Citra berhasil diproses');
            Future.delayed(const Duration(seconds: 3), () {
              Get.close(1);
              Get.back(result: true);
            });
            _citraWajahService.training();
          }).catchError((_) {
            AppSnackBar.showErrorSnackBar(title: 'Opps', message: _.toString());
          });
          SmartDialog.dismiss();
          Get.close(1);
        },
        child: const Text('Ya'),
      ),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          Get.back(result: false);
        },
        child: const Text('Batal'),
      ),
    );
  }

  hapusCitra(int id) async {
    var path = croppedImageItems[id].image;
    await deleteImage(path);
    croppedImageItems.removeAt(id);
    debugPrint('deleted image [$id], with path=> $path');
    update();
  }

  ulangProses() {
    clearCache();
    SmartDialog.showLoading(msg: 'Tunggu sebentar ...');
    panelCtrl.isAttached ? panelCtrl.hide() : null;
    cameraReady = false;
    isUlang = true;
    update();
    Future.delayed(const Duration(milliseconds: 250), () {
      onInit();
      cameraScreenController.updateCameraStatus('ONPROCESS');
      streamDone = false;
      update();
      SmartDialog.dismiss();
    });

    return;
    // Get.back();
    // SmartDialog.showLoading(msg: 'Tunggu sebentar ...');
    // Future.delayed(const Duration(seconds: 1), () {
    //   Get.toNamed(Routes.CITRAWAJAH_TAMBAH, parameters: {'ulang': 'YA'});
    //   // _box.write('cameraProcess', 'ONPROCESS');
    //   cameraScreenController.updateCameraStatus('ONPROCESS');
    //   SmartDialog.dismiss();
    // });
  }
}
