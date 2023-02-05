import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../domain/divisi/divisi.provider.dart';
import '../../../../domain/karyawan/karyawan.provider.dart';
import '../../../../domain/karyawan/karyawan.service.dart';
import '../../../../domain/karyawan/models/karyawan_me.model.dart';
import '../../../../utils/nav.utils.dart';
import '../../../../utils/snackbar.utils.dart';

class SettingProfileController extends GetxController {
  final fbKey = GlobalKey<FormBuilderState>();
  late KaryawanMe karyawanMe;
  final KaryawanService karyawanService = KaryawanService();

  @override
  void onInit() {
    Get.find<DivisiProvider>().listState();
    karyawanMe = Get.find<KaryawanProvider>().karyawanMe.value;
    debugPrint('onInit');
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('onReady');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void save() async {
    var form = fbKey.currentState;
    form?.save();
    var fVal = form?.value;
    try {
      await karyawanService.updateMe(KaryawanRequest.fromJson(fVal!));
      Get.find<KaryawanProvider>().meState();
      AppSnackBar.showSnackBar(
          title: 'Berhasil', message: 'profil berhasil diperbaharui');
      previousScreen(3);
    } catch (e) {
      AppSnackBar.showErrorSnackBar(
          title: 'Perbaharui profil gagal', message: e.toString());
    }
    debugPrint('saved ... $fVal');
  }
}
