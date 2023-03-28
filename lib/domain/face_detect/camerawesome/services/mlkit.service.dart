import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';

import '../../../../utils/date_time.utils.dart';
import 'image.service.dart';

/// crop face from CamerAwesome AnalysisImage via faces from google ml kit
/// but the result is black image :(
Future<imglib.Image> cropFaceImage(AnalysisImage image, dynamic result) async {
  // Membuat objek Uint8List dengan ukuran yang sesuai dari data input image
  Uint8List uint8list = Uint8List(image.planes[0].bytes.length);
  int index = 0;
  for (var plane in image.planes) {
    uint8list.setRange(index, index + plane.bytes.length, plane.bytes);
    index += plane.bytes.length;
  }

  // Membuat objek imglib.Image dari Uint8List yang telah diambil dari input image
  imglib.Image? convertedImage;
  // debugPrint('====> image.format: ${image.format}');
  switch (image.format) {
    case InputAnalysisImageFormat.yuv_420:
      convertedImage = imglib.Image.fromBytes(
        image.width,
        image.height,
        uint8list,
        // format: imglib.Format.yuv420, // TODO: di-comment dulu
      );
      break;
    case InputAnalysisImageFormat.bgra8888:
      convertedImage = imglib.Image.fromBytes(
        image.width,
        image.height,
        uint8list,
      );
      break;
    case InputAnalysisImageFormat.jpeg:
      convertedImage = imglib.decodeJpg(uint8list);
      break;
    case InputAnalysisImageFormat.nv21:
      // debugPrint('====> width: ${image.width} x height: ${image.height}');
      convertedImage = imglib.Image.fromBytes(
        image.width,
        image.height,
        // uint8list,
        image.nv21Image!,
        format: imglib.Format.bgra,
      );

      // convertedImage = convertAnalysisImage2YUV420(image);
      break;
    case InputAnalysisImageFormat.unknown:
      throw ArgumentError('Unknown image format');
  }

  // Proses cropping citra wajah
  Face oneFace;
  for (oneFace in result) {
    double x, y, w, h;
    x = (oneFace.boundingBox.left - 10);
    y = (oneFace.boundingBox.top - 10);
    w = (oneFace.boundingBox.width + 10);
    h = (oneFace.boundingBox.height + 10);
    imglib.Image croppedImage = imglib.copyCrop(
      convertedImage!,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );
    croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
    // debugPrint('====> cropped image length: ${croppedImage.length}');
    return croppedImage;
  }
  throw ArgumentError('No face detected');
}

/// crop face from CamerAwesome InputImage and faces from google ml kit
/// but the result is error/corrupt image  :(
Future<imglib.Image?> cropCitraWajah(
    InputImage inputImageData, List<Face> faces) async {
  // Jika tidak ditemukan wajah pada gambar, maka kembalikan null
  if (faces.isEmpty) {
    return null;
  }
  // debugPrint(
  //     '====> inputImageData: $inputImageData, ukuran: ${inputImageData.bytes}');
  // Konversi data gambar dari inputImageData ke ui.Image
  ui.Image inputImage = await decodeImageFromList(inputImageData.bytes!);

  // Ambil area wajah pada gambar dan konversi ke format imgLib
  final Face face = faces.first;
  final int x = face.boundingBox.left.toInt();
  final int y = face.boundingBox.top.toInt();
  final int width = face.boundingBox.width.toInt();
  final int height = face.boundingBox.height.toInt();
  final Uint8List croppedImageData = await inputImage.toByteData().then(
      (byteData) => byteData!.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  final imglib.Image croppedImage = imglib.decodeImage(croppedImageData.sublist(
      y * inputImage.width * 4 + x * 4,
      (y + height) * inputImage.width * 4 + (x + width) * 4))!;

  // Kembalikan hasil crop
  return croppedImage;
}

/// crop face from saved image path and faces from google ml kit
/// current working solution, but this is heavy task
Future<String> cropFaceFromFile(String fromPath, {String toName = ''}) async {
  // flip first
  fromPath = await flipPicture(fromPath);
  // debugPrint('====> flip done');

  final inputImage = InputImage.fromFilePath(fromPath);
  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableLandmarks: false,
  );
  final faceDetect = FaceDetector(options: options);
  final faces = await faceDetect.processImage(inputImage);
  if (faces.isNotEmpty) {
    // crop wajah dari image simpan ke jpg
    final Face face = faces.first;
    // final int x = face.boundingBox.left.toInt();
    // final int y = face.boundingBox.top.toInt();
    // final int width = face.boundingBox.width.toInt();
    // final int height = face.boundingBox.height.toInt();

    const int margin = 100;
    final int x = (face.boundingBox.left - margin).toInt();
    final int y = (face.boundingBox.top - margin).toInt();
    final int width = (face.boundingBox.width + 2 * margin).toInt();
    final int height = (face.boundingBox.height + 2 * margin).toInt();

    // debugPrint('====> face found; ${face.boundingBox}');
    // Load image from file
    final bytes = await File(fromPath).readAsBytes();
    final image = imglib.decodeImage(bytes);

    // Crop face from image
    imglib.Image croppedImage = imglib.copyCrop(image!, x, y, width, height);
    // resize to 150px
    croppedImage = imglib.copyResizeCropSquare(croppedImage, 150);

    // Save cropped image to file
    final cacheDir = await getTemporaryDirectory();
    var nowFormatted = fullDateTimeNoSpace(DateTime.now());
    toName = toName.isNotEmpty ? toName : nowFormatted;
    final filePath = '${cacheDir.path}/$toName.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imglib.encodeJpg(croppedImage));
    // debugPrint('====> saved face to $filePath');
    return filePath;
  }
  throw '$fromPath tidak ada wajah';
}
