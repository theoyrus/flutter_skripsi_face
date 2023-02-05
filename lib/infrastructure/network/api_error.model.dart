// To parse this JSON data, do
//
//     final apiError = apiErrorFromJson(jsonString);

import 'dart:convert';

ApiError apiErrorFromJson(String str) => ApiError.fromJson(json.decode(str));

String apiErrorToJson(ApiError data) => json.encode(data.toJson());

class ApiError {
  ApiError({
    this.type,
    this.error,
  });

  String? type;
  Error? error;

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        type: json["type"],
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "error": error?.toJson(),
      };
}

class Error {
  Error({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  int? statusCode;
  String? status;
  String? message;
  // Data? data;
  dynamic? data;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        statusCode: json["status_code"],
        status: json["status"],
        message: json["message"],
        // data: json["data"] == null ? null : Data.fromJson(json["data"]),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "message": message,
        // "data": data?.toJson(),
        "data": data,
      };
}

class DataX {
  DataX({
    this.detail,
  });

  String? detail;

  factory DataX.fromJson(Map<String, dynamic> json) => DataX(
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
      };
}

class Data {
  Map<String, dynamic> dataMap;

  Data({required this.dataMap});

  factory Data.fromJson(Map<String, dynamic> json) => Data(dataMap: json);
}
