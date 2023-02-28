import 'dart:io';
import 'dart:typed_data';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_editor/image_editor.dart';

/// Flip picture from path with image_editor package
Future<String> flipPicture(String path) async {
  final file = File(path);

  // 1. check file exists
  if (!file.existsSync()) {
    return path;
  }
  Uint8List? imageBytes = await file.readAsBytes();

  // 2. flip the image on the X axis
  final ImageEditorOption option = ImageEditorOption();
  option.addOption(const FlipOption(horizontal: true));
  imageBytes =
      await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);

  // 3. write the image back to disk
  await file.delete();
  await file.writeAsBytes(imageBytes!);
  return path;
}

/// Flip picture from path with image package
Future flipImage(String path) async {
  // Load the image from file
  final File file = File(path);
  if (!file.existsSync()) {
    return path;
  }
  final Uint8List bytes = await file.readAsBytes();
  imglib.Image? image = imglib.decodeImage(bytes);

  // Flip the image horizontally
  image = imglib.flipHorizontal(image!);

  // Save the flipped image back to the same file
  file.writeAsBytesSync(imglib.encodeJpg(image));
}

/// Convert CamerAwesome AnalysisImage to YUV420
/// but its not work :(
imglib.Image convertAnalysisImage2YUV420(AnalysisImage image) {
  int width = image.width;
  int height = image.height;
  var img = imglib.Image(width, height);
  const int hexFF = 0xFF000000;
  final int uvButtonStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = uvButtonStride ~/ 2; // hitung manual
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride * (x / 2).floor() + uvButtonStride * (y / 2).floor();
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
