// To parse this JSON data, do
//
//     final kehadiranBulanIni = kehadiranBulanIniFromJson(jsonString);

import 'dart:convert';

KehadiranBulanIni kehadiranBulanIniFromJson(String str) =>
    KehadiranBulanIni.fromJson(json.decode(str));

String kehadiranBulanIniToJson(KehadiranBulanIni data) =>
    json.encode(data.toJson());

class KehadiranBulanIni {
  KehadiranBulanIni({
    this.karyawanId,
    this.hadir,
    this.terlambat,
    this.tidakHadir,
  });

  int? karyawanId;
  int? hadir;
  int? terlambat;
  int? tidakHadir;

  factory KehadiranBulanIni.fromJson(Map<String, dynamic> json) =>
      KehadiranBulanIni(
        karyawanId: json["karyawan_id"],
        hadir: json["hadir"],
        terlambat: json["terlambat"],
        tidakHadir: json["tidak_hadir"],
      );

  Map<String, dynamic> toJson() => {
        "karyawan_id": karyawanId,
        "hadir": hadir,
        "terlambat": terlambat,
        "tidak_hadir": tidakHadir,
      };
}
