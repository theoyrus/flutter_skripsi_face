import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/karyawan/karyawan.provider.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../auth/login/controllers/auth_login.controller.dart';
import '../../widgets/menu.widget.dart';
import '../../widgets/profile_card.widget.dart';
import 'controllers/setting_general.controller.dart';

class SettingGeneralScreen extends GetView<SettingGeneralController> {
  const SettingGeneralScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            // width: MediaQuery.of(context).size.width,
            height: 110,
            // color: Colors.black,
            alignment: Alignment.topCenter,
            child: GetBuilder<KaryawanProvider>(
              init: KaryawanProvider(),
              initState: (_) {},
              builder: (_) {
                return ProfileCardWidget(
                  username: _.karyawanMe.value.nama ?? '',
                  noinduk: _.karyawanMe.value.noinduk ?? '',
                  divisi: _.karyawanMe.value.divisi?.nama ?? '',
                );
              },
            ),
          ),
          // const NotifWidget(text: 'Mohon lengkapi data Anda.'),
          const MenuTitleWidget(title: 'Akun'),
          MenuTilesWidget(
            title: 'Data Karyawan',
            description: 'Profil Individu',
            icon: Icons.account_circle,
            onTap: () => Get.toNamed(Routes.SETTING_PROFILE),
          ),
          MenuTilesWidget(
            title: 'Data Wajah',
            description: 'Perekaman Data Wajah',
            icon: MdiIcons.faceRecognition,
            onTap: () => Get.toNamed(Routes.CITRAWAJAH_MY),
          ),
          MenuTilesWidget(
            title: 'Logout',
            description: 'Keluar sistem',
            icon: Icons.logout,
            onTap: () {
              Get.find<AuthLoginController>().authLogout();
            },
          ),
          const MenuTitleWidget(title: 'Aplikasi'),
          MenuTilesWidget(
            title: 'Pengaturan',
            description: 'Kustomisasi aplikasi',
            icon: Icons.settings_display_outlined,
            onTap: () => Get.toNamed(Routes.SETTING_TAMPILAN),
          ),
        ],
      ),
    );
  }
}
