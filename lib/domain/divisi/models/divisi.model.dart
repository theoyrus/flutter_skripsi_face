// To parse this JSON data, do
//
//     final divisiList = divisiListFromJson(jsonString);

import 'dart:convert';

List<DivisiList> divisiListFromJson(String str) =>
    List<DivisiList>.from(json.decode(str).map((x) => DivisiList.fromJson(x)));

String divisiListToJson(List<DivisiList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DivisiList {
  DivisiList({
    this.divisi,
  });

  Divisi? divisi;

  factory DivisiList.fromJson(Map<String, dynamic> json) => DivisiList(
        divisi: json["divisi"] == null ? null : Divisi.fromJson(json["divisi"]),
      );

  Map<String, dynamic> toJson() => {
        "divisi": divisi?.toJson(),
      };
}

class Divisi {
  Divisi({
    this.url,
    this.divisiId,
    this.kode,
    this.nama,
  });

  String? url;
  int? divisiId;
  String? kode;
  String? nama;

  factory Divisi.fromJson(Map<String, dynamic> json) => Divisi(
        url: json["url"],
        divisiId: json["divisi_id"],
        kode: json["kode"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "divisi_id": divisiId,
        "kode": kode,
        "nama": nama,
      };
}
