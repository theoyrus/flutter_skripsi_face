import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';

import '../../../utils/date_time.utils.dart';

imglib.Image? convertToImage(CameraImage image) {
  try {
    imglib.Image? img;
    if (image.format.group == ImageFormatGroup.yuv420) {
      img = _convertYUV420(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      img = _convertBGRA8888(image);
    }

    return img;
  } catch (e) {
    debugPrint(">>>>>>>>>>>> ERROR:$e");
  }
  return null;
}

imglib.Image _convertBGRA8888(CameraImage image) {
  return imglib.Image.fromBytes(
    image.width,
    image.height,
    image.planes[0].bytes,
    format: imglib.Format.bgra,
  );
}

imglib.Image _convertYUV420(CameraImage image) {
  int width = image.width;
  int height = image.height;
  var img = imglib.Image(width, height);
  const int hexFF = 0xFF000000;
  final int uvyButtonStride = image.planes[1].bytesPerRow;
  final int? uvPixelStride = image.planes[1].bytesPerPixel;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride! * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
      final int index = y * width + x;
      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      img.data[index] = hexFF | (b << 16) | (g << 8) | r;
    }
  }

  return img;
}

Future saveImage(imglib.Image imageData) async {
  debugPrint('====> execute saveImage');
  final directory = await getTemporaryDirectory();

  // Generate a unique file name for the image
  var nowFormatted = fullDateTimeNoSpace(DateTime.now());
  String namaImage = 'citra-$nowFormatted';
  final fileName = '$namaImage.jpg';

  // Create the file in the directory
  final imagePath = '${directory.path}/$fileName';
  final file = File(imagePath);
  await file.writeAsBytes(imglib.encodeJpg(imageData));

  // Return the path of the saved image
  return imagePath;
}

Future deleteImage(path) async {
  final imagePath = path;
  final file = File(imagePath);
  file.delete();
}

Future<void> clearCache() async {
  Directory cacheDir = await getTemporaryDirectory();
  if (cacheDir.existsSync()) {
    cacheDir.listSync().forEach((file) {
      if (file is File) {
        debugPrint('deleting file $file');
        file.deleteSync();
      }
    });
  }
}
