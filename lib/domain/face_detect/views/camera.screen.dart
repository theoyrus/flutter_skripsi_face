import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../presentation/widgets/gridView.widget.dart';
import '../painter/face_detect.painter.dart';
import '../service/camera.service.dart';
import '../service/mlkit.service.dart';
import 'camera.view.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, this.onFaceDetected}) : super(key: key);

  /// Event ketika wajah ditemukan
  final void Function({
    List<Face>? faces,
    CameraImage? cameraImage,
    String? statusProses,
  })? onFaceDetected;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableClassification: true,
      enableLandmarks: false,
    ),
  );
  int maxImage = 10;
  int countImage = 0;
  List<String> croppedImagesPath = [];
  List<ImageItem> croppedImageItems = [];
  String statusProses = 'ONPROCESS';

  final MLKitService _mlKitService = MLKitService();
  late Throttler throttler;
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    throttler = Throttler(milliSeconds: 500);

    _box.write('cameraProcess', 'ONPROCESS');
    statusProses = _box.read('cameraProcess') ?? 'ONPROCESS';
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  Future<void> processImage(
      InputImage inputImage, CameraImage? cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    // setState(() {
    //   _text = '';
    // });

    // dynamic finalResult = Multimap<String, Face>();
    // start throttler
    throttler.run(() async {
      final faces = await _faceDetector.processImage(inputImage);
      debugPrint('====> wajah ${faces.length}');
      // debugPrint('====> imageData S: ${inputImage.inputImageData?.size} | R: ${inputImage.inputImageData?.imageRotation}');
      if (inputImage.inputImageData?.size != null &&
          inputImage.inputImageData?.imageRotation != null) {
        final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
        );
        _customPaint = CustomPaint(painter: painter);
        String text =
            faces.isNotEmpty ? 'Wajah terdeteksi' : 'Tidak Terdeteksi';
        _text = text;

        // eksekusi onFaceDetected
        widget.onFaceDetected?.call(
          faces: faces,
          cameraImage: cameraImage!,
          statusProses: statusProses,
        );
        statusProses = _box.read('cameraProcess') ?? 'ONPROCESS';
        debugPrint('status proses => from storage => $statusProses');
      } else {
        String text = 'Faces found: ${faces.length}\n\n';
        for (final face in faces) {
          text += 'face: ${face.boundingBox}\n\n';
        }
        _text = text;
        _customPaint = null;
      }
    }); // end throttler
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  final BorderRadius radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          title: 'Face Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage, cameraImage) {
            processImage(inputImage, cameraImage);
          },
          statusProses: statusProses,
          initialDirection: CameraLensDirection.front,
        ),
      ],
    );
  }
}
