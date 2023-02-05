import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraService {
  // singleton boilerplate
  static final CameraService _cameraServiceService = CameraService._internal();

  factory CameraService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  CameraService._internal();

  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  late CameraDescription _cameraDescription;

  late InputImageRotation _cameraRotation;
  InputImageRotation get cameraRotation => _cameraRotation;

  late String _imagePath;
  String get imagePath => _imagePath;

  Future startService(CameraDescription cameraDescription) async {
    _cameraDescription = cameraDescription;
    _cameraController = CameraController(
      _cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      /* imageFormatGroup: ImageFormatGroup.jpeg, */
    );

    // sets the rotation of the image
    _cameraRotation = rotationIntToImageRotation(
      _cameraDescription.sensorOrientation,
    );

    // Next, initialize the controller. This returns a Future.
    return _cameraController.initialize();
  }

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

  /// takes the picture and saves it in the given path 📸
  Future<XFile> takePicture() async {
    XFile file = await _cameraController.takePicture();
    _imagePath = file.path;
    return file;
  }

  /// returns the image size 📏
  Size getImageSize() {
    return Size(
      _cameraController.value.previewSize?.height ?? 0,
      _cameraController.value.previewSize?.width ?? 0,
    );
  }

  dispose() {
    _cameraController.dispose();
  }
}
