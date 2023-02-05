// To parse this JSON data, do
//
//     final karyawanMe = karyawanMeFromJson(jsonString);

import 'dart:convert';

KaryawanMe karyawanMeFromJson(String str) =>
    KaryawanMe.fromJson(json.decode(str));

String karyawanMeToJson(KaryawanMe data) => json.encode(data.toJson());

class KaryawanMe {
  KaryawanMe({
    this.noinduk,
    this.nama,
    this.user,
    this.divisi,
  });

  String? noinduk;
  String? nama;
  User? user;
  Divisi? divisi;

  factory KaryawanMe.fromJson(Map<String, dynamic> json) => KaryawanMe(
        noinduk: json["noinduk"],
        nama: json["nama"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        divisi: json["divisi"] == null ? null : Divisi.fromJson(json["divisi"]),
      );

  Map<String, dynamic> toJson() => {
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

KaryawanRequest karyawanRequestFromJson(String str) =>
    KaryawanRequest.fromJson(json.decode(str));

String karyawanRequestToJson(KaryawanRequest data) =>
    json.encode(data.toJson());

class KaryawanRequest {
  KaryawanRequest({
    this.noinduk,
    this.nama,
    this.user,
    this.divisi,
  });

  String? noinduk;
  String? nama;
  int? user;
  int? divisi;

  factory KaryawanRequest.fromJson(Map<String, dynamic> json) =>
      KaryawanRequest(
        noinduk: json["noinduk"],
        nama: json["nama"],
        user: json["user"],
        divisi: json["divisi"],
      );

  Map<String, dynamic> toJson() => {
        "noinduk": noinduk,
        "nama": nama,
        "user": user,
        "divisi": divisi,
      };
}
