import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../../domain/face_detect/service/image.service.dart';
import '../../../../domain/face_detect/service/mlkit.service.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../widgets/gridView.widget.dart';

class CitrawajahTambahController extends GetxController {
  int maxImage = 10;
  int countImage = 0;
  final MLKitService _mlKitService = MLKitService();

  List<String> croppedImagesPath = [];
  List<ImageItem> croppedImageItems = [];
  final _box = GetStorage();

  @override
  void onInit() async {
    maxImage = 10;
    countImage = 0;
    croppedImagesPath = [];
    croppedImageItems = [];
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
    if (countImage < maxImage) {
      // imglib.Image cropppedImage =
      var cropppedImage = await _mlKitService.cropWajah(camImg!, faces);
      if (cropppedImage != null) {
        var path = await saveImage(cropppedImage);
        croppedImagesPath.add(path);
        croppedImageItems.add(ImageItem(path, 'citra $countImage'));
        countImage++;
        debugPrint('====> Path $countImage : $path');
      }
      statusProses = 'ONPROCESS';
    } else if (countImage == maxImage) {
      statusProses = 'ONDONE';
      onDone();
    }
  }

  void onDone() {
    _box.write('cameraProcess', 'ONDONE');
    update();
  }

  tambahCitra() {}
  hapusCitra(int id) async {
    var path = croppedImageItems[id].image;
    await deleteImage(path);
    croppedImageItems.removeAt(id);
    debugPrint('deleted image [$id], with path=> $path');
    update();
  }

  ulangProses() {
    Get.back();
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.toNamed(Routes.CITRAWAJAH_TAMBAH);
      _box.write('cameraProcess', 'ONPROCESS');
    });
    // Get.offAndToNamed(Routes.CITRAWAJAH_TAMBAH);
  }
}
