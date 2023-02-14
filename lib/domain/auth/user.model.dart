// To parse this JSON data, do
//
//     final userMe = userMeFromJson(jsonString);

import 'dart:convert';

UserMe userMeFromJson(String str) => UserMe.fromJson(json.decode(str));

String userMeToJson(UserMe data) => json.encode(data.toJson());

class UserMe {
  UserMe({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
  });

  int? id;
  String? email;
  String? username;
  String? firstName;
  String? lastName;

  factory UserMe.fromJson(Map<String, dynamic> json) => UserMe(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}

UserMePut userMePutFromJson(String str) => UserMePut.fromJson(json.decode(str));

String userMePutToJson(UserMePut data) => json.encode(data.toJson());

class UserMePut {
  UserMePut({
    this.email,
    this.username,
    this.firstName,
    this.lastName,
  });

  String? email;
  String? username;
  String? firstName;
  String? lastName;

  factory UserMePut.fromJson(Map<String, dynamic> json) => UserMePut(
        email: json["email"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}

UserMeChangePass userMeChangePassFromJson(String str) =>
    UserMeChangePass.fromJson(json.decode(str));

String userMeChangePassToJson(UserMeChangePass data) =>
    json.encode(data.toJson());

class UserMeChangePass {
  UserMeChangePass({
    this.newPassword,
    this.currentPassword,
  });

  String? newPassword;
  String? currentPassword;

  factory UserMeChangePass.fromJson(Map<String, dynamic> json) =>
      UserMeChangePass(
        newPassword: json["new_password"],
        currentPassword: json["current_password"],
      );

  Map<String, dynamic> toJson() => {
        "new_password": newPassword,
        "current_password": currentPassword,
      };
}

UserMeChangeEmail userMeChangeEmailFromJson(String str) =>
    UserMeChangeEmail.fromJson(json.decode(str));

String userMeChangeEmailToJson(UserMeChangeEmail data) =>
    json.encode(data.toJson());

class UserMeChangeEmail {
  UserMeChangeEmail({
    this.currentPassword,
    this.newEmail,
  });

  String? currentPassword;
  String? newEmail;

  factory UserMeChangeEmail.fromJson(Map<String, dynamic> json) =>
      UserMeChangeEmail(
        currentPassword: json["current_password"],
        newEmail: json["new_email"],
      );

  Map<String, dynamic> toJson() => {
        "current_password": currentPassword,
        "new_email": newEmail,
      };
}
