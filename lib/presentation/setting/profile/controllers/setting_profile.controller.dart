import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../../domain/auth/user.model.dart';
import '../../../../domain/auth/user.service.dart';
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
  final UserMeService userMeService = UserMeService();

  final isChangePass = false.obs;
  final hiddenPass = true.obs;
  final hiddenNewPass = true.obs;

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
    debugPrint('saved ... $fVal');
    try {
      SmartDialog.showLoading(msg: 'Memproses perubahan ...');
      await userMeService.updateMe(UserMePut.fromJson(fVal!));
      await karyawanService.updateMe(KaryawanRequest.fromJson(fVal));
      Get.find<KaryawanProvider>().meState();
      if (fVal['is_change_pass'] &&
          fVal['current_password'].toString().isNotEmpty) {
        var kMe = karyawanMe;
        var currentEmail = kMe.user?.email;
        if (currentEmail != fVal['new_email']) {
          // jika berubah
          await userMeService.changeMeMail(UserMeChangeEmail.fromJson(fVal));
        }
        if (fVal['new_password'].toString().isNotEmpty) {
          await userMeService.changeMePass(UserMeChangePass.fromJson(fVal));
        }
      }
      AppSnackBar.showSnackBar(
          title: 'Berhasil', message: 'profil berhasil diperbaharui');
      previousScreen(3);
    } catch (e) {
      var pesan = e.toString();
      AppSnackBar.showErrorSnackBar(
          title: 'Perbaharui profil gagal', message: pesan);
    }
    SmartDialog.dismiss();
  }
}
