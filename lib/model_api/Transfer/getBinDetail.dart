// To parse this JSON data, do
//
//     final getBinDetail = getBinDetailFromJson(jsonString);

import 'dart:convert';

GetBinDetail getBinDetailFromJson(String str) => GetBinDetail.fromJson(json.decode(str));

String getBinDetailToJson(GetBinDetail data) => json.encode(data.toJson());

class GetBinDetail {
  GetBinDetail({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory GetBinDetail.fromJson(Map<String, dynamic> json) => GetBinDetail(
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
    required this.materialCodinatorSchedulerData,
  });

  List<BundleDetail> materialCodinatorSchedulerData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        materialCodinatorSchedulerData: List<BundleDetail>.from(
            json["  Material Codinator Scheduler Data "].map((x) => BundleDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "  Material Codinator Scheduler Data ":
            List<dynamic>.from(materialCodinatorSchedulerData.map((x) => x.toJson())),
      };
}

class BundleDetail {
  BundleDetail({
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
  DateTime bundleCreationTime;
  dynamic bundleUpdateTime;
  int bundleQuantity;
  String machineIdentification;
  String operatorIdentification;
  int finishedGoodsPart;
  int cablePartNumber;
  String cablePartDescription;
  int cutLengthSpecificationInmm;
  String color;
  String bundleStatus;
  int binId;
  String locationId;
  String orderId;
  String updateFromProcess;
  String awg;
  String crimpFromSchId;
  String crimpToSchId;
  String preparationCompleteFlag;
  String viCompleted;

  factory BundleDetail.fromJson(Map<String, dynamic> json) => BundleDetail(
        bundleIdentification: json["bundleIdentification"],
        scheduledId: json["scheduledId"],
        bundleCreationTime: DateTime.parse(json["bundleCreationTime"]),
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
