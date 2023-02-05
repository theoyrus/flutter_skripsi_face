import 'package:get/get.dart';

import '../../../../domain/karyawan/karyawan.provider.dart';
import '../../../../presentation/auth/login/controllers/auth_login.controller.dart';
import '../../../../presentation/beranda/controllers/beranda.controller.dart';
import '../../../../presentation/home/controllers/home.controller.dart';
import '../../../../presentation/presensi/utama/controllers/presensi_utama.controller.dart';
import '../../../../presentation/report/utama/controllers/report_utama.controller.dart';
import '../../../../presentation/setting/general/controllers/setting_general.controller.dart';
import '../../../theme/theme.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut(() => AuthLoginController(), fenix: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => BerandaController(), fenix: true);
    Get.lazyPut(() => PresensiUtamaController());
    Get.lazyPut(() => ReportUtamaController());
    Get.lazyPut(() => SettingGeneralController());
    Get.lazyPut(() => KaryawanProvider(), fenix: true);
  }
}
