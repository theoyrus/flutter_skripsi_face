// To parse this JSON data, do
//
//     final kehadiran = kehadiranFromJson(jsonString);

import 'dart:convert';

Kehadiran kehadiranFromJson(String str) => Kehadiran.fromJson(json.decode(str));

String kehadiranToJson(Kehadiran data) => json.encode(data.toJson());

class Kehadiran {
  Kehadiran({
    this.url,
    this.presensiId,
    this.karyawan,
    this.tanggal,
    this.waktuHadir,
    this.waktuPulang,
    this.created,
    this.updated,
  });

  String? url;
  int? presensiId;
  Karyawan? karyawan;
  DateTime? tanggal;
  DateTime? waktuHadir;
  DateTime? waktuPulang;
  DateTime? created;
  DateTime? updated;

  factory Kehadiran.fromJson(Map<String, dynamic> json) => Kehadiran(
        url: json["url"],
        presensiId: json["presensi_id"],
        karyawan: json["karyawan"] == null
            ? null
            : Karyawan.fromJson(json["karyawan"]),
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        // waktuHadir: json["waktu_hadir"] == null
        //     ? null
        //     : DateTime.parse(json["waktu_hadir"]),
        // waktuPulang: json["waktu_pulang"] == null
        //     ? null
        //     : DateTime.parse(json["waktu_pulang"]),

        // mempertahankan format waktu timezone dari service, tidak dikonversi utc
        waktuHadir: json["waktu_hadir"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                DateTime.parse(json["waktu_hadir"]).millisecondsSinceEpoch,
                isUtc: false,
              ),
        waktuPulang: json["waktu_pulang"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                DateTime.parse(json["waktu_pulang"]).millisecondsSinceEpoch,
                isUtc: false,
              ),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "presensi_id": presensiId,
        "karyawan": karyawan?.toJson(),
        "tanggal":
            "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "waktu_hadir": waktuHadir?.toIso8601String(),
        "waktu_pulang": waktuPulang?.toIso8601String(),
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
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
  User? user;
  Divisi? divisi;

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
        url: json["url"],
        karyawanId: json["karyawan_id"],
        noinduk: json["noinduk"],
        nama: json["nama"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        divisi: json["divisi"] == null ? null : Divisi.fromJson(json["divisi"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "karyawan_id": karyawanId,
        "noinduk": noinduk,
        "nama": nama,
        "user": user?.toJson(),
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

class User {
  User({
    this.url,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.groups,
  });

  String? url;
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  List<String>? groups;

  factory User.fromJson(Map<String, dynamic> json) => User(
        url: json["url"],
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        groups: json["groups"] == null
            ? []
            : List<String>.from(json["groups"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "id": id,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "groups":
            groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
      };
}
