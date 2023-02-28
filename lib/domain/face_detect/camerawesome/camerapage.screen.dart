import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../presentation/widgets/gridView.widget.dart';
import '../../../presentation/widgets/listViewSlider.widget.dart';
import '../../../utils/date_time.utils.dart';
import '../service/image.service.dart';
import 'model/facedetection.model.dart';
import 'painter/facedetectorcontour.painter.dart';
import 'painter/facedetectorsquare.painter.dart';
import 'services/image.service.dart';
import 'services/mlkit.service.dart';

class CameraPageController extends GetxController {
  var cameraStatus = 'ONPROCESS'.obs;

  void updateCameraStatus(String status) {
    cameraStatus.value = status;
  }
}

class CameraPage extends StatefulWidget {
  /// Event ketika wajah ditemukan
  final void Function({
    List<Face>? faces,
    String? statusProses,
  })? onFaceDetected;

  final void Function({String savedPath, int current})? onCapture;

  const CameraPage({
    this.onFaceDetected,
    this.onCapture,
    super.key,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _faceDetectionController = BehaviorSubject<FaceDetectionModel>();
  final Throttler throttler = Throttler(milliSeconds: 300);
  final CameraPageController cameraPageController =
      Get.put(CameraPageController());

  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableLandmarks: false,
  );
  late final faceDetector = FaceDetector(options: options);
  bool cameraReady = false;
  bool takePhoto = false;
  String statusProses = 'ONPROCESS';

  List<ImageItem> croppedImageItems = [];
  int countImage = 0;
  List<String> citraAsliList = [];

  @override
  void initState() {
    super.initState();
    // ambil state camera saat ini
    setState(() {
      statusProses = cameraPageController.cameraStatus.value;
    });
    if (statusProses == 'ONPROCESS') {
      startCamerAwesome();
    }
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _faceDetectionController.close();
    super.dispose();
  }

  void startCamerAwesome() {
    setState(() {
      cameraReady = true;
    });
  }

  void stopCamerAwesome() {
    setState(() {
      cameraReady = false;
    });
    deactivate();
    _faceDetectionController.close();
  }

  void doCapture() {
    setState(() {
      takePhoto = true;
    });
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        takePhoto = false;
      });
      cameraPageController.updateCameraStatus('ONPROCESS');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          if (cameraReady)
            CameraAwesomeBuilder.custom(
              sensor: Sensors.front,
              aspectRatio: CameraAspectRatios.ratio_1_1,
              previewFit: CameraPreviewFit.cover,
              saveConfig: SaveConfig.photo(
                pathBuilder: () => _path(CaptureMode.photo),
              ),
              onImageForAnalysis: (img) => _analyzeImage(img),
              imageAnalysisConfig: AnalysisConfig(
                outputFormat: InputAnalysisImageFormat.nv21,
                width: 10,
                maxFramesPerSecond: 30,
              ),
              builder: (cameraState, previewSize, previewRect) {
                return cameraState.when(
                  onPreparingCamera: (state) =>
                      const Center(child: CircularProgressIndicator()),
                  onPhotoMode: (state) {
                    if (takePhoto) {
                      state.takePhoto().then((path) async {
                        // await flipImage(path);
                        citraAsliList.add(path);
                        // eksekusi onCapture
                        widget.onCapture
                            ?.call(savedPath: path, current: countImage);
                        debugPrint('====> cekrek $countImage; $path');
                        countImage++;
                      });
                    }
                    // debugPrint('====> onPhotoMode, is takePhoto: $takePhoto');
                    return _FaceCamPreviewWidget(
                      cameraState: state,
                      faceDetectionStream: _faceDetectionController,
                      previewSize: previewSize,
                      previewRect: previewRect,
                    );
                  },
                );
              },
            ),
          // if (statusProses != 'ONDONE') const CircularProgressIndicator(),
          if (statusProses == 'ONDONE')
            Center(
              child: Column(
                children: const [
                  Text(
                    'Deteksi Wajah Selesai',
                    style: TextStyle(color: Colors.green, fontSize: 30),
                  ),
                ],
              ),
            ),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //           onPressed: () {
          //             setState(() {
          //               cameraReady = false;
          //             });
          //             Future.delayed(Duration(seconds: 1), () {
          //               setState(() {
          //                 cameraReady = true;
          //               });
          //             });
          //           },
          //           child: const Text('Restart Camera')),
          //       ElevatedButton(
          //           onPressed: () {
          //             setState(() {
          //               cameraReady = false;
          //             });
          //             deactivate();
          //           },
          //           child: const Text('Stop Camera')),
          //       ElevatedButton(
          //           onPressed: () {
          //             doCapture();
          //           },
          //           child: const Text('Capture')),
          //     ],
          //   ),
          // ),
          ListViewSliderWidget(
            images: citraAsliList,
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }

