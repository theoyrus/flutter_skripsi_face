import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/date_time.utils.dart';
import '../../../utils/numbers.utils.dart';

class BerandaController extends GetxController {
  Timer? _timer;
  final waktu = '00:00:00'.obs;
  final hari = ''.obs;

  @override
  void onInit() {
    debugPrint('beranda init');
    super.onInit();
  }

  @override
  void onReady() {
    _timer?.cancel();
    debugPrint('beranda ready');
    super.onReady();
    getJam();
  }

  @override
  void onClose() {
    debugPrint('beranda onClosed');
    _timer?.cancel();
    super.onClose();
  }

  getJam() async {
    waktu.value = 'Memuat...';
    try {
      var serverTime = await getWaktuString();
      debugPrint('server time : $serverTime');
      // debugPrint(idTime(parseTime(serverTime)));
      DateTime now = parseTime(serverTime);
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        now = now.add(const Duration(seconds: 1));
        var jam = twoDigits(now.hour);
        var menit = twoDigits(now.minute);
        var detik = twoDigits(now.second);
        waktu.value = '$jam:$menit:$detik';
        hari.value = idHariBulanTahun(now);
        // debugPrint(waktu.value);
      });
    } catch (e) {
      waktu.value = 'Gagal mengambil waktu server';
      DateTime now = DateTime.now();
      hari.value = idHariBulanTahun(now);
    }
  }
}
