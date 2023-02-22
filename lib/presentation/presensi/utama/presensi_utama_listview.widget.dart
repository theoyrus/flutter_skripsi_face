import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/date_time.utils.dart';
import 'controllers/presensi_utama.controller.dart';

class ListViewKehadiran extends StatelessWidget {
  final PresensiUtamaController controller;
  const ListViewKehadiran({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var kehadiran = controller.kehadiranItems.value;

      return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.kehadiranItems.length,
          itemBuilder: (context, index) {
            var item = kehadiran[index];
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
              child: InkWell(
                onTap: () async {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: const Color(0x6639D2C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Icon(MdiIcons.calendarClock, size: 24),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(idHariBulan(item.tanggal!)),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: Text(idDayName(item.tanggal!)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.waktuHadir != null
                                  ? 'Hadir: ${idTime(item.waktuHadir!, format: 'HH:mm')}'
                                  : '-',
                              textAlign: TextAlign.end,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                item.waktuPulang != null
                                    ? 'Pulang: ${idTime(item.waktuPulang!, format: 'HH:mm')}'
                                    : 'Belum Presensi',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
