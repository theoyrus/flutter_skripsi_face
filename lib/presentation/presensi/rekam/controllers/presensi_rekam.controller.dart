import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../domain/citrawajah/citrawajah.service.dart';
import '../../../../domain/face_detect/camerawesome/camerapage.screen.dart';
import '../../../../domain/face_detect/camerawesome/services/jobs.queue.dart';
import '../../../../domain/face_detect/service/image.service.dart';
import '../../../../domain/face_detect/service/jobs.queue.dart';
import '../../../../domain/face_detect/service/mlkit.service.dart';
import '../../../../domain/face_detect/views/camera.screen.dart';
import '../../../../domain/presensi/presensi.service.dart';
import '../../../../utils/dialog.utils.dart';
import '../../../../utils/snackbar.utils.dart';
import '../../../widgets/gridView.widget.dart';

class PresensiRekamController extends GetxController {
  final MLKitService _mlKitService = MLKitService();
  final CitraWajahService _citraWajahService = CitraWajahService();
  final PresensiService _presensiService = PresensiService();
  final PanelController panelCtrl = PanelController();
  final CameraScreenController cameraScreenController =
      Get.put(CameraScreenController());
  final CameraPageController cameraPageController =
      Get.put(CameraPageController());
  final _box = GetStorage();

  int countImage = 0;
  int mataTertutup = 0;
  double kedipProb = 0.3;
  bool streamDone = false;
  bool cameraReady = false;
  bool isUlang = false;
  final faceCaptured = false.obs;
  final pathCaptured = ''.obs;
  final cameraPlugin = 'CamerAwesome'.obs;
  bool isImageCaptured = false;
  final faceRecognized = false.obs;

  List<String> capturedImagesPath = [];
  List<String> croppedImagesPath = [];
  List<ImageItem> croppedImageItems = [];
  String jenis = '';
  bool isCatatanLatLong = false;

  final MapController mapCtrl = MapController();

  @override
  void onInit() {
    jenis = Get.parameters['jenis']!;
    countImage = 0;
    isImageCaptured = false;
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
            'silahkan kedipkan mata anda untuk meng-capture citra wajah.',
      );
    } else {
      cameraReady = true;
      update();
    }

    super.onInit();
  }

  void onFaceDetected({
    List<Face>? faces,
    CameraImage? camImg,
    String? statusProses,
  }) async {
    if (!streamDone) {
      if (faces != null) {
        final leftEyeOpenProb = faces[0].leftEyeOpenProbability ?? 0;
        final rightEyeOpenProb = faces[0].rightEyeOpenProbability ?? 0;
        if (leftEyeOpenProb > kedipProb && rightEyeOpenProb > kedipProb) {
          // eyes are open
          debugPrint('====> MATA TERBUKA');
          if (mataTertutup != 0 && mataTertutup <= 3) {
            debugPrint('====> MATA TERBUKA KEMBALI, $mataTertutup kedipan');
            faceCaptured.value = true;

            onPause();
            if (!isImageCaptured) {
              isImageCaptured = true;
              // simpan temporary
              cropFaceJob(camImg!, faces).then((cropppedImage) {
                saveImage(cropppedImage).then((path) {
                  // var capturedImage = await _mlKitService.capture(camImg);
                  // var path = await saveImage(capturedImage);
                  var citraCek = ImageItem(path, 'citra-recog');
                  croppedImageItems.add(citraCek);
                  faceCaptured.value = false;
                  recognize(citraCek);
                  update();
                });
              });
              isImageCaptured = false;
            }
            mataTertutup = 0;

            // if (capturedImage != null) {
            //   var path = await saveImage(capturedImage);
            //   croppedImagesPath.add(path);
            //   croppedImageItems
            //       .add(ImageItem(path, 'citra-asli-${countImage + 1}'));
            //   var citraCek = ImageItem(path, 'citra-recog-${countImage + 1}');
            //   // recognize(citraCek);
            //   // onPause();
            //   recognize(citraCek);
            // }
          }
        } else {
          // eyes are closed
          mataTertutup++;
          debugPrint('====> MATA TERTUTUP');
        }
      }

      statusProses = 'ONPROCESS';
    } else if (streamDone) {
      onDone();
    }
  }

  void onWajahDetected({
    List<Face>? faces,
    String? statusProses,
  }) async {
    if (!streamDone) {
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
    } else if (streamDone) {
      onDone();
    }
  }

  void streamFinish() {
    streamDone = true;
    update();
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
    Future.delayed(const Duration(seconds: 1), () {
      cropCitra();
    });
  }

  void cropCitra() async {
    SmartDialog.showLoading(msg: 'Meng-optimasi citra ...');
    debugPrint('====> captured paths: $capturedImagesPath');
    try {
      int idx = 0;
      await Future.forEach(capturedImagesPath, (String path) async {
        try {
          await cropFaceFileJob(path).then((croppedPath) {
            var citraCek = ImageItem(croppedPath, 'citra-recog');
            croppedImageItems.add(citraCek);
            faceCaptured.value = false;
            recognize(citraCek);
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

  void onCapture(String savedPath, int current) async {
    pathCaptured.value = savedPath;
    capturedImagesPath.add(savedPath);
    streamFinish();
    update();
  }

  void doCapture(int counter) {
    cameraPageController.updateCameraStatus('ONCAPTURE');
    countImage++;
    update();
  }

  void recognize(ImageItem citra) async {
    SmartDialog.showLoading(msg: 'Memvalidasi citra ...');
    await _citraWajahService.recognize(citra).then((data) {
      faceRecognized.value = true;
      update();
      AppSnackBar.showSnackBar(title: "Done", message: 'Citra dikenali');
    }).catchError((_) {
      AppSnackBar.showErrorSnackBar(title: 'Opps', message: _.toString());
    });
    SmartDialog.dismiss();
  }

  void rekam() async {
    SmartDialog.showLoading(msg: 'Merekam presensi ...');
    await _presensiService.rekam(jenis).then((data) {
      AppSnackBar.showSnackBar(
          title: "Sukses", message: 'Berhasil rekam presensi :)');
      Future.delayed(const Duration(seconds: 3), () {
        Get.close(1);
        Get.back(result: true);
      });
    }).catchError((_) {
      AppSnackBar.showErrorSnackBar(title: 'Opps', message: _.toString());
    });
    SmartDialog.dismiss();
  }

  void onDone() {
    cameraScreenController.updateCameraStatus('ONDONE');
    cameraPageController.updateCameraStatus('ONDONE');
    update();
  }

  void onPause() {
    cameraScreenController.updateCameraStatus('ONPAUSE');
    update();
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
  }

  ulangProses() {
    SmartDialog.showLoading(msg: 'Tunggu sebentar ...');
    croppedImageItems.clear();
    clearCache();
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

  ambilLokasi() {
    // mapCtrl.pointToLatLng(point);
  }

  void switchCamera() {
    cameraPlugin.value =
        cameraPlugin.value == 'CamerAwesome' ? 'Camera' : 'CamerAwesome';

    _box.write('cameraPlugin', cameraPlugin.value);
    update();
  }
}
