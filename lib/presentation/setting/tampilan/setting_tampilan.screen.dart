import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../infrastructure/theme/theme.controller.dart';
import '../../widgets/menu.widget.dart';
import 'controllers/setting_tampilan.controller.dart';

class SettingTampilanScreen extends GetView<SettingTampilanController> {
  const SettingTampilanScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final themeC = Get.find<ThemeController>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pengaturan Aplikasi'),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const MenuTitleWidget(title: 'Tampilan'),
            GetBuilder<ThemeController>(
              init: ThemeController(),
              builder: (_) {
                return MenuTilesWidget(
                  title: 'Ubah Mode ${_.isDark.value ? 'Terang' : 'Gelap'}',
                  description: 'Atur Dark/Light Mode',
                  icon: MdiIcons.themeLightDark,
                  onTap: () {
                    _.isDark.value
                        ? Get.changeThemeMode(ThemeMode.light)
                        : Get.changeThemeMode(ThemeMode.dark);
                    _.switchTheme(_.isDark.value ? false : true);
                  },
                );
              },
            ),
            // Obx(
            //   () => Switch(
            //     value: themeC.isDark.value,
            //     onChanged: (val) {
            //       debugPrint('isDark: $val');
            //       if (val) {
            //         Get.changeThemeMode(ThemeMode.dark);
            //       } else {
            //         Get.changeThemeMode(ThemeMode.light);
            //       }
            //       themeC.switchTheme(val);
            //     },
            //   ),
            // ),
          ],
        ));
  }
}
