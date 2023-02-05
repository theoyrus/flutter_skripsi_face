// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'camera.service.dart';
// import 'face_detect.service.dart';
// import 'mlkit.service.dart';

// class FaceDetectController extends GetxController {
//   CameraService cameraService = CameraService();
//   final MLKitService _mlKitService = MLKitService();
//   final FaceDetectService _faceDetectService = FaceDetectService();

//   RxBool isInitialized = false.obs;
//   Size? imageSize;
//   Face? faceDetected;

//   bool detectingFace = false;
//   int eyeCloseCount = 0;
//   RxBool isSuccess = false.obs;
//   String imagePath = '';

//   RxBool isCameraPermissionGranted = false.obs;

//   @override
//   void onInit() {
//     _start();
//     super.onInit();
//   }

//   @override
//   // Future<void>
//   void dispose() async {
//     await cameraService.cameraController.stopImageStream();
//     await cameraService.dispose();
//     print('camera disposed');
//     super.dispose();
//   }

//   _start() async {
//     // getPermissionStatus();
//     List<CameraDescription> cameras = await availableCameras();
//     print(cameras);

//     // ambil kamera depan
//     var cameraDescription = cameras.firstWhere(
//       (CameraDescription camera) =>
//           camera.lensDirection == CameraLensDirection.front,
//     );
//     print(cameraDescription);

//     await cameraService.startService(cameraDescription);

//     // jalankan service face detect
//     // await _faceDetectService.

//     _mlKitService.initialize();

//     isInitialized(true);
//     _frameWajah();
//   }

//   _frameWajah() {
//     imageSize = cameraService.getImageSize();

//     cameraService.cameraController.startImageStream((image) async {
//       try {
//         /* print('apakah detectingFace? =============> ${detectingFace}'); */
//         if (detectingFace) return true;

//         detectingFace = true;

//         var faceFromImage = await _mlKitService.getFacesFromImage(image);
//         List<Face> faces = faceFromImage.item1;
//         CustomPaint customPaint = faceFromImage.item2;

//         print('face??? ==============> $faces');
//         print('custompaint??? ==============> $customPaint');

//         if (faces.isNotEmpty) {
//           faceDetected = faces[0];
//           print('EagularY ${faceDetected!.headEulerAngleY!}');

//           if (faceDetected!.headEulerAngleY! > 10 ||
//               faceDetected!.headEulerAngleY! < -10) {
//             // tidak ada
//             print('tidak ada');
//           } else {
//             print('start working ............. ${DateTime.now()}');
//             print(
//                 'face detect ${faces[0].leftEyeOpenProbability} / ${faces[0].rightEyeOpenProbability} ');

//             if (((faces[0].leftEyeOpenProbability ?? 1) < 0.3) &&
//                 ((faces[0].rightEyeOpenProbability ?? 1) < 0.3)) {
//               eyeCloseCount++;
//               print('mata tertutup $eyeCloseCount');
//             } else {
//               if (eyeCloseCount != 0 && eyeCloseCount <= 3) {
//                 //ok
//                 print('mata terbuka kembali, $eyeCloseCount kedipan');

//                 await Future.delayed(const Duration(milliseconds: 300));
//                 await cameraService.cameraController.stopImageStream();
//                 await cameraService.cameraController.pausePreview();
//                 await Future.delayed(const Duration(milliseconds: 500));

//                 // setelah mata terbuka lagi
//                 // _faceDetectService.setCurrentPrediction(image, faceDetected!);
//                 XFile file = await cameraService.takePicture();
//                 imagePath = file.path;
//                 isSuccess(true);
//               } else {
//                 //fast occur
//                 print('mata terbuka $eyeCloseCount x');
//               }
//               eyeCloseCount = 0;
//               print('done working at................. ${DateTime.now()}');
//             }
//           }
//         } else {
//           faceDetected = null;
//           print(
//               'wajah tidak terdeteksi, faceDetected==null? ${faceDetected == null}');
//         }
//       } catch (e) {
//         print('==================> Exception: $e <======================');
//         faceDetected = null;
//         detectingFace = false;
//       }
//     });
//   }

//   retry() async {
//     isSuccess(false);
//     detectingFace = false;
//     eyeCloseCount = 0;
//     faceDetected = null;
//     imagePath = '';
//     await cameraService.cameraController.resumePreview();
//     _frameWajah();
//   }

//   save() async {
//     //Navigate to back with face data and image path
//     dispose();
//     Get.back(result: {
//       'imagePath': imagePath,
//       'data': _faceDetectService.predictedData.toString(),
//     });
//   }

//   getPermissionStatus() async {
//     await Permission.camera.request();
//     var status = await Permission.camera.status;
//     if (status.isGranted) {
//       print('Camera Permission: GRANTED');

//       isCameraPermissionGranted.value = true;
//     } else {
//       print('Camera Permission: DENIED');
//     }
//   }
// }

// class FaceDetect extends GetView<FaceDetectController> {
//   @override
//   final controller = Get.put(FaceDetectController());

//   FaceDetect({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         controller.dispose();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Obx(
//           () => Stack(
//             children: [
//               // controller.isCameraPermissionGranted.isFalse
//               //     ? Column(
//               //         mainAxisAlignment: MainAxisAlignment.center,
//               //         children: [
//               //           Row(),
//               //           const Text(
//               //             'Permission denied',
//               //             style: TextStyle(color: Colors.white),
//               //           ),
//               //           const SizedBox(height: 16),
//               //           ElevatedButton(
//               //             onPressed: () {
//               //               controller.getPermissionStatus();
//               //             },
//               //             child: const Text('Give permission'),
//               //           ),
//               //         ],
//               //       )
//               //     : const Center(
//               //         child: Text('Granted :)'),
//               //       ),
//               controller.isInitialized.value
//                   ? AspectRatio(
//                       aspectRatio: Get.size.aspectRatio,
//                       child: FittedBox(
//                         fit: BoxFit.fitHeight,
//                         child: SizedBox(
//                           width: Get.width,
//                           height: Get.width *
//                               controller.cameraService.cameraController.value
//                                   .aspectRatio,
//                           child: CameraPreview(
//                             controller.cameraService.cameraController,
//                           ),
//                         ),
//                       ),
//                     )
//                   : const Center(child: CircularProgressIndicator()),
//               controller.isSuccess.value
//                   ? Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Lottie.asset(
//                           //   'assets/lottie/face_success.json',
//                           // ),
//                           const Text(
//                             'Face ID Created',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 letterSpacing: 1.5),
//                           ),
//                           const SizedBox(
//                             height: 32,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: () => controller.retry(),
//                                 child: Container(
//                                   width: 100,
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 12),
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(50.0)),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.shade500,
//                                         blurRadius: 25,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     children: const [
//                                       Icon(
//                                         Icons.refresh,
//                                         color: Colors.red,
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                         'Retry',
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () => controller.save(),
//                                 child: Container(
//                                   width: 100,
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 12),
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(50)),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.shade500,
//                                         blurRadius: 25,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     children: const [
//                                       Icon(
//                                         Icons.save,
//                                         color: Colors.green,
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                         'Save',
//                                         style: TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//               Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                       Colors.black,
//                       Colors.transparent,
//                       Colors.transparent,
//                       Colors.black54,
//                     ])),
//                 padding: const EdgeInsets.only(
//                     left: 20, top: 40, bottom: 16, right: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         controller.dispose();
//                         Get.back();
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text(
//                       'Face Recognition',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text(
//                       'Please look into the camera and blink your eyes',
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
