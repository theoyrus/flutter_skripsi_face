import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_navigation/side_navigation.dart';

class SideBarController extends GetxController {
  var selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }
}

class SideBarWidget extends StatelessWidget {
  final SideNavigationBarHeader? header;
  final Widget? footer;
  final List<SideNavigationBarItem> items;
  final List<Widget> views;

  SideBarWidget({
    Key? key,
    this.footer,
    this.header,
    required this.items,
    required this.views,
  }) : super(key: key);

  final sideBarC = Get.put(SideBarController(), permanent: true);

  final List<Widget> viewsDef = const [
    Center(
      child: Text('Beranda'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SideBarController>(
        init: SideBarController(),
        builder: (SideBarController sideBarC) {
          return Row(
            children: [
              /// Pretty similar to the BottomNavigationBar!
              SideNavigationBar(
                header: header,
                footer:
                    SideNavigationBarFooter(label: footer ?? const Text('')),
                selectedIndex: sideBarC.selectedIndex,
                items: items,
                onTap: sideBarC.changeIndex,
              ),

              /// Make it take the rest of the available width
              Expanded(
                child: views.elementAt(sideBarC.selectedIndex),
              )
            ],
          );
        });
  }
}
