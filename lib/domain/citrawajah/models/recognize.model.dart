// To parse this JSON data, do
//
//     final recognizeResponse = recognizeResponseFromJson(jsonString);

import 'dart:convert';

RecognizeResponse recognizeResponseFromJson(String str) =>
    RecognizeResponse.fromJson(json.decode(str));

String recognizeResponseToJson(RecognizeResponse data) =>
    json.encode(data.toJson());

class RecognizeResponse {
  RecognizeResponse({
    this.confidence,
    this.percent,
    this.karyawan,
  });

  double? confidence;
  String? percent;
  Karyawan? karyawan;

  factory RecognizeResponse.fromJson(Map<String, dynamic> json) =>
      RecognizeResponse(
        confidence: json["confidence"],
        percent: json["percent"],
        karyawan: json["karyawan"] == null
            ? null
            : Karyawan.fromJson(json["karyawan"]),
      );

  Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "percent": percent,
        "karyawan": karyawan?.toJson(),
      };
}

class Karyawan {
  Karyawan({
    this.url,
    this.karyawanId,
    this.noinduk,
    this.nama,
    this.user,
    this.divisi,
  });

  String? url;
  int? karyawanId;
  String? noinduk;
  String? nama;
  String? user;
  String? divisi;

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
        url: json["url"],
        karyawanId: json["karyawan_id"],
        noinduk: json["noinduk"],
        nama: json["nama"],
        user: json["user"],
        divisi: json["divisi"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "karyawan_id": karyawanId,
        "noinduk": noinduk,
        "nama": nama,
        "user": user,
        "divisi": divisi,
      };
}
