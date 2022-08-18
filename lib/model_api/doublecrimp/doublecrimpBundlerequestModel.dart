// To parse this JSON data, do
//
//     final doubleCrimpBundleRequestModel = doubleCrimpBundleRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:molex/model_api/process1/getBundleListGl.dart';

DoubleCrimpBundleRequestModel doubleCrimpBundleRequestModelFromJson(String str) =>
    DoubleCrimpBundleRequestModel.fromJson(json.decode(str));

String doubleCrimpBundleRequestModelToJson(DoubleCrimpBundleRequestModel data) =>
    json.encode(data.toJson());

class DoubleCrimpBundleRequestModel {
  DoubleCrimpBundleRequestModel({
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

  factory DoubleCrimpBundleRequestModel.fromJson(Map<String, dynamic> json) =>
      DoubleCrimpBundleRequestModel(
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

// To parse this JSON data, do
//
//     final doubleCrimpBundleListResponse = doubleCrimpBundleListResponseFromJson(jsonString);

DoubleCrimpBundleListResponse doubleCrimpBundleListResponseFromJson(String str) =>
    DoubleCrimpBundleListResponse.fromJson(json.decode(str));

String doubleCrimpBundleListResponseToJson(DoubleCrimpBundleListResponse data) =>
    json.encode(data.toJson());

class DoubleCrimpBundleListResponse {
  DoubleCrimpBundleListResponse({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory DoubleCrimpBundleListResponse.fromJson(Map<String, dynamic> json) =>
      DoubleCrimpBundleListResponse(
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
    required this.bundles,
  });

  List<BundlesRetrieved> bundles;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundles:
            List<BundlesRetrieved>.from(json[" Bundles "].map((x) => BundlesRetrieved.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        " Bundles ": List<dynamic>.from(bundles.map((x) => x.toJson())),
      };
}
