import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../presentation/widgets/menu.widget.dart';
import '../painter/face_detect.painter.dart';
import '../service/camera.service.dart';
import '../service/mlkit.service.dart';

class LiveCameraController extends GetxController {
  CameraService cameraService = CameraService();
  MLKitService mlkitService = MLKitService();

  CustomPaint? customPaint;
  late InputImage inputImage;
  bool isInitialized = false;
  bool isCameraReady = false;
  bool _isProcess = false;
  String text = '';
  List<Face>? faceDetected;

  @override
  void onInit() {
    // ketika widget di-load

    start();
    debugPrint('====> onInit');
    super.onInit();
  }

  @override
  void onClose() async {
    debugPrint('====> stopping .............');
    if (isCameraReady) {
      await cameraService.stop();
      debugPrint('camera closed');
      isCameraReady = false;
    }
    mlkitService.stop();
    debugPrint('====> MLKit stopped.');
    _isProcess = false;
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    await cameraService.start();
  }

  Future<void> start() async {
    debugPrint('====> starting ...............');

    await _initializeCamera().then((_) {
      debugPrint(
          '====> camera started, ${cameraService.cameraController.description}');
      isCameraReady = true;
      update();
    });

    mlkitService.initialize();

    isInitialized = true;
    if (isCameraReady) {
      cameraService.cameraController
          .startImageStream((CameraImage image) async {
        if (_isProcess) return;
        _isProcess = true; // atur sedang memproses

        text = '';

        inputImage = await mlkitService.processCameraImage(image);

        debugPrint('====> planes length ${image.planes.length}');
        final faces = await mlkitService.faceDetector.processImage(inputImage);
        faceDetected = faces;
        debugPrint('====> wajah ${faces.length}');
        debugPrint(
            '====> imageData S: ${inputImage.inputImageData?.size} | R: ${inputImage.inputImageData?.imageRotation}');
        // jika terdeteksi
        if (faces.isNotEmpty &&
            inputImage.inputImageData?.size != null &&
            inputImage.inputImageData?.imageRotation != null) {
          final painter = FaceDetectorPainter(
              faces,
              inputImage.inputImageData!.size,
              inputImage.inputImageData!.imageRotation);
          customPaint = CustomPaint(painter: painter);
          text = 'DETECTED';
          update();

          debugPrint('====> FACES DETECTED : $faces');
          // _isProcess = false; // atur sudah tidak memproses
        } else {
          customPaint = null;
          text = 'NOTDETECTED';
          update();
          debugPrint('====> FACES NOTDETECTED : $faces');
          debugPrint(
              '====> InputImage size : ${inputImage.inputImageData?.planeData}');
          // await Future.delayed(const Duration(milliseconds: 300));
          // await cameraService.cameraController.stopImageStream();
          // await cameraService.cameraController.pausePreview();
          // debugPrint('====> PAUSED');
          // _isProcess = false; // atur sudah tidak memproses
        }

        _isProcess = false; // atur sudah tidak memproses
      });
    } else {
      _isProcess = false;
    }
  }

  Future<void> stop() async {
    await cameraService.stop();
  }

  Future<void> saveFullImage(List<int> imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/full_image.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
  }
}

// class FaceDetectionController extends GetxController {
//   CameraController? cameraController;
// }

class LiveCameraWidget extends GetView<LiveCameraController> {
  const LiveCameraWidget({super.key});

  final BorderRadius radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveCameraController>(
      init: LiveCameraController(),
      builder: (controller) {
        if (!controller.isCameraReady) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
              ElevatedButton(
                  onPressed: () => controller.start(),
                  child: const Text('Inisialisasi ulang'))
            ],
          );
        }
        // if (!controller.isInitialized.isTrue) {
        //   return const Center(
        //     child: SizedBox(
        //       height: 20,
        //       width: 20,
        //       child: CircularProgressIndicator(),
        //     ),
        //   );
        // }
        return WillPopScope(
          onWillPop: () async {
            controller.onClose();
            return true;
          },
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: Get.size.aspectRatio,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: Get.width,
                    height: Get.width *
                        controller
                            .cameraService.cameraController.value.aspectRatio,
                    child: CameraPreview(
                        controller.cameraService.cameraController),
                  ),
                ),
              ),
              // AspectRatio(
              //   aspectRatio:
              //       controller.cameraService.cameraController.value.aspectRatio,
              //   child: Stack(
              //     fit: StackFit.expand,
              //     children: [
              // if (controller.isCameraReady)
              //   CameraPreview(controller.cameraService.cameraController),
              if (controller.customPaint != null) controller.customPaint!,
              Center(
                  child: Text(
                controller.text,
                style: const TextStyle(color: Colors.green),
              )),
              SlidingUpPanel(
                collapsed: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: radius,
                  ),
                  child: const Center(
                    child: Text(
                      "Daftar citra wajah",
                    ),
                  ),
                ),
                parallaxEnabled: true,
                panel: Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.blueGrey,
                  //   borderRadius: radius,
                  // ),
                  padding: const EdgeInsets.only(top: 20),
                  color: Theme.of(context).backgroundColor,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      MenuTitleWidget(title: 'Siap Training'),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: 'Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                      MenuTilesWidget(
                        title: '1Pengaturan',
                        description: 'Kustomisasi aplikasi',
                      ),
                    ],
                  ),
                ),
                borderRadius: radius,
              ),
            ],
          ),
          // ),
          // ],
          // ),
        );
      },
    );
  }

  // Widget _liveCameraBody() {
  //   return Container(
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         Transform.scale(
  //           // scale: ,
  //           child: CameraPreview(controller),
  //         )
  //       ],
  //     ),
  //   );
}
