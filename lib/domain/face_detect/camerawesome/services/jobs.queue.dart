import 'package:queue/queue.dart';

import 'mlkit.service.dart';

final queue = Queue(delay: const Duration(milliseconds: 500));

/// Queue for Heavy Job crop face with google mlkit from file
Future<String> cropFaceFileJob(String fromPath) async {
  return await queue.add(() => cropFaceFromFile(fromPath));
}
