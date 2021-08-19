// To parse this JSON data, do
//
//     final getBundleDetail = getBundleDetailFromJson(jsonString);

import 'dart:convert';

GetBundleDetail getBundleDetailFromJson(String str) => GetBundleDetail.fromJson(json.decode(str));

String getBundleDetailToJson(GetBundleDetail data) => json.encode(data.toJson());

class GetBundleDetail {
    GetBundleDetail({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetBundleDetail.fromJson(Map<String, dynamic> json) => GetBundleDetail(
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
        this.bundleData,
    });

    BundleData bundleData;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundleData: BundleData.fromJson(json["Bundle Data"]),
    );

    Map<String, dynamic> toJson() => {
        "Bundle Data": bundleData.toJson(),
    };
}

class BundleData {
    BundleData({
        this.id,
        this.bundleIdentification,
        this.scheduledId,
        this.bundleCreationTime,
        this.bundleUpdateTime,
        this.bundleQuantity,
        this.machineIdentification,
        this.operatorIdentification,
        this.finishedGoodsPart,
        this.cablePartNumber,
        this.cablePartDescription,
        this.cutLengthSpecificationInmm,
        this.color,
        this.bundleStatus,
        this.binId,
        this.locationId,
        this.orderId,
        this.updateFromProcess,
        this.awg,
    });

    int id;
    String bundleIdentification;
    int scheduledId;
    DateTime bundleCreationTime;
    String bundleUpdateTime;
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

    factory BundleData.fromJson(Map<String, dynamic> json) => BundleData(
        id: json["id"],
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bundleIdentification": bundleIdentification,
        "scheduledId": scheduledId,
        "bundleCreationTime": "${bundleCreationTime.year.toString().padLeft(4, '0')}-${bundleCreationTime.month.toString().padLeft(2, '0')}-${bundleCreationTime.day.toString().padLeft(2, '0')}",
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
    };
}
