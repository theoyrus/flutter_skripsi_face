import 'package:camera/camera.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../domain/citrawajah/citrawajah.service.dart';
import '../../../../domain/face_detect/camerawesome/camerapage.screen.dart';
import '../../../../domain/face_detect/camerawesome/services/jobs.queue.dart';
import '../../../../domain/face_detect/service/image.service.dart';
import '../../../../domain/face_detect/service/jobs.queue.dart';
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
  final pathCaptured = ''.obs;
  final cameraPlugin = 'CamerAwesome'.obs;

  List<String> capturedImagesPath = [];
  List<String> croppedImagesPath = [];
  List<ImageItem> croppedImageItems = [];
  final _box = GetStorage();

  final CitraWajahService _citraWajahService = CitraWajahService();
  final PanelController panelCtrl = PanelController();
  final CameraScreenController cameraScreenController =
      Get.put(CameraScreenController());
  final CameraPageController cameraPageController =
      Get.put(CameraPageController());

  @override
  void onInit() async {
    maxImage = 10;
    countImage = 0;
    capturedImagesPath = [];
    croppedImagesPath = [];
    croppedImageItems = [];
    streamDone = false;

    cameraPlugin.value = _box.read('cameraPlugin') ?? cameraPlugin.value;

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
      if (faces != null) {
        final leftEyeOpenProb = faces[0].leftEyeOpenProbability ?? 0;
        final rightEyeOpenProb = faces[0].rightEyeOpenProbability ?? 0;
        if (leftEyeOpenProb > kedipProb && rightEyeOpenProb > kedipProb) {
          // eyes are open
          debugPrint('====> MATA TERBUKA');
          if (mataTertutup != 0 && mataTertutup <= 3) {
            debugPrint('====> MATA TERBUKA KEMBALI, $mataTertutup kedipan');
            faceCaptured.value = true;
            // simpan temporary
            cropFaceJob(camImg!, faces).then((cropppedImage) {
              saveImage(cropppedImage).then((path) {
                croppedImagesPath.add(path);
                croppedImageItems
                    .add(ImageItem(path, 'citra ${countImage + 1}'));
                countImage++;
                debugPrint('====> Path $countImage : $path');
                faceCaptured.value = false;
              });
            });
            mataTertutup = 0;
          }
        } else {
          // eyes are closed
          mataTertutup++;
          debugPrint('====> MATA TERTUTUP');
        }
      }
      statusProses = 'ONPROCESS';
    } else if (countImage == maxImage || streamDone) {
      onDone();
    }
  }

  void onWajahDetected({
    List<Face>? faces,
    AnalysisImage? inputImage,
    String? statusProses,
  }) async {
    if (countImage < maxImage && !streamDone) {
      final leftEyeOpenProb = faces?[0].leftEyeOpenProbability ?? 0;
      final rightEyeOpenProb = faces?[0].rightEyeOpenProbability ?? 0;
      if (leftEyeOpenProb > kedipProb && rightEyeOpenProb > kedipProb) {
        // eyes are open
        debugPrint('====> MATA TERBUKA');
        if (mataTertutup != 0 && mataTertutup <= 3) {
          debugPrint('====> MATA TERBUKA KEMBALI, $mataTertutup kedipan');
          faceCaptured.value = true;
          // simpan temporary
          doCapture(countImage);
          Future.delayed(const Duration(milliseconds: 250), () {
            mataTertutup = 0;
            faceCaptured.value = false;
          });
          // }
        }
      } else {
        // eyes are closed
        mataTertutup++;
        debugPrint('====> MATA TERTUTUP');
      }
      statusProses = 'ONPROCESS';
    } else if (countImage == maxImage || streamDone) {
      onDone();
    }
  }

  void onCapture(String savedPath, int current) async {
    pathCaptured.value = savedPath;
    capturedImagesPath.add(savedPath);
    update();
  }

  void cropAll() async {
    SmartDialog.showLoading(msg: 'Meng-optimasi citra ...');
    debugPrint('====> captured paths: $capturedImagesPath');
    try {
      int idx = 0;
      await Future.forEach(capturedImagesPath, (String path) async {
        try {
          await cropFaceFileJob(path).then((croppedPath) {
            croppedImagesPath.add(croppedPath);
            croppedImageItems.add(ImageItem(croppedPath, 'citra ${idx + 1}'));

            debugPrint('====> cropped to : $croppedPath');
            idx++;
            update();
          });
        } catch (e) {
          debugPrint('====> cropping fail : $e');
        }
      });
      SmartDialog.dismiss();
    } catch (e) {
      debugPrint('====> all fail : $e');
      rethrow;
    }
  }

  void doCapture(int counter) {
    cameraPageController.updateCameraStatus('ONCAPTURE');
    countImage++;
    update();
  }

  void onDone() {
    faceCaptured.value = false;
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
    cameraScreenController.updateCameraStatus('ONDONE');
    cameraPageController.updateCameraStatus('ONDONE');
    update();
  }

  void streamFinish() {
    streamDone = true;
    update();
    Future.delayed(const Duration(seconds: 1), () {
      debugPrint('====> cropping harus jalan');
      cropAll();
    });
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
      cameraPageController.updateCameraStatus('ONPROCESS');
      streamDone = false;
      update();
      SmartDialog.dismiss();
    });
  }

  void switchCamera() {
    cameraPlugin.value =
        cameraPlugin.value == 'CamerAwesome' ? 'Camera' : 'CamerAwesome';

    _box.write('cameraPlugin', cameraPlugin.value);
    update();
  }
}
