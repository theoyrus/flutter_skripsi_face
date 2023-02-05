import 'package:get/route_manager.dart';

void previousScreen(int durationInSeconds) async {
  return Future.delayed(Duration(seconds: durationInSeconds), () {
    Get.back(closeOverlays: true);
  });
}
