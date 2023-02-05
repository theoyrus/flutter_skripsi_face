// To parse this JSON data, do
//
//     final citraWajah = citraWajahFromJson(jsonString);

import 'dart:convert';

CitraWajah? citraWajahFromJson(String str) =>
    CitraWajah.fromJson(json.decode(str));

String citraWajahToJson(CitraWajah? data) => json.encode(data!.toJson());

class CitraWajah {
  CitraWajah({
    this.url,
    this.karyawanNama,
    this.created,
    this.updated,
    this.nama,
    this.karyawan,
  });

  String? url;
  String? karyawanNama;
  DateTime? created;
  DateTime? updated;
  String? nama;
  String? karyawan;

  factory CitraWajah.fromJson(Map<String, dynamic> json) => CitraWajah(
        url: json["url"],
        karyawanNama: json["karyawan_nama"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        nama: json["nama"],
        karyawan: json["karyawan"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "karyawan_nama": karyawanNama,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "nama": nama,
        "karyawan": karyawan,
      };
}
