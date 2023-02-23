// To parse this JSON data, do
//
//     final bundleDcValidationModel = bundleDcValidationModelFromJson(jsonString);

import 'dart:convert';

BundleDcValidationModel bundleDcValidationModelFromJson(String str) =>
    BundleDcValidationModel.fromJson(json.decode(str));

String bundleDcValidationModelToJson(BundleDcValidationModel data) => json.encode(data.toJson());

class BundleDcValidationModel {
  BundleDcValidationModel({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory BundleDcValidationModel.fromJson(Map<String, dynamic> json) => BundleDcValidationModel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.bundle,
  });

  bool bundle;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundle: json[" Bundle "],
      );

  Map<String, dynamic> toJson() => {
        " Bundle ": bundle,
      };
}

BundleDcValidationRequestModel bundleDcValidationRequestModelFromJson(String str) =>
    BundleDcValidationRequestModel.fromJson(json.decode(str));

String bundleDcValidationRequestModelToJson(BundleDcValidationRequestModel data) =>
    json.encode(data.toJson());

class BundleDcValidationRequestModel {
  BundleDcValidationRequestModel({
    required this.fgNumber,
    required this.orderId,
    required this.scheduleId,
    required this.crimpType,
    required this.bundleId,
  });

  String fgNumber;
  String orderId;
  String scheduleId;
  String crimpType;
  String bundleId;

  factory BundleDcValidationRequestModel.fromJson(Map<String, dynamic> json) =>
      BundleDcValidationRequestModel(
        fgNumber: json["fgNumber"],
        orderId: json["orderId"],
        scheduleId: json["scheduleId"],
        crimpType: json["crimpType"],
        bundleId: json["bundleId"],
      );

  Map<String, dynamic> toJson() => {
        "fgNumber": fgNumber,
        "orderId": orderId,
        "scheduleId": scheduleId,
        "crimpType": crimpType,
        "bundleId": bundleId,
      };
}
