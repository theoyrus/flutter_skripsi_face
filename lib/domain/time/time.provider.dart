import 'dart:async';

import 'package:get/get.dart';

import '../../utils/date_time.utils.dart';
import '../../utils/numbers.utils.dart';

class TimeProvider extends GetxController {
  Timer? _timer;
  final waktu = '00:00:00'.obs;
  final hari = ''.obs;

  @override
  void onInit() {
    getJam();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void getJam() async {
    waktu.value = 'Memuat...';
    try {
      var serverTime = await getWaktuString();
      // debugPrint('server time : $serverTime');
      // debugPrint(idTime(parseTime(serverTime)));
      DateTime now = parseTime(serverTime);
      hari.value = idHariBulanTahun(now);
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        now = now.add(const Duration(seconds: 1));
        var jam = twoDigits(now.hour);
        var menit = twoDigits(now.minute);
        var detik = twoDigits(now.second);
        waktu.value = '$jam:$menit:$detik';
        update();
      });
    } catch (e) {
      waktu.value = 'Gagal mengambil waktu server';
      DateTime now = DateTime.now();
      hari.value = idHariBulanTahun(now);
      update();
    }
  }
}
