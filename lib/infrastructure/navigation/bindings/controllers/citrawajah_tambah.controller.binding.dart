import 'package:get/get.dart';

import '../../../../presentation/citrawajah/tambah/controllers/citrawajah_tambah.controller.dart';

class CitrawajahTambahControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitrawajahTambahController>(
      () => CitrawajahTambahController(),
    );
  }
}
