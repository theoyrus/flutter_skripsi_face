import 'dart:io';
import 'dart:math';

import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../model/facedetection.model.dart';

class FaceDetectorSquarePainter extends CustomPainter {
  final FaceDetectionModel model;
  final PreviewSize previewSize;
  final Rect previewRect;
  final bool isBackCamera;

  FaceDetectorSquarePainter({
    required this.model,
    required this.previewSize,
    required this.previewRect,
    required this.isBackCamera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final croppedSize = model.cropRect == null
        ? model.absoluteImageSize
        : Size(
            // TODO Width and height are inverted
            model.cropRect!.size.height,
            model.cropRect!.size.width,
          );

    final ratioAnalysisToPreview = previewSize.width / croppedSize.width;

    bool flipXY = false;
    if (Platform.isAndroid) {
      // Symmetry for Android since native image analysis is not mirrored but preview is
      // It also handles device rotation
      switch (model.imageRotation) {
        case InputImageRotation.rotation0deg:
          if (isBackCamera) {
            flipXY = true;
            canvas.scale(-1, 1);
            canvas.translate(-size.width, 0);
          } else {
            flipXY = true;
            canvas.scale(-1, -1);
            canvas.translate(-size.width, -size.height);
          }
          break;
        case InputImageRotation.rotation90deg:
          if (isBackCamera) {
            // No changes
          } else {
            canvas.scale(1, -1);
            canvas.translate(0, -size.height);
          }
          break;
        case InputImageRotation.rotation180deg:
          if (isBackCamera) {
            flipXY = true;
            canvas.scale(1, -1);
            canvas.translate(0, -size.height);
          } else {
            flipXY = true;
          }
          break;
        default:
          // 270 or null
          if (isBackCamera) {
            canvas.scale(-1, -1);
            canvas.translate(-size.width, -size.height);
          } else {
            canvas.scale(-1, 1);
            canvas.translate(-size.width, 0);
          }
      }
    }

    for (final Face face in model.faces) {
      final Rect boundingBox =
          _getBoundingBox(face, croppedSize, ratioAnalysisToPreview, flipXY);
      // _getBoundingCenterBox(
      //     face, croppedSize, ratioAnalysisToPreview, flipXY);

      canvas.drawRect(
          boundingBox,
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);

      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.center.dx, model.imageRotation, size,
                  model.absoluteImageSize, true) -
              120,
          translateY(face.boundingBox.center.dy, model.imageRotation, size,
                  model.absoluteImageSize, true) -
              120,
          translateX(face.boundingBox.center.dx, model.imageRotation, size,
                  model.absoluteImageSize, true) +
              120,
          translateY(face.boundingBox.center.dy, model.imageRotation, size,
                  model.absoluteImageSize, true) +
              120,
        ),
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  Rect _getBoundingCenterBox(Face face, Size size, double ratio, bool flipXY) {
    final headRect = face.boundingBox;

    double centerX = headRect.center.dx * ratio;
    double centerY = headRect.center.dy * ratio;
    double width = headRect.width * ratio;
    double height = headRect.height * ratio;

    double left = centerX - width / 2;
    double top = centerY - height / 2;
    double right = centerX + width / 2;
    double bottom = centerY + height / 2;

    if (flipXY) {
      final temp = left;
      left = size.width - right;
      right = size.width - temp;
      top = size.height - bottom;
      bottom = size.height - top;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect _getBoundingBox(Face face, Size size, double ratio, bool flipXY) {
    final headRect = face.boundingBox;

    double left = headRect.left * ratio;
    double top = headRect.top * ratio;
    double right = headRect.right * ratio;
    double bottom = headRect.bottom * ratio;

    if (flipXY) {
      final temp = left;
      left = size.width - right;
      right = size.width - temp;
      top = size.height - bottom;
      bottom = size.height - top;
    }
    // debugPrint(
    //     'size: $size, ratio: $ratio, left: $left, top: $top, right: $right, bottom: $bottom, flipXY: $flipXY'
    //     'headRect.left: ${headRect.left}, headRect.top: ${headRect.top}, headRect.right: ${headRect.right}, headRect.bottom: ${headRect.bottom}');

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  bool shouldRepaint(FaceDetectorSquarePainter oldDelegate) {
    return oldDelegate.isBackCamera != isBackCamera ||
        oldDelegate.previewSize.width != previewSize.width ||
        oldDelegate.previewSize.height != previewSize.height ||
        oldDelegate.previewRect != previewRect ||
        oldDelegate.model != model;
  }

  Offset _croppedPosition(
    Point<int> element, {
    required Size croppedSize,
    required Size painterSize,
    required double ratio,
    required bool flipXY,
  }) {
    // calculate the difference between absolute image size and cropped size
    double imageDiffX, imageDiffY;
    if (Platform.isIOS) {
      imageDiffX = model.absoluteImageSize.width - croppedSize.width;
      imageDiffY = model.absoluteImageSize.height - croppedSize.height;
    } else {
      imageDiffX = model.absoluteImageSize.height - croppedSize.width;
      imageDiffY = model.absoluteImageSize.width - croppedSize.height;
    }

    // calculate the position of the element in the cropped image
    Offset croppedPosition = Offset(
          flipXY ? element.y.toDouble() : element.x.toDouble(),
          flipXY ? element.x.toDouble() : element.y.toDouble(),
        ) -
        Offset(
          imageDiffX / 2,
          imageDiffY / 2,
        );

    // scale and translate the position to fit the painter size
    return croppedPosition * ratio +
        Offset(
          (painterSize.width - croppedSize.width * ratio) / 2,
          (painterSize.height - croppedSize.height * ratio) / 2,
        );
  }

  double translateX(double x, InputImageRotation rotation, Size size,
      Size absoluteImageSize, bool isFrontFacing) {
    if (isFrontFacing) {
      rotation = rotation == InputImageRotation.rotation270deg
          ? InputImageRotation.rotation90deg
          : InputImageRotation.rotation270deg;
    }

    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x *
            size.width /
            (Platform.isIOS
                ? absoluteImageSize.height
                : absoluteImageSize.width);
      case InputImageRotation.rotation270deg:
        return size.width -
            x *
                size.width /
                (Platform.isIOS
                    ? absoluteImageSize.height
                    : absoluteImageSize.width);
      default:
        return x * size.width / absoluteImageSize.width;
    }
  }

  double translateY(double y, InputImageRotation rotation, Size size,
      Size absoluteImageSize, bool isFrontFacing) {
    if (isFrontFacing) {
      rotation = rotation == InputImageRotation.rotation270deg
          ? InputImageRotation.rotation90deg
          : InputImageRotation.rotation270deg;
    }

    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y *
            size.height /
            (Platform.isIOS
                ? absoluteImageSize.width
                : absoluteImageSize.height);
      default:
        return y * size.height / absoluteImageSize.height;
    }
  }
}
