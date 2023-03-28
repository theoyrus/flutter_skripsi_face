// To parse this JSON data, do
//
//     final citraWajah = citraWajahFromJson(jsonString);

import 'dart:convert';

List<CitraWajah> citraWajahFromJson(String str) =>
    List<CitraWajah>.from(json.decode(str).map((x) => CitraWajah.fromJson(x)));

String citraWajahToJson(List<CitraWajah> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CitraWajah {
  CitraWajah({
    this.url,
    this.citrawajahId,
    this.karyawan,
    this.nama,
    this.created,
    this.updated,
  });

  String? url;
  int? citrawajahId;
  dynamic? karyawan;
  String? nama;
  DateTime? created;
  DateTime? updated;

  factory CitraWajah.fromJson(Map<String, dynamic> json) => CitraWajah(
        url: json["url"],
        citrawajahId: json["citrawajah_id"],
        karyawan: json["karyawan"],
        nama: json["nama"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "citrawajah_id": citrawajahId,
        "karyawan": karyawan,
        "nama": nama,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
      };
}
