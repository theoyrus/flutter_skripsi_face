// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.tokenType,
    this.exp,
    this.jti,
    this.userId,
    this.username,
    this.karyawanId,
    this.karyawanNama,
  });

  String? tokenType;
  int? exp;
  String? jti;
  int? userId;
  String? username;
  dynamic karyawanId;
  dynamic karyawanNama;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        tokenType: json["token_type"],
        exp: json["exp"],
        jti: json["jti"],
        userId: json["user_id"],
        username: json["username"],
        karyawanId: json["karyawan_id"],
        karyawanNama: json["karyawan_nama"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "exp": exp,
        "jti": jti,
        "user_id": userId,
        "username": username,
        "karyawan_id": karyawanId,
        "karyawan_nama": karyawanNama,
      };
}
