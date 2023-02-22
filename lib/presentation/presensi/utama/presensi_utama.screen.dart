import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../domain/presensi/presensi.provider.dart';
import '../../../domain/time/time.provider.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../utils/date_time.utils.dart';
import '../../../utils/pullrefresh.utils.dart';
import 'controllers/presensi_utama.controller.dart';
import 'presensi_utama.filter.dart';
import 'presensi_utama_listview.widget.dart';

class PresensiUtamaScreen extends GetView<PresensiUtamaController> {
  const PresensiUtamaScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: controller.refreshCtrl,
        onRefresh: () => controller.refreshScreen(),
        header: smartRefreshHeaderConfig,
        child: ListView(
          children: [
            Center(
              child: GetBuilder<TimeProvider>(
                init: TimeProvider(),
                builder: (_) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_.hari.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20)),
                        Visibility(
                            visible:
                                _.waktu.value == 'Gagal mengambil waktu server',
                            child: InkWell(
                                onTap: () => _.getJam(),
                                child: const Icon(Icons.refresh)))
                      ]);
                },
              ),
            ),
            Row(
              children: const [],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Clock-In'),
                          const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
                            child: Text(''),
                          ),
                          Container(
                            width: 80,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 70, 210, 57),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MdiIcons.clockIn, size: 24),
                                GetBuilder<PresensiProvider>(
                                  init: PresensiProvider(),
                                  builder: (_) {
                                    var hariini = _.kehadiranHariIni.value;
                                    return Text(hariini.waktuHadir != null
                                        ? idTime(hariini.waktuHadir!,
                                            format: 'HH:mm')
                                        : '');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).asGlass(
                    clipBorderRadius: BorderRadius.circular(8),
                    blurX: 10,
                    blurY: 10,
                    frosted: true,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Clock-Out'),
                          const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
                            child: Text(''),
                          ),
                          Container(
                            width: 80,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0x9AF06A6A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MdiIcons.clockOut, size: 24),
                                GetBuilder<PresensiProvider>(
                                  builder: (_) {
                                    var hariini = _.kehadiranHariIni.value;
                                    return Text(hariini.waktuPulang != null
                                        ? idTime(hariini.waktuPulang!,
                                            format: 'HH:mm')
                                        : '');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).asGlass(
                    clipBorderRadius: BorderRadius.circular(8),
                    blurX: 10,
                    blurY: 10,
                    frosted: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text('Rekam Presensi'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(77, 70, 210, 57),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(
                          () => InkWell(
                            onTap: controller.isBisaClockIn.isTrue
                                ? () => Get.toNamed(Routes.PRESENSI_REKAM,
                                    parameters: {'jenis': 'IN'})
                                : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MdiIcons.clockIn, size: 40),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Text(controller.isBisaClockIn.isTrue
                                      ? 'Clock-In'
                                      : 'Sudah Clock-In'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(154, 240, 106, 106),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => InkWell(
                              onTap: controller.isBisaClockOut.isTrue
                                  ? () => Get.toNamed(Routes.PRESENSI_REKAM,
                                      parameters: {'jenis': 'OUT'})
                                  : null,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(MdiIcons.clockOut, size: 40),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
                                    child: Text(controller.isBisaClockOut.isTrue
                                        ? 'Clock-Out'
                                        : 'Sudah Clock-Out'),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                StickyHeader(
                  header: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      height: 50.0,
                      color: const Color.fromARGB(123, 158, 158, 158),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Expanded(child: Text('Riwayat')),
                          Obx(
                            () => Visibility(
                              visible: controller.filterEnabled.isTrue,
                              child: InkWell(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const PresensiUtamaFilter()),
                                  child: const Icon(Icons.filter_alt)),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                  content: Column(
                    children: [
                      const Text(
                        'BULAN INI',
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                        child: ListViewKehadiran(
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
