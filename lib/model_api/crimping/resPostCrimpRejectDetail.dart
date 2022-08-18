// To parse this JSON data, do
//
//     final responsePostCrimpingDetail = responsePostCrimpingDetailFromJson(jsonString);

import 'dart:convert';

ResponsePostCrimpingDetail responsePostCrimpingDetailFromJson(String str) =>
    ResponsePostCrimpingDetail.fromJson(json.decode(str));

String responsePostCrimpingDetailToJson(ResponsePostCrimpingDetail data) =>
    json.encode(data.toJson());

class ResponsePostCrimpingDetail {
  ResponsePostCrimpingDetail({
    required this.status,
    required this.statusMsg,
    this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory ResponsePostCrimpingDetail.fromJson(Map<String, dynamic> json) =>
      ResponsePostCrimpingDetail(
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
    required this.crimpingProcess,
  });

  CrimpingResponse crimpingProcess;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        crimpingProcess: CrimpingResponse.fromJson(json[" Crimping process "]),
      );

  Map<String, dynamic> toJson() => {
        " Crimping process ": crimpingProcess.toJson(),
      };
}

class CrimpingResponse {
  CrimpingResponse({
    required this.bundleIdentification,
    required this.bundleQuantity,
    required this.passedQuantity,
    required this.rejectedQuantity,
    required this.crimpInslation,
    required this.insulationSlug,
    required this.windowGap,
    required this.exposedStrands,
    required this.burrOrCutOff,
    required this.terminalBendOrClosedOrDamage,
    required this.nickMarkOrStrandsCut,
    required this.seamOpen,
    required this.missCrimp,
    required this.frontBellMouth,
    required this.backBellMouth,
    required this.extrusionOnBurr,
    required this.brushLength,
    required this.cableDamage,
    required this.terminalTwist,
    required this.orderId,
    required this.fgPart,
    required this.scheduleId,
    required this.binId,
    required this.processType,
    required this.method,
    required this.machineIdentification,
    required this.cablePartNumber,
    required this.cutLength,
    required this.color,
    required this.finishedGoods,
    required this.terminalFrom,
    required this.terminalTo,
    required this.status,
  });

  String bundleIdentification;
  int bundleQuantity;
  int passedQuantity;
  int rejectedQuantity;
  int crimpInslation;
  int insulationSlug;
  int windowGap;
  int exposedStrands;
  int burrOrCutOff;
  int terminalBendOrClosedOrDamage;
  int nickMarkOrStrandsCut;
  int seamOpen;
  int missCrimp;
  int frontBellMouth;
  int backBellMouth;
  int extrusionOnBurr;
  int brushLength;
  int cableDamage;
  int terminalTwist;
  int orderId;
  int fgPart;
  int scheduleId;
  String binId;
  String processType;
  String method;
  String machineIdentification;
  int cablePartNumber;
  int cutLength;
  String color;
  int finishedGoods;
  int terminalFrom;
  int terminalTo;
  int status;

  factory CrimpingResponse.fromJson(Map<String, dynamic> json) => CrimpingResponse(
        bundleIdentification: json["bundleIdentification"],
        bundleQuantity: json["bundleQuantity"],
        passedQuantity: json["passedQuantity"],
        rejectedQuantity: json["rejectedQuantity"],
        crimpInslation: json["crimpInslation"],
        insulationSlug: json["insulationSlug"],
        windowGap: json["windowGap"],
        exposedStrands: json["exposedStrands"],
        burrOrCutOff: json["burrOrCutOff"],
        terminalBendOrClosedOrDamage: json["terminalBendORClosedORDamage"],
        nickMarkOrStrandsCut: json["nickMarkOrStrandsCut"],
        seamOpen: json["seamOpen"],
        missCrimp: json["missCrimp"],
        frontBellMouth: json["frontBellMouth"],
        backBellMouth: json["backBellMouth"],
        extrusionOnBurr: json["extrusionOnBurr"],
        brushLength: json["brushLength"],
        cableDamage: json["cableDamage"],
        terminalTwist: json["terminalTwist"],
        orderId: json["orderId"],
        fgPart: json["fgPart"],
        scheduleId: json["scheduleId"],
        binId: json["binId"],
        processType: json["processType"],
        method: json["method"],
        machineIdentification: json["machineIdentification"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        color: json["color"],
        finishedGoods: json["finishedGoods"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "bundleIdentification": bundleIdentification,
        "bundleQuantity": bundleQuantity,
        "passedQuantity": passedQuantity,
        "rejectedQuantity": rejectedQuantity,
        "crimpInslation": crimpInslation,
        "insulationSlug": insulationSlug,
        "windowGap": windowGap,
        "exposedStrands": exposedStrands,
        "burrOrCutOff": burrOrCutOff,
        "terminalBendORClosedORDamage": terminalBendOrClosedOrDamage,
        "nickMarkOrStrandsCut": nickMarkOrStrandsCut,
        "seamOpen": seamOpen,
        "missCrimp": missCrimp,
        "frontBellMouth": frontBellMouth,
        "backBellMouth": backBellMouth,
        "extrusionOnBurr": extrusionOnBurr,
        "brushLength": brushLength,
        "cableDamage": cableDamage,
        "terminalTwist": terminalTwist,
        "orderId": orderId,
        "fgPart": fgPart,
        "scheduleId": scheduleId,
        "binId": binId,
        "processType": processType,
        "method": method,
        "machineIdentification": machineIdentification,
        "cablePartNumber": cablePartNumber,
        "cutLength": cutLength,
        "color": color,
        "finishedGoods": finishedGoods,
        "terminalFrom": terminalFrom,
        "terminalTo": terminalTo,
        "status": status,
      };
}
