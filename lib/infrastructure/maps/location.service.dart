import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:trust_location/trust_location.dart';

import '../../utils/snackbar.utils.dart';

class LocationService {
  late Location _locationService;

  // singleton boilerplate
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal() {
    _locationService = Location();
  }

  static LocationService getInstance() {
    return _instance;
  }

  Future<LocationData> ambilLocation() async {
    final location = await _locationService.getLocation();
    return location;
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    var lokasi = _locationService;
    serviceEnabled = await _locationService.serviceEnabled();

    // cek service
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    // cek permission
    permissionGranted = await lokasi.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await lokasi.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future getLocation(Function? onLocated) async {
    final hasPermisson = await _locationService.requestPermission();
    if (hasPermisson == PermissionStatus.denied) {
      return showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permission Denied'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const [
                    Text(
                        "Tanpa izin penggunaan lokasi aplikasi ini tidak dapat digunakan dengan baik. Apa anda yakin menolak izin pengaktifan lokasi?",
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('COBA LAGI'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    requestPermission();
                  },
                ),
                TextButton(
                  child: const Text('SAYA YAKIN'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      //get Location
      TrustLocation.start(5);
      try {
        TrustLocation.onChange.listen((values) {
          var mockStatus = values.isMockLocation;
          if (mockStatus == true) {
            AppSnackBar.showErrorToast(
              message:
                  'Fake GPS terdeteksi. Mohon non aktifkan fitur Fake GPS Anda',
            );
            TrustLocation.stop();
            return;
          }

          if (onLocated != null) {
            onLocated.call(values);
          }

          // if (mounted) {
          //   setState(() {
          //     isLoading = false;
          //     _latitude = double.parse(values.latitude.toString());
          //     _longitude = double.parse(values.longitude.toString());

          //     _mapController.move(LatLng(_latitude, _longitude), 13);

          //     getPlace();
          //   });
          // }
        });
      } on PlatformException catch (e) {
        debugPrint('PlatformException $e');
      }
    }
  }
}
