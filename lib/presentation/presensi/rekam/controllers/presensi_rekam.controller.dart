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
import '../../../../domain/face_detect/service/image.service.dart';
import '../../../../domain/face_detect/service/mlkit.service.dart';
import '../../../../domain/presensi/presensi.service.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../utils/dialog.utils.dart';
import '../../../../utils/snackbar.utils.dart';
import '../../../widgets/gridView.widget.dart';

class PresensiRekamController extends GetxController {
  final MLKitService _mlKitService = MLKitService();
  final CitraWajahService _citraWajahService = CitraWajahService();
  final PresensiService _presensiService = PresensiService();
  final PanelController panelCtrl = PanelController();

  int countImage = 0;
  int mataTertutup = 0;
  double kedipProb = 0.3;
  bool streamDone = false;
  bool cameraReady = false;
  final faceCaptured = false.obs;
  bool isImageCaptured = false;
  final faceRecognized = false.obs;
  final _box = GetStorage();
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
    if (Get.parameters['ulang'] == null) {
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
      var cropppedImage = await _mlKitService.cropWajah(camImg!, faces);
      // var capturedImage = await _mlKitService.capture(camImg);
      if (cropppedImage != null) {
        final leftEyeOpenProb = faces?[0].leftEyeOpenProbability ?? 0;
        final rightEyeOpenProb = faces?[0].rightEyeOpenProbability ?? 0;
        if (leftEyeOpenProb > kedipProb && rightEyeOpenProb > kedipProb) {
          // eyes are open
          debugPrint('====> MATA TERBUKA');
          if (mataTertutup != 0 && mataTertutup <= 3) {
            debugPrint('====> MATA TERBUKA KEMBALI, $mataTertutup kedipan');
            faceCaptured.value = true;
            await Future.delayed(const Duration(milliseconds: 100));

            onPause();
            if (!isImageCaptured) {
              isImageCaptured = true;
              // simpan temporary
              croppedImageItems.clear();
              await clearCache();
              var path = await saveImage(cropppedImage);
              // var capturedImage = await _mlKitService.capture(camImg);
              // var path = await saveImage(capturedImage);
              var citraCek = ImageItem(path, 'citra-recog');
              croppedImageItems.add(citraCek);
              recognize(citraCek);
              update();
            }
            mataTertutup = 0;
            faceCaptured.value = false;
            isImageCaptured = false;

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
      statusProses = 'ONDONE';
      onDone();
    }
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
    _box.write('cameraProcess', 'ONDONE');
    update();
  }

  void onPause() {
    _box.write('cameraProcess', 'ONPAUSE');
    update();
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
  }

  ulangProses() {
    Get.close(1);
    Get.back();
    Future.delayed(const Duration(seconds: 1), () {
      Get.toNamed(Routes.PRESENSI_REKAM,
          parameters: {'jenis': jenis, 'ulang': 'YA'});
      _box.write('cameraProcess', 'ONPROCESS');
    });
  }

  ambilLokasi() {
    // mapCtrl.pointToLatLng(point);
  }
}
