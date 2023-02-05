import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;

import 'camera.service.dart';
import 'image.service.dart';

class MLKitService {
  // singleton boilerplate
  static final MLKitService _instance = MLKitService._internal();

  factory MLKitService() {
    return _instance;
  }

  MLKitService._internal();

  // service injection
  final CameraService _cameraService = CameraService();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  void initialize() {
    /// Untuk inisialisasi service ini
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: false,
        enableLandmarks: false,
        // performanceMode: FaceDetectorMode.accurate,
      ),
    );

    debugPrint('====> ML Kits initialized');
  }

  void stop() {
    _faceDetector.close();
  }

  // late CameraController _cameraController;
  // CameraController get cameraController => _cameraController;

  Future<List<Face>> detectFaces(InputImage image) async {
    return await faceDetector.processImage(image);
  }

  Future processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: _cameraService.cameraRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    debugPrint('====> Image Rotation: ${inputImageData.imageRotation}');
    debugPrint('====> Panjang Byte ${bytes.length}');

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;

    // widget.onImage(inputImage);
  }

  imglib.Image convertCameraImage(
      CameraImage image, CameraLensDirection camDir) {
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height); // buat gambar buffer
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride! * (x / 2).floor() +
            uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (camDir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  Future<dynamic> cropWajah(CameraImage image, dynamic result) async {
    imglib.Image convertedImage =
        convertCameraImage(image, CameraLensDirection.front);
    Face oneFace;
    for (oneFace in result) {
      double x, y, w, h;
      x = (oneFace.boundingBox.left - 10);
      y = (oneFace.boundingBox.top - 10);
      w = (oneFace.boundingBox.width + 10);
      h = (oneFace.boundingBox.height + 10);
      imglib.Image croppedImage = imglib.copyCrop(
          convertedImage, x.round(), y.round(), w.round(), h.round());
      croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
      debugPrint('====> cropped image length: ${croppedImage.length}');
      return croppedImage;
      // res = recog(croppedImage);
      // finalResult.add(res, oneFace);
    }
  }

  Future<imglib.Image> cropFace(CameraImage image, Face faceDetected) async {
    // Future<imglib.Image> cropFace(InputImage image, Face faceDetected) async {
    imglib.Image? convertedImage = convertToImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage!, x.round(), y.round(), w.round(), h.round());
  }

  Future getFaceMaps(List<Face> faces) async {
    List<Map<String, int>> faceMaps = [];
    for (Face face in faces) {
      int x = face.boundingBox.left.toInt();
      int y = face.boundingBox.top.toInt();
      int w = face.boundingBox.width.toInt();
      int h = face.boundingBox.height.toInt();
      Map<String, int> thisMap = {'x': x, 'y': y, 'w': w, 'h': h};
      faceMaps.add(thisMap);
    }
    return faceMaps;
  }

  Future<List<int>> convertCameraImageToImage(CameraImage cameraImage) async {
    try {
      final image = imglib.decodeImage(cameraImage.planes[0].bytes);
      final imageData = imglib.encodeJpg(image!);
      return Future.value(imageData);
    } catch (e) {
      print('Error decoding image: $e');
      return Future.value(null);
    }
  }
}
