// To parse this JSON data, do
//
//     final getCrimpingSchedule = getCrimpingScheduleFromJson(jsonString);

import 'dart:convert';

GetCrimpingSchedule getCrimpingScheduleFromJson(String str) => GetCrimpingSchedule.fromJson(json.decode(str));

String getCrimpingScheduleToJson(GetCrimpingSchedule data) => json.encode(data.toJson());

class GetCrimpingSchedule {
    GetCrimpingSchedule({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetCrimpingSchedule.fromJson(Map<String, dynamic> json) => GetCrimpingSchedule(
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
        this.crimpingBundleList,
    });

    List<CrimpingSchedule> crimpingBundleList;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        crimpingBundleList: List<CrimpingSchedule>.from(json["Crimping Bundle List "].map((x) => CrimpingSchedule.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Crimping Bundle List ": List<dynamic>.from(crimpingBundleList.map((x) => x.toJson())),
    };
}

class CrimpingSchedule {
    CrimpingSchedule({
        this.cablePartNo,
        this.length,
        this.wireColour,
        this.purchaseOrder,
        this.finishedGoods,
        this.scheduleId, 
        this.process,
        this.binIdentification,
        this.schedulestatus,
        this.bundleIdentificationCount,
        this.bundleQuantityTotal,
        this.awg,
        this.shiftStart,
        this.shiftEnd,
        this.scheduleDate,
        this.plannedQuantity,
        this.cableNumber,
        this.schdeuleQuantity,
        this.actualQuantity,
        this.shiftNumber,
        this.startDate,
        this.lengthTolerance,
        this.route,
        this.shiftType,
    });

    int cablePartNo;
    int length;
    String wireColour;
    int purchaseOrder;
    int finishedGoods;
    int scheduleId;
    String process;
    String binIdentification;
    String schedulestatus;
    int bundleIdentificationCount;
    int bundleQuantityTotal;
    String awg;
    String shiftStart;
    String shiftEnd;
    DateTime scheduleDate;
    String plannedQuantity;
    String cableNumber;
    String schdeuleQuantity;
    int actualQuantity;
    int shiftNumber;
    dynamic startDate;
    String lengthTolerance;
    String route;
    String shiftType;

    factory CrimpingSchedule.fromJson(Map<String, dynamic> json) => CrimpingSchedule(
        cablePartNo: json["cablePartNo"],
        length: json["length"],
        wireColour: json["wireColour"],
        purchaseOrder: json["purchaseOrder"],
        finishedGoods: json["finishedGoods"],
        scheduleId: json["scheduleId"],
        process: json["process"],
        binIdentification: json["binIdentification"],
        schedulestatus: json["schedulestatus"],
        bundleIdentificationCount: json["bundleIdentificationCount"],
        bundleQuantityTotal: json["bundleQuantityTotal"],
        awg: json["awg"],
        shiftStart: json["shiftStart"],
        shiftEnd: json["shiftEnd"],
        scheduleDate: DateTime.parse(json["scheduleDate"]),
        plannedQuantity: json["plannedQuantity"],
        cableNumber: json["cableNumber"],
        schdeuleQuantity: json["schdeuleQuantity"],
        actualQuantity: json["actualQuantity"],
        shiftNumber: json["shiftNumber"],
        startDate: json["startDate"],
        lengthTolerance: json["lengthTolerance"],
        route: json["route"],
        shiftType: json["shiftType"],
    );

    Map<String, dynamic> toJson() => {
        "cablePartNo": cablePartNo,
        "length": length,
        "wireColour": wireColour,
        "purchaseOrder": purchaseOrder,
        "finishedGoods": finishedGoods,
        "scheduleId": scheduleId,
        "process": process,
        "binIdentification": binIdentification,
        "schedulestatus": schedulestatus,
        "bundleIdentificationCount": bundleIdentificationCount,
        "bundleQuantityTotal": bundleQuantityTotal,
        "awg": awg,
        "shiftStart": shiftStart,
        "shiftEnd": shiftEnd,
        "scheduleDate": "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
        "plannedQuantity": plannedQuantity,
        "cableNumber": cableNumber,
        "schdeuleQuantity": schdeuleQuantity,
        "actualQuantity": actualQuantity,
        "shiftNumber": shiftNumber,
        "startDate": startDate,
        "lengthTolerance": lengthTolerance,
        "route": route,
        "shiftType": shiftType,
    };
}
