import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.statusProses,
    this.onScreenModeChanged,
    this.initialDirection = CameraLensDirection.back,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage, CameraImage? cameraImage) onImage;
  final String? statusProses;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  // ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;

  bool _changingCameraLens = false;

  late List<CameraDescription> cameras;

  Future<void> initializeCamera() async {
    cameras = await availableCameras();

    // _imagePicker = ImagePicker();
    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('===============> camera service ');
    initializeCamera();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    Widget body;
    body = _liveFeedBody();
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return const Center(
        child: Text('Memuat...'),
      );
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio *
        (_controller != null ? _controller!.value.aspectRatio : 1);

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // camera preview
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          // face painter
          if (_controller != null && widget.customPaint != null)
            widget.customPaint!,
          // zoom level
          if (_controller != null)
            Text(
              widget.text ?? '',
              style: const TextStyle(color: Colors.amber, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          if (_controller == null && widget.statusProses == 'ONDONE')
            const Text(
              'Deteksi Wajah Selesai',
              style: TextStyle(color: Colors.green, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          // Positioned(
          //   bottom: 100,
          //   left: 50,
          //   right: 50,
          //   child: Slider(
          //     value: zoomLevel,
          //     min: minZoomLevel,
          //     max: maxZoomLevel,
          //     onChanged: (newSliderValue) {
          //       setState(() {
          //         zoomLevel = newSliderValue;
          //         _controller!.setZoomLevel(zoomLevel);
          //       });
          //     },
          //     divisions: (maxZoomLevel - 1).toInt() < 1
          //         ? null
          //         : (maxZoomLevel - 1).toInt(),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
    setState(() => _controller = null);
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  Future _processCameraImage(CameraImage image) async {
    // debugPrint('====> planes length ${image.planes.length}');
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

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
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    // debugPrint('====> Image Rotation: ${inputImageData.imageRotation}');
    // debugPrint('====> Panjang Byte ${bytes.length}');

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage, image);
    if (widget.statusProses == 'ONDONE') {
      _stopLiveFeed();
    }
  }
}
