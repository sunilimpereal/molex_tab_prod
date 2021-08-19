// To parse this JSON data, do
//
//     final getBundleListGl = getBundleListGlFromJson(jsonString);

import 'dart:convert';

GetBundleListGl getBundleListGlFromJson(String str) => GetBundleListGl.fromJson(json.decode(str));

String getBundleListGlToJson(GetBundleListGl data) => json.encode(data.toJson());

class GetBundleListGl {
    GetBundleListGl({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetBundleListGl.fromJson(Map<String, dynamic> json) => GetBundleListGl(
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
        this.bundlesRetrieved,
    });

    List<BundlesRetrieved> bundlesRetrieved;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundlesRetrieved: List<BundlesRetrieved>.from(json[" Bundles Retrieved "].map((x) => BundlesRetrieved.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        " Bundles Retrieved ": List<dynamic>.from(bundlesRetrieved.map((x) => x.toJson())),
    };
}

class BundlesRetrieved {
    BundlesRetrieved({
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
          this.crimpFromSchId,
        this.crimpToSchId,
        this.preparationCompleteFlag,
        this.viCompleted,
    });

    int id;
    String bundleIdentification;
    int scheduledId;
    DateTime bundleCreationTime;
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
    String locationId;
    String orderId;
    String updateFromProcess;
    String awg;
     String crimpFromSchId;
    String crimpToSchId;
    String preparationCompleteFlag;
    String viCompleted;


    factory BundlesRetrieved.fromJson(Map<String, dynamic> json) => BundlesRetrieved(
        id: json["id"],
        bundleIdentification: json["bundleIdentification"],
        scheduledId: json["scheduledId"],
        bundleCreationTime: DateTime.parse(json["bundleCreationTime"]),
        bundleUpdateTime: json["bundleUpdateTime"],
        bundleQuantity: json["bundleQuantity"],
        machineIdentification: json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"] == null ? null : json["operatorIdentification"],
        finishedGoodsPart: json["finishedGoodsPart"],
        cablePartNumber: json["cablePartNumber"],
        cablePartDescription: json["cablePartDescription"],
        cutLengthSpecificationInmm: json["cutLengthSpecificationInmm"],
        color: json["color"],
        bundleStatus: json["bundleStatus"],
        binId: json["binId"] == null ? null : json["binId"],
        locationId: json["locationId"] == null ? null : json["locationId"],
        orderId: json["orderId"],
        updateFromProcess: json["updateFromProcess"],
        awg: json["awg"],
         crimpFromSchId: json["crimpFromSchId"],
        crimpToSchId: json["crimpToSchId"],
        preparationCompleteFlag: json["preparationCompleteFlag"],
        viCompleted: json["viCompleted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bundleIdentification": bundleIdentification,
        "scheduledId": scheduledId,
        "bundleCreationTime": "${bundleCreationTime.year.toString().padLeft(4, '0')}-${bundleCreationTime.month.toString().padLeft(2, '0')}-${bundleCreationTime.day.toString().padLeft(2, '0')}",
        "bundleUpdateTime": bundleUpdateTime,
        "bundleQuantity": bundleQuantity,
        "machineIdentification": machineIdentification,
        "operatorIdentification": operatorIdentification == null ? null : operatorIdentification,
        "finishedGoodsPart": finishedGoodsPart,
        "cablePartNumber": cablePartNumber,
        "cablePartDescription": cablePartDescription,
        "cutLengthSpecificationInmm": cutLengthSpecificationInmm,
        "color": color,
        "bundleStatus": bundleStatus,
        "binId": binId == null ? null : binId,
        "locationId": locationId == null ? null : locationId,
        "orderId": orderId,
        "updateFromProcess": updateFromProcess,
        "awg": awg,
        "crimpFromSchId": crimpFromSchId,
        "crimpToSchId": crimpToSchId,
        "preparationCompleteFlag": preparationCompleteFlag,
        "viCompleted": viCompleted,
    };
}


