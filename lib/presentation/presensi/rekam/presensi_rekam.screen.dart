import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/face_detect/views/camera.screen.dart';
import '../../../domain/time/time.provider.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../widgets/slideUp.widget.dart';
import 'controllers/presensi_rekam.controller.dart';

class PresensiRekamScreen extends GetView<PresensiRekamController> {
  const PresensiRekamScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekam Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<PresensiRekamController>(
        init: PresensiRekamController(),
        initState: (_) {},
        builder: (_) {
          return controller.cameraReady
              ? Stack(children: [
                  CameraScreen(
                    onPauseText: '...',
                    onFaceDetected: ({cameraImage, faces, statusProses}) {
                      controller.onFaceDetected(
                        faces: faces,
                        camImg: cameraImage,
                        statusProses: statusProses,
                      );
                      // if (statusProses == 'ONDONE') controller.panelCtrl.open();
                    },
                  ),
                  SlideUpWidget(
                    panelCtrl: controller.panelCtrl,
                    panel: panelSlideUp(),
                    minHeight: 200,
                  ),
                  // Load a Lottie file from your assets
                  Obx(
                    () => Visibility(
                      visible: controller.faceCaptured.isTrue,
                      child: lottie.Lottie.asset('assets/lotties/face-ok.json'),
                    ),
                  ),
                ])
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  List<Widget> panelSlideUp() {
    return [
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          ),
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Rekam Presensi\nPengenalan Wajah",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          controller.faceRecognized.isTrue
              // ? buttonPanel(
              //     label: 'Rekam',
              //     icon: Icons.check,
              //     color: Colors.green,
              //     onTap: () => controller.rekam(),
              //   )
              ? const Text('')
              : buttonPanel(
                  label: 'Ulangi',
                  icon: Icons.replay_outlined,
                  color: Colors.amber,
                  onTap: () {
                    controller.ulangProses();
                  },
                ),
        ],
      ),
      const SizedBox(
        height: 20.0,
      ),
      controller.faceRecognized.isTrue
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: FormBuilder(
                child: Column(
                  children: [
                    Center(
                      child: GetBuilder<TimeProvider>(
                        init: TimeProvider(),
                        builder: (_) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_.waktu.value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 25)),
                                Visibility(
                                    visible: _.waktu.value ==
                                        'Gagal mengambil waktu server',
                                    child: InkWell(
                                        onTap: () => _.getJam(),
                                        child: const Icon(Icons.refresh)))
                              ]);
                        },
                      ),
                    ),
                    const Center(
                      child: Text('Citra Wajah Dikenali',
                          style: TextStyle(fontSize: 25)),
                    ),
                    controller.isCatatanLatLong
                        ? FormBuilderTextField(
                            name: 'catatan',
                            decoration: const InputDecoration(
                              labelText: 'Catatan',
                              prefixIcon: Icon(Icons.notes),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                          )
                        : const Text(''),
                    const SizedBox(
                      height: 20.0,
                    ),
                    controller.isCatatanLatLong
                        ? const Text(
                            'Titik Lokasi',
                            style: TextStyle(fontSize: 16),
                          )
                        : const Text(''),
                    controller.isCatatanLatLong
                        ? Container(
                            height: 250,
                            padding: const EdgeInsets.all(10),
                            child: FlutterMap(
                              // mapController: controller.mapCtrl,
                              options: MapOptions(
                                // center: LatLng(-7.7481293, 110.3585042),
                                zoom: 16,
                                maxZoom: 19,
                                enableScrollWheel: false,
                                interactiveFlags: InteractiveFlag.drag,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  // subdomains: const ['a', 'b', 'c'],
                                ),
                                // CurrentLocationLayer(
                                //   positionStream:
                                //       const LocationMarkerDataStreamFactory()
                                //           .fromGeolocatorPositionStream(
                                //     stream: Geolocator.getPositionStream(
                                //       locationSettings: const LocationSettings(
                                //         accuracy: LocationAccuracy.medium,
                                //         distanceFilter: 50,
                                //         timeLimit: Duration(minutes: 1),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                CurrentLocationLayer(
                                  followOnLocationUpdate:
                                      FollowOnLocationUpdate.always,
                                  turnOnHeadingUpdate:
                                      TurnOnHeadingUpdate.never,
                                  style: const LocationMarkerStyle(
                                    marker: DefaultLocationMarker(
                                      child: Icon(
                                        MdiIcons.mapMarker,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                    ),
                                    markerSize: Size(40, 40),
                                    markerDirection: MarkerDirection.top,
                                  ),
                                ),
                                // MarkerLayer(
                                //   markers: [
                                //     Marker(
                                //       point: LatLng(-7.7481293, 110.3585042),
                                //       builder: (ctx) => const Icon(
                                //         MdiIcons.mapMarker,
                                //         color: Colors.red,
                                //         size: 32,
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            )
          : const Center(child: Text('Wajah tidak dikenali :(')),
      const SizedBox(
        height: 10,
      ),
      controller.faceRecognized.isTrue
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: AppTheme.secondaryButtonStyle,
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => controller.rekam(),
                        child: const Text('Konfirmasi')),
                  ),
                ],
              ),
            )
          : const Text(''),
    ];
  }
}
