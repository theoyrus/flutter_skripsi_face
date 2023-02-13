import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../domain/citrawajah/citrawajah.service.dart';
import '../../../../utils/snackbar.utils.dart';
import '../../../widgets/gridView.widget.dart';

class CitrawajahMyController extends GetxController {
  final CitraWajahService _citraWajahService = CitraWajahService();
  RefreshController refreshCtrl = RefreshController(initialRefresh: false);

  final pageNum = 1.obs;
  var citraItems = <ImageItem>[].obs;

  @override
  void onInit() {
    listCitra();
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

  void detailImage(int index) {
    debugPrint('meng klik $index');
    update();
  }

  Future<void> listCitra({int pageNum = 1}) async {
    _citraWajahService.list(page: pageNum, limit: 20).then((citraList) {
      var items = citraList.map((citra) {
        String citranama = citra.nama?.split('/').last ?? 'No Name';

        return ImageItem(citra.nama!, citranama, citra.toJson());
      });
      if (pageNum == 1) {
        citraItems.assignAll(items);
      } else {
        citraItems.addAll(items);
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

  Future<void> refreshScreen() async {
    pageNum.value = 1;
    await listCitra().then((_) {
      refreshCtrl.refreshCompleted();
      refreshCtrl.loadComplete();
    });
  }

  Future<void> loadMore() async {
    await listCitra(pageNum: pageNum.value++).then((_) {
      refreshCtrl.loadComplete();
    });
  }

  Future hapus(int index) async {
    debugPrint('meng double klik $index');
    return await Get.defaultDialog(
      title: 'Hapus Citra',
      content: const Text('Anda yakin menghapus citra ini?'),
      confirm: ElevatedButton(
          onPressed: () async {
            int id = citraItems[index].data?['citrawajah_id'];
            await _citraWajahService.hapus(id).then((_) {
              citraItems.removeAt(index);
            }).catchError((_) {
              AppSnackBar.showErrorSnackBar(
                  title: 'Opps', message: _.toString());
            });
            Get.close(1);
          },
          child: const Text('Ya')),
      cancel: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text('Batal')),
    );
  }
}
