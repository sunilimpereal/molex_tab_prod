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
      required  this.materialCodinatorSchedulerData,
    });

    List<BundleDetail> materialCodinatorSchedulerData;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        materialCodinatorSchedulerData: List<BundleDetail>.from(json["  Material Codinator Scheduler Data "].map((x) => BundleDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "  Material Codinator Scheduler Data ": List<dynamic>.from(materialCodinatorSchedulerData.map((x) => x.toJson())),
    };
}

class BundleDetail {
    BundleDetail({
      required  this.id,
      required  this.bundleIdentification,
      required  this.scheduledId,
      required  this.bundleCreationTime,
      required  this.bundleQuantity,
      required  this.machineIdentification,
      required  this.operatorIdentification,
      required  this.finishedGoodsPart,
      required  this.cablePartNumber,
      required  this.cablePartDescription,
      required  this.cutLengthSpecificationInmm,
      required  this.color,
      required  this.bundleStatus,
      required  this.binId,
      required  this.locationId,
      required  this.orderId,
      required  this.updateFromProcess,
    });

    int id;
    String bundleIdentification;
    int scheduledId;
    DateTime bundleCreationTime;
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
    String locationId;
    String orderId;
    String updateFromProcess;

    factory BundleDetail.fromJson(Map<String, dynamic> json) => BundleDetail(
        id: json["id"],
        bundleIdentification: json["bundleIdentification"],
        scheduledId: json["scheduledId"],
        bundleCreationTime: DateTime.parse(json["bundleCreationTime"]),
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bundleIdentification": bundleIdentification,
        "scheduledId": scheduledId,
        "bundleCreationTime": "${bundleCreationTime.year.toString().padLeft(4, '0')}-${bundleCreationTime.month.toString().padLeft(2, '0')}-${bundleCreationTime.day.toString().padLeft(2, '0')}",
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
    };
}
