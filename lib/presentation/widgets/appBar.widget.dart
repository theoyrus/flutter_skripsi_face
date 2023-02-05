import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../infrastructure/theme/theme.controller.dart';
import '../setting/general/setting_general.screen.dart';

class AppxBar extends StatelessWidget implements PreferredSizeWidget {
  const AppxBar({
    Key? key,
    required this.themeC,
  }) : super(key: key);

  final ThemeController themeC;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      child: AppBar(
        title: const Text('Presensi Wajah'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const SettingGeneralScreen());
            },
            icon: const Icon(Icons.settings),
          ),
          Obx(
            () => Switch(
              value: themeC.isDark.value,
              onChanged: (val) {
                debugPrint('isDark: $val');
                if (val) {
                  Get.changeThemeMode(ThemeMode.dark);
                } else {
                  Get.changeThemeMode(ThemeMode.light);
                }
                themeC.switchTheme(val);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                  themeC.isDark.value ? ThemeMode.light : ThemeMode.dark);
              themeC.switchTheme(themeC.isDark.value);
            },
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.light_mode_outlined,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
