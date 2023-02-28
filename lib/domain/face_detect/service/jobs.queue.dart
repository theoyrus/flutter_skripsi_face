import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:queue/queue.dart';

import 'mlkit.service.dart';

final queue = Queue(delay: const Duration(milliseconds: 500));

Future<dynamic> cropFaceJob(CameraImage image, List<Face> faceDetected) async {
  final MLKitService mlKitService = MLKitService();
  return await queue.add(() => mlKitService.cropWajah(image, faceDetected));
}
