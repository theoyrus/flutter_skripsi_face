import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../domain/presensi/models/presensi.model.dart';
import '../../../../domain/presensi/presensi.provider.dart';
import '../../../../domain/presensi/presensi.service.dart';
import '../../../../utils/snackbar.utils.dart';

class PresensiUtamaController extends GetxController {
  final PresensiService _presensiService = PresensiService();
  RefreshController refreshCtrl = RefreshController(initialRefresh: false);
  var isBisaClockIn = true.obs;
  var isBisaClockOut = true.obs;

  final filterEnabled = false.obs;
  final kehadiranItems = <Kehadiran>[].obs;

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
    });
    refreshCtrl.refreshCompleted();
  }

  Future<void> listKehadiran({int pageNum = 1}) async {
    _presensiService.kehadiranList(page: pageNum, limit: 31).then((hadirList) {
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
