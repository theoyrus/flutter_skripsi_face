import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_navigation/side_navigation.dart';

import '../beranda/controllers/beranda.controller.dart';
import '../presensi/utama/controllers/presensi_utama.controller.dart';
import '../report/utama/controllers/report_utama.controller.dart';
import '../screens.dart';
import '../setting/general/controllers/setting_general.controller.dart';
import '../widgets/confirmCloseApp.widget.dart';
import '../widgets/layouts/responsive.layout.dart';
import '../widgets/sideBar.widget.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return ConfirmCloseAppWidget(
          child: ResponsiveLayout(
            mobileScaffold: HomeMobile(controller),
            tabletScaffold: HomeMobile(controller),
            desktopScaffold: HomeDesktop(controller),
          ),
        );
      },
    );
  }

  Scaffold HomeMobile(HomeController controller) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: controller.tabIndex,
          children: [
            // BerandaScreen(),
            GetBuilder<BerandaController>(
              init: BerandaController(),
              builder: (BerandaController controller) {
                return const BerandaScreen();
              },
            ),
            GetBuilder<PresensiUtamaController>(
              init: PresensiUtamaController(),
              builder: (PresensiUtamaController controller) {
                return const PresensiUtamaScreen();
              },
            ),
            GetBuilder<ReportUtamaController>(
              init: ReportUtamaController(),
              builder: (ReportUtamaController controller) {
                return const ReportUtamaScreen();
              },
            ),
            GetBuilder<SettingGeneralController>(
              init: SettingGeneralController(),
              builder: (SettingGeneralController controller) {
                return const SettingGeneralScreen();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 14,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        // iconSize: 20,
        currentIndex: controller.tabIndex,
        onTap: controller.changeTabIndex,
        items: <BottomNavigationBarItem>[
          bottNavItem(icon: Icons.home, label: 'Beranda'),
          bottNavItem(icon: Icons.watch_later_outlined, label: 'Presensi'),
          bottNavItem(icon: Icons.ssid_chart_outlined, label: 'Report'),
          bottNavItem(icon: Icons.person, label: 'Profil'),
        ],
      ),
    );
  }

  Scaffold HomeDesktop(HomeController controller) {
    final List<SideNavigationBarItem> items = [
      const SideNavigationBarItem(
        icon: Icons.home,
        label: 'Beranda',
      ),
      const SideNavigationBarItem(
        icon: Icons.watch_later_outlined,
        label: 'Presensi',
      ),
      const SideNavigationBarItem(
        icon: Icons.ssid_chart_outlined,
        label: 'Report',
      ),
      const SideNavigationBarItem(
        icon: Icons.person,
        label: 'Profil',
      ),
    ];
    final List<Widget> views = [
      // const BerandaScreen(),
      GetBuilder<BerandaController>(
        init: BerandaController(),
        builder: (BerandaController controller) {
          return const BerandaScreen();
        },
      ),
      GetBuilder<PresensiUtamaController>(
        init: PresensiUtamaController(),
        builder: (PresensiUtamaController controller) {
          return const PresensiUtamaScreen();
        },
      ),
      GetBuilder<ReportUtamaController>(
        init: ReportUtamaController(),
        builder: (ReportUtamaController controller) {
          return const ReportUtamaScreen();
        },
      ),
      GetBuilder<SettingGeneralController>(
        init: SettingGeneralController(),
        builder: (SettingGeneralController controller) {
          return const SettingGeneralScreen();
        },
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: SideBarWidget(
          views: views,
          items: items,
        ),
      ),
    );
  }
}

BottomNavigationBarItem bottNavItem({IconData? icon, String? label}) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}
