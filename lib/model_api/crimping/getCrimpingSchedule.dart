// To parse this JSON data, do
//
//     final getCrimpingSchedule = getCrimpingScheduleFromJson(jsonString);

import 'dart:convert';

GetCrimpingSchedule getCrimpingScheduleFromJson(String str) =>
    GetCrimpingSchedule.fromJson(json.decode(str));

String getCrimpingScheduleToJson(GetCrimpingSchedule data) => json.encode(data.toJson());

class GetCrimpingSchedule {
  GetCrimpingSchedule({
    required this.status,
    required this.statusMsg,
    this.errorCode,
    required this.data,
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
    required this.crimpingBundleList,
  });

  List<CrimpingSchedule> crimpingBundleList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        crimpingBundleList: List<CrimpingSchedule>.from(
            json["Crimping Bundle List "].map((x) => CrimpingSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Crimping Bundle List ": List<dynamic>.from(crimpingBundleList.map((x) => x.toJson())),
      };
}

class CrimpingSchedule {
  CrimpingSchedule({
    required this.cablePartNo,
    required this.length,
    required this.wireColour,
    required this.purchaseOrder,
    required this.finishedGoods,
    required this.scheduleId,
    required this.process,
    required this.binIdentification,
    required this.schedulestatus,
    required this.bundleIdentificationCount,
    required this.bundleQuantityTotal,
    required this.awg,
    required this.shiftStart,
    required this.shiftEnd,
    required this.scheduleDate,
    required this.plannedQuantity,
    required this.cableNumber,
    required this.schdeuleQuantity,
    required this.actualQuantity,
    required this.shiftNumber,
    this.startDate,
    required this.lengthTolerance,
    required this.route,
    required this.shiftType,
    required this.crimpFrom,
    required this.crimpTo,
    required this.crimpColor,
    required this.wireCuttingSortingNumber,
    required this.terminalFrom,
    required this.terminalTo,
    required this.machineNo,
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
  String crimpFrom;
  String crimpTo;
  String crimpColor;
  int wireCuttingSortingNumber;
  int terminalFrom;
  int terminalTo;
  String machineNo;

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
        crimpFrom: json["crimpFrom"],
        crimpTo: json["crimpTo"],
        crimpColor: json["crimpColor"],
        wireCuttingSortingNumber: json["wireCuttingSortingNumber"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        machineNo: json["machineNo"],
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
        "scheduleDate":
            "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
        "plannedQuantity": plannedQuantity,
        "cableNumber": cableNumber,
        "schdeuleQuantity": schdeuleQuantity,
        "actualQuantity": actualQuantity,
        "shiftNumber": shiftNumber,
        "startDate": startDate,
        "lengthTolerance": lengthTolerance,
        "route": route,
        "shiftType": shiftType,
        "crimpFrom": crimpFrom,
        "crimpTo": crimpTo,
        "crimpColor": crimpColor,
        "wireCuttingSortingNumber": wireCuttingSortingNumber,
        "terminalFrom": terminalFrom,
        "terminalTo": terminalTo,
        "machineNo": machineNo,
      };
}
