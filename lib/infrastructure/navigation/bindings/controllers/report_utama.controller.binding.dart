import 'package:get/get.dart';

import '../../../../presentation/report/utama/controllers/report_utama.controller.dart';

class ReportUtamaControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportUtamaController>(
      () => ReportUtamaController(),
    );
  }
}
