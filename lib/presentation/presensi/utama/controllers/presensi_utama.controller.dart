import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../domain/presensi/models/presensi.model.dart';
import '../../../../domain/presensi/presensi.provider.dart';
import '../../../../domain/presensi/presensi.service.dart';
import '../../../../utils/date_time.utils.dart';
import '../../../../utils/snackbar.utils.dart';

class PresensiUtamaController extends GetxController {
  final PresensiService _presensiService = PresensiService();
  RefreshController refreshCtrl = RefreshController(initialRefresh: false);
  var isBisaClockIn = true.obs;
  var isBisaClockOut = true.obs;

  final filterEnabled = true.obs;
  final isHariIniLihat = false;
  final kehadiranItems = <Kehadiran>[].obs;
  final filterResultText = 'BULAN INI'.obs;

  @override
  void onInit() {
    refreshScreen();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshScreen() async {
    PresensiProvider hariiniPvdr = Get.find<PresensiProvider>();
    listKehadiran();
    await hariiniPvdr.presensiTodayState().then((state) {
      isBisaClockIn.value = state.value.waktuHadir == null;
      isBisaClockOut.value = state.value.waktuPulang == null;
    }).catchError((_) {
      refreshCtrl.refreshCompleted();
      isBisaClockIn.value = true;
      isBisaClockOut.value = true;
    });
    refreshCtrl.refreshCompleted();
  }

  Future<void> listKehadiran({int pageNum = 1, tahun, bulan}) async {
    bulan ??= DateTime.now().month;
    tahun ??= DateTime.now().year;
    _presensiService
        .kehadiranList(page: pageNum, limit: 31, tahun: tahun, bulan: bulan)
        .then((hadirList) {
      if (tahun != null || bulan != null) {
        filterResultText.value =
            '${getMonthNameByIdx(bulan, langCode: 'id')} ${tahun.toString()}';
      }
      // var items = hadirList.map((item) {
      //   return Kehadiran(item);
      // });
      var items = hadirList;
      if (pageNum == 1) {
        kehadiranItems.assignAll(items);
      } else {
        kehadiranItems.addAll(items);
      }
    }).catchError((_) {
      refreshCtrl.refreshFailed();
      if (_.toString().contains('Invalid page')) {
        refreshCtrl.loadNoData();
      } else {
        AppSnackBar.showErrorSnackBar(title: 'Opps', message: _.toString());
        throw _;
      }
    });
  }
}
