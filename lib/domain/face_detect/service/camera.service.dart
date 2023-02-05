import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraService {
  // singleton boilerplate
  static final CameraService _instance = CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraService._internal() {
    // _controller = CameraController(cameras[0], ResolutionPreset.medium);
    // _faceDetector = FaceDetector.instance;
  }

  static CameraService getInstance() {
    return _instance;
  }

  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  late CameraDescription _cameraDescription;

  late InputImageRotation _cameraRotation;
  InputImageRotation get cameraRotation => _cameraRotation;

  late FaceDetector faceDetector;

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future startService(CameraDescription cameraDescription) async {
    _cameraDescription = cameraDescription;
    _cameraController = CameraController(
      _cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _cameraRotation = rotationIntToImageRotation(
      _cameraDescription.sensorOrientation,
    );

    return _cameraController.initialize();
  }

  Future<void> start() async {
    CameraDescription cameraDescription =
        await getCamera(CameraLensDirection.front);

    await startService(cameraDescription);
  }

  Future<void> stop() async {
    if (cameraController.value.isStreamingImages) {
      await cameraController.stopImageStream();
    }
    cameraController.dispose();
  }

  Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }
}

class Throttler {
  Throttler({required this.milliSeconds});

  final int milliSeconds;

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          (milliSeconds)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
