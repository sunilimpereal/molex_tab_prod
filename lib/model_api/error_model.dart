// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) =>
    json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
   required this.status,
   required this.statusMsg,
   required this.errorCode,
   required this.data,
  });

  String status;
  String statusMsg;
  String errorCode;
  Data1 data;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      ErrorModel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data1.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
      };
}

class Data1 {
  Data1();

  factory Data1.fromJson(Map<String, dynamic> json) => Data1();

  Map<String, dynamic> toJson() => {};
}

