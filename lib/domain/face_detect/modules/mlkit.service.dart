// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import '../painter/face_detect.painter.dart';
// import 'package:tuple/tuple.dart';

// import 'camera.service.dart';

// class MLKitService {
//   // singleton boilerplate
//   static final MLKitService _cameraServiceService = MLKitService._internal();

//   factory MLKitService() {
//     return _cameraServiceService;
//   }

//   // singleton boilerplate
//   MLKitService._internal();

//   // service injection
//   final CameraService _cameraService = CameraService();

//   late FaceDetector _faceDetector;

//   FaceDetector get faceDetector => _faceDetector;

//   void initialize() {
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//           enableClassification: true,
//           enableTracking: true,
//           enableLandmarks: true,
//           performanceMode: FaceDetectorMode.accurate),
//     );

//     print('ML kid initialized');
//   }

// /*  Future<List<Face>> getFacesFromImage(CameraImage image) async {
//     /// preprocess the image  🧑🏻‍🔧
//     InputImageData _firebaseImageMetadata = InputImageData(
//       imageRotation: _cameraService.cameraRotation,
//       inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw)!,
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       planeData: image.planes.map(
//         (Plane plane) {
//           return InputImagePlaneMetadata(
//             bytesPerRow: plane.bytesPerRow,
//             height: plane.height,
//             width: plane.width,
//           );
//         },
//       ).toList(),
//     );

//     /// Transform the image input for the _faceDetector 🎯
//     InputImage _firebaseVisionImage = InputImage.fromBytes(
//       bytes: image.planes[0].bytes,
//       inputImageData: _firebaseImageMetadata,
//     );

//     // proces the image and makes inference 🤖
//     List<Face> faces =
//         await this._faceDetector.processImage(_firebaseVisionImage);
//     return faces;
//   }*/

//   Future<Tuple2<List<Face>, CustomPaint>> getFacesFromImage(
//       CameraImage image) async {
//     CustomPaint? customPaint;
//     final WriteBuffer allBytes = WriteBuffer();
//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//     int width = image.planes[0].bytesPerRow;
//     print(
//         'image plane ${image.planes[0].width} ${image.planes[0].bytesPerRow}');
//     final Size imageSize = Size(width.toDouble(), image.height.toDouble());

//     // final camera = cameras![0];
//     // final imageRotation =
//     //     InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
//     //         InputImageRotation.Rotation_0deg;

//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(image.format.raw) ??
//             InputImageFormat.nv21;

//     final planeData = image.planes.map(
//       (Plane plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList();

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: _cameraService.cameraRotation,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );

//     final inputImage =
//         InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

//     // proces the image and makes inference 🤖
//     List<Face> faces = await _faceDetector.processImage(inputImage);
//     if (inputImage.inputImageData?.size != null &&
//         inputImage.inputImageData?.imageRotation != null) {
//       final painter = FaceDetectorPainter(
//           faces,
//           inputImage.inputImageData!.size,
//           inputImage.inputImageData!.imageRotation);
//       customPaint = CustomPaint(
//         painter: painter,
//       );
//     } else {
//       customPaint = null;
//     }
//     return Tuple2(faces, customPaint!);
//   }
// }
