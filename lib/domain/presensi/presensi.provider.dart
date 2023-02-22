import 'package:get/get.dart';
import 'models/kehadiranbulanini.model.dart';

import '../../utils/snackbar.utils.dart';
import 'presensi.service.dart';
import 'models/presensi.model.dart';

class PresensiProvider extends GetxController {
  final PresensiService _presensiService = PresensiService();
  final kehadiranHariIni = Kehadiran().obs;
  final kehadiranBulanIni = KehadiranBulanIni().obs;

  @override
  void onInit() {
    presensiTodayState();
    presensiBulanIniState();
    super.onInit();
  }

  Future<Rx<Kehadiran>> presensiTodayState() async {
    try {
      var today = await _presensiService.kehadiranHariIni();
      kehadiranHariIni.update((val) {
        kehadiranHariIni.value = today;
      });
      kehadiranHariIni.refresh();
      update();
      return kehadiranHariIni;
    } catch (e) {
      String pesan = e.toString();
      if (!pesan.contains('Belum ada rekaman presensi')) {
        AppSnackBar.showErrorSnackBar(title: 'Oops', message: e.toString());
      }
      rethrow;
    }
  }

  Future<Rx<KehadiranBulanIni>> presensiBulanIniState() async {
    try {
      var bulanini = await _presensiService.kehadiranBulanIni();
      kehadiranBulanIni.update((val) {
        kehadiranBulanIni.value = bulanini;
      });
      kehadiranBulanIni.refresh();
      update();
      return kehadiranBulanIni;
    } catch (e) {
      AppSnackBar.showErrorSnackBar(title: 'Oops', message: e.toString());
      rethrow;
    }
  }
}
