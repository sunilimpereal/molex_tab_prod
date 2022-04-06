// To parse this JSON data, do
//
//     final transferBundleToBin = transferBundleToBinFromJson(jsonString);

import 'dart:convert';

List<TransferBundleToBin> transferBundleToBinFromJson(String str) =>
    List<TransferBundleToBin>.from(json.decode(str).map((x) => TransferBundleToBin.fromJson(x)));

String transferBundleToBinToJson(List<TransferBundleToBin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferBundleToBin {
  TransferBundleToBin({
    required this.binIdentification,
    required this.bundleId,
    required this.userId,
    required this.locationId,
  });

  String binIdentification;
  String bundleId;
  String userId;
  String locationId;

  factory TransferBundleToBin.fromJson(Map<String, dynamic> json) => TransferBundleToBin(
        binIdentification: json["binIdentification"],
        bundleId: json["bundleId"],
        userId: json["userId"],
        locationId: json["locationId"],
      );

  Map<String, dynamic> toJson() => {
        "binIdentification": binIdentification,
        "bundleId": bundleId,
        "userId": userId,
        "locationId": locationId,
      };
}

// To parse this JSON data, do
//

// To parse this JSON data, do
//
//     final responseTransferBundletoBin = responseTransferBundletoBinFromJson(jsonString);

ResponseTransferBundletoBin responseTransferBundletoBinFromJson(String str) =>
    ResponseTransferBundletoBin.fromJson(json.decode(str));

String responseTransferBundletoBinToJson(ResponseTransferBundletoBin data) =>
    json.encode(data.toJson());

class ResponseTransferBundletoBin {
  ResponseTransferBundletoBin({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory ResponseTransferBundletoBin.fromJson(Map<String, dynamic> json) =>
      ResponseTransferBundletoBin(
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
    required this.bundleTransferToBinTracking,
  });

  List<BundleTransferToBin> bundleTransferToBinTracking;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundleTransferToBinTracking: List<BundleTransferToBin>.from(
            json[" Bundle Transfer to Bin Tracking "].map((x) => BundleTransferToBin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        " Bundle Transfer to Bin Tracking ":
            List<dynamic>.from(bundleTransferToBinTracking.map((x) => x.toJson())),
      };
}

class BundleTransferToBin {
  BundleTransferToBin({
    required this.bundleIdentification,
    required this.scheduledId,
    required this.bundleCreationTime,
    required this.bundleUpdateTime,
    required this.bundleQuantity,
    required this.machineIdentification,
    required this.operatorIdentification,
    required this.finishedGoodsPart,
    required this.cablePartNumber,
    required this.cablePartDescription,
    required this.cutLengthSpecificationInmm,
    required this.color,
    required this.bundleStatus,
    required this.binId,
    required this.locationId,
    required this.orderId,
    required this.updateFromProcess,
    required this.awg,
    required this.crimpFromSchId,
    required this.crimpToSchId,
    required this.preparationCompleteFlag,
    required this.viCompleted,
  });

  int bundleIdentification;
  int scheduledId;
  dynamic bundleCreationTime;
  dynamic bundleUpdateTime;
  int bundleQuantity;
  String machineIdentification;
  String operatorIdentification;
  int finishedGoodsPart;
  int cablePartNumber;
  dynamic cablePartDescription;
  int cutLengthSpecificationInmm;
  String color;
  String bundleStatus;
  int binId;
  dynamic locationId;
  String orderId;
  String updateFromProcess;
  String awg;
  String crimpFromSchId;
  String crimpToSchId;
  String preparationCompleteFlag;
  String viCompleted;

  factory BundleTransferToBin.fromJson(Map<String, dynamic> json) => BundleTransferToBin(
        bundleIdentification: json["bundleIdentification"],
        scheduledId: json["scheduledId"],
        bundleCreationTime: json["bundleCreationTime"],
        bundleUpdateTime: json["bundleUpdateTime"],
        bundleQuantity: json["bundleQuantity"],
        machineIdentification: json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"],
        finishedGoodsPart: json["finishedGoodsPart"],
        cablePartNumber: json["cablePartNumber"],
        cablePartDescription: json["cablePartDescription"],
        cutLengthSpecificationInmm: json["cutLengthSpecificationInmm"],
        color: json["color"],
        bundleStatus: json["bundleStatus"],
        binId: json["binId"],
        locationId: json["locationId"],
        orderId: json["orderId"],
        updateFromProcess: json["updateFromProcess"],
        awg: json["awg"],
        crimpFromSchId: json["crimpFromSchId"],
        crimpToSchId: json["crimpToSchId"],
        preparationCompleteFlag: json["preparationCompleteFlag"],
        viCompleted: json["viCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "bundleIdentification": bundleIdentification,
        "scheduledId": scheduledId,
        "bundleCreationTime": bundleCreationTime.toIso8601String(),
        "bundleUpdateTime": bundleUpdateTime,
        "bundleQuantity": bundleQuantity,
        "machineIdentification": machineIdentification,
        "operatorIdentification": operatorIdentification,
        "finishedGoodsPart": finishedGoodsPart,
        "cablePartNumber": cablePartNumber,
        "cablePartDescription": cablePartDescription,
        "cutLengthSpecificationInmm": cutLengthSpecificationInmm,
        "color": color,
        "bundleStatus": bundleStatus,
        "binId": binId,
        "locationId": locationId,
        "orderId": orderId,
        "updateFromProcess": updateFromProcess,
        "awg": awg,
        "crimpFromSchId": crimpFromSchId,
        "crimpToSchId": crimpToSchId,
        "preparationCompleteFlag": preparationCompleteFlag,
        "viCompleted": viCompleted,
      };
}
