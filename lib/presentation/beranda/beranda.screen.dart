import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../domain/karyawan/karyawan.provider.dart';
import '../widgets/longText.widget.dart';
import 'controllers/beranda.controller.dart';

class BerandaScreen extends GetView<BerandaController> {
  const BerandaScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const BerandaMobile();
  }
}

class BerandaMobile extends StatelessWidget {
  const BerandaMobile({Key? key}) : super(key: key);

  Future<void> _refreshScreen(c) async {
    Get.find<KaryawanProvider>().meState();
    c.getJam();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BerandaController>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshScreen(controller);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/face-icon.png'),
                      fit: BoxFit.contain,
                    ),
                    GetBuilder<KaryawanProvider>(
                      init: KaryawanProvider(),
                      builder: (_) {
                        return GestureDetector(
                          onDoubleTap: () => _.meState(),
                          child: Column(
                            children: [
                              LongText(
                                  text:
                                      'Hai, ${_.karyawanMe.value.nama ?? 'Karyawan'} ',
                                  textOverflow: TextOverflow.ellipsis,
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              LongText(
                                text:
                                    '${_.karyawanMe.value.noinduk ?? ''} - ${_.karyawanMe.value.divisi?.nama ?? ''}',
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Center(
                  child: Obx(() => Text(
                        controller.hari.value,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Obx(() => Text(
                            controller.waktu.value,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Center(
                      child: Obx(
                        () => Visibility(
                          visible: controller.waktu.value ==
                              'Gagal mengambil waktu server',
                          child: GestureDetector(
                            onTap: () => controller.getJam(),
                            child: const Icon(Icons.refresh),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                  width: context.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Icon(MdiIcons.clockTimeEightOutline, size: 40),
                        Text('Hadir Presensi'),
                        Text('07:49'),
                      ],
                    ),
                    Column(
                      children: const [
                        Icon(MdiIcons.clockTimeFourOutline, size: 40),
                        Text('Belum Presensi'),
                        Text(''),
                      ],
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    'Bulan Ini',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Icon(
                          MdiIcons.checkBold,
                          size: 40,
                          color: Colors.green,
                        ),
                        Text('12'),
                        Text('Kehadiran'),
                      ],
                    ),
                    Column(
                      children: const [
                        Icon(
                          MdiIcons.alert,
                          size: 40,
                          color: Colors.orange,
                        ),
                        Text('12'),
                        Text('Terlambat'),
                      ],
                    ),
                    Column(
                      children: const [
                        Icon(
                          Icons.dangerous_rounded,
                          size: 40,
                          color: Colors.red,
                        ),
                        Text('8'),
                        Text('Tidak Hadir'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