  Future _analyzeImage(AnalysisImage img) async {
    if (!cameraReady) return false;
    throttler.run(() async {
      debugPrint('====> statusProses: $statusProses');
      setState(() {
        statusProses = cameraPageController.cameraStatus.value;
      });
      if (statusProses == 'ONDONE') {
        stopCamerAwesome();
      }
      if (statusProses == 'ONCAPTURE') {
        doCapture();
      }
      final Size imageSize = Size(img.width.toDouble(), img.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotation.values.byName(img.rotation.name);

      final planeData = img.planes.map(
        (ImagePlane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final InputImage inputImage;
      if (Platform.isIOS) {
        final inputImageData = InputImageData(
          size: imageSize,
          imageRotation: imageRotation, // FIXME: seems to be ignored on iOS...
          inputImageFormat: inputImageFormat(img.format),
          planeData: planeData,
        );

        final WriteBuffer allBytes = WriteBuffer();
        for (final ImagePlane plane in img.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();

        inputImage =
            InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
      } else {
        inputImage = InputImage.fromBytes(
          bytes: img.nv21Image!,
          inputImageData: InputImageData(
            imageRotation: imageRotation,
            inputImageFormat: InputImageFormat.nv21,
            planeData: planeData,
            size: Size(img.width.toDouble(), img.height.toDouble()),
          ),
        );
      }

      try {
        var faces = await faceDetector.processImage(inputImage);
        if (faces.isNotEmpty) {
          // wajah ditemukan
          // eksekusi onFaceDetected
          widget.onFaceDetected?.call(
            faces: faces,
            statusProses: statusProses,
          );
        }
        _faceDetectionController.add(
          FaceDetectionModel(
            faces: faces,
            absoluteImageSize: inputImage.inputImageData!.size,
            rotation: 0,
            imageRotation: imageRotation,
            cropRect: img.cropRect,
          ),
        );
        // debugPrint("====> banyak wajah : ${faces.length.toString()} faces");
      } catch (error) {
        // debugPrint("====> error deteksi wajah: $error");
      }
    });
  }

  Future<String> _path(CaptureMode captureMode) async {
    final Directory extDir = await getTemporaryDirectory();
    final citraDir =
        await Directory('${extDir.path}/citra').create(recursive: true);
    final String fileExtension =
        captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    // Generate nama file citra timetamp unik
    var nowFormatted = fullDateTimeNoSpace(DateTime.now());
    String namaFile = 'citra-$nowFormatted';
    final String filePath = '${citraDir.path}/$namaFile.$fileExtension';
    return filePath;
  }

  InputImageFormat inputImageFormat(InputAnalysisImageFormat format) {
    switch (format) {
      case InputAnalysisImageFormat.bgra8888:
        return InputImageFormat.bgra8888;
      case InputAnalysisImageFormat.nv21:
        return InputImageFormat.nv21;
      default:
        return InputImageFormat.yuv420;
    }
  }
}

class _FaceCamPreviewWidget extends StatelessWidget {
  final CameraState cameraState;
  final Stream<FaceDetectionModel> faceDetectionStream;
  final PreviewSize previewSize;
  final Rect previewRect;

  const _FaceCamPreviewWidget({
    required this.cameraState,
    required this.faceDetectionStream,
    required this.previewSize,
    required this.previewRect,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: StreamBuilder(
        stream: cameraState.sensorConfig$,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return StreamBuilder<FaceDetectionModel>(
              stream: faceDetectionStream,
              builder: (_, faceModelSnapshot) {
                if (!faceModelSnapshot.hasData) return const SizedBox();

                // final painterSquare = FaceDetectorSquarePainter(
                //   model: faceModelSnapshot.requireData,
                //   previewSize: previewSize,
                //   previewRect: previewRect,
                //   isBackCamera: false,
                // );

                final painterContour = FaceDetectorContourPainter(
                  model: faceModelSnapshot.requireData,
                  previewSize: previewSize,
                  previewRect: previewRect,
                  isBackCamera: false,
                );
                return CustomPaint(
                  // painter: painterSquare,
                  painter: painterContour,
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension InputImageRotationConversion on InputImageRotation {
  double toRadians() {
    final degrees = toDegrees();
    return degrees * 2 * pi / 360;
  }

  int toDegrees() {
    switch (this) {
      case InputImageRotation.rotation0deg:
        return 0;
      case InputImageRotation.rotation90deg:
        return 90;
      case InputImageRotation.rotation180deg:
        return 180;
      case InputImageRotation.rotation270deg:
        return 270;
    }
  }
}

/// Class untuk menunda proses sepersekian detik
/// umumnya dipakai stream agar tidak menjalankan proses membabi buta
class Throttler {
  /// inisiasi dengan berapa milisecond proses berulang akan ditunda
  Throttler({required this.milliSeconds});

  final int milliSeconds;

  int? lastActionTime;

  /// cukup bungkus callback/method dalam method run ini
  /// proses akan di-throttler sesuai waktu yg ditentukan
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
