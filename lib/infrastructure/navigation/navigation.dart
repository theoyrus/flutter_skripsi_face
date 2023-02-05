import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.production
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.qas ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const AuthLoginScreen(),
      binding: AuthLoginControllerBinding(),
    ),
    GetPage(
      name: Routes.AUTH_REGISTER,
      page: () => const AuthRegisterScreen(),
      binding: AuthRegisterControllerBinding(),
    ),
    GetPage(
      name: Routes.SETTING_PROFILE,
      page: () => const SettingProfileScreen(),
      binding: SettingProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.SETTING_GENERAL,
      page: () => const SettingGeneralScreen(),
      binding: SettingGeneralControllerBinding(),
    ),
    GetPage(
      name: Routes.PRESENSI_UTAMA,
      page: () => const PresensiUtamaScreen(),
      binding: PresensiUtamaControllerBinding(),
    ),
    GetPage(
      name: Routes.REPORT_UTAMA,
      page: () => const ReportUtamaScreen(),
      binding: ReportUtamaControllerBinding(),
    ),
    GetPage(
      name: Routes.BERANDA,
      page: () => const BerandaScreen(),
      binding: BerandaControllerBinding(),
    ),
    GetPage(
      name: Routes.SETTING_TAMPILAN,
      page: () => const SettingTampilanScreen(),
      binding: SettingTampilanControllerBinding(),
    ),
    GetPage(
      name: Routes.CITRAWAJAH_MY,
      page: () => const CitrawajahMyScreen(),
      binding: CitrawajahMyControllerBinding(),
    ),
    GetPage(
      name: Routes.CITRAWAJAH_TAMBAH,
      page: () => const CitrawajahTambahScreen(),
      binding: CitrawajahTambahControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASHSCREEN,
      page: () => const SplashscreenScreen(),
      binding: SplashscreenControllerBinding(),
    ),
  ];
}
