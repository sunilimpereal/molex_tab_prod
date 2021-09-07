// To parse this JSON data, do
//
//     final postPreparationDetail = postPreparationDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PostPreparationDetail postPreparationDetailFromJson(String str) =>
    PostPreparationDetail.fromJson(json.decode(str));

String postPreparationDetailToJson(PostPreparationDetail data) =>
    json.encode(data.toJson());

class PostPreparationDetail {
  PostPreparationDetail({
    required this.bundleIdentification,
    required this.bundleQuantity,
    required this.passedQuantity,
    required this.rejectedQuantity,
    this.crimpInslation,
    this.insulationSlug,
    this.windowGap,
    this.exposedStrands,
    this.burrOrCutOff,
    this.terminalBendOrClosedOrDamage,
    this.nickMarkOrStrandsCut,
    this.seamOpen,
    this.missCrimp,
    this.frontBellMouth,
    this.backBellMouth,
    this.extrusionOnBurr,
    this.brushLength,
    this.cableDamage,
    this.terminalTwist,
    this.orderId,
    this.fgPart,
    this.scheduleId,
    this.binId,
    required this.processType,
    required this.method,
    required this.status,
    required this.machineIdentification,
    required this.cablePartNumber,
    required this.cutLength,
    required this.color,
    required this.finishedGoods,
    required this.awg,
    required this.terminalFrom,
    required this.terminalTo,
    this.cvmRejectionsCable,
    this.cvmRejectionsCableTerminalTo,
    this.cvmRejectionsCableTerminalFrom,
    this.cfmRejectionsCable,
    this.cfmRejectionsCableTerminalTo,
    this.cfmRejectionsCableTerminalFrom,
    this.endWire,
    this.rejectionsTerminalTo,
    this.rejectionsTerminalFrom,
    this.lengthVariation,
    this.stringLengthVariation,
    this.nickMark,
    this.bellMouthError,
    this.brushLengthLessMore,
    this.wrongTerminal,
    this.wrongCable,
    this.wrongCutLength,
    this.extrusionBurr,
    required this.crimpFromSchId,
    required this.crimpToSchId,
    required this.preparationCompleteFlag,
    required this.viCompleted,
  });

  String bundleIdentification;
  int? bundleQuantity;
  int? passedQuantity;
  int? rejectedQuantity;
  int? crimpInslation;
  int? insulationSlug;
  int? windowGap;
  int? exposedStrands;
  int? burrOrCutOff;
  int? terminalBendOrClosedOrDamage;
  int? nickMarkOrStrandsCut;
  int? seamOpen;
  int? missCrimp;
  int? frontBellMouth;
  int? backBellMouth;
  int? extrusionOnBurr;
  int? brushLength;
  int? cableDamage;
  int? terminalTwist;
  int? orderId;
  int? fgPart;
  int? scheduleId;
  String? binId;
  String method;
  String status;
  String machineIdentification;
  int cablePartNumber;
  int cutLength;
  String color;
  int finishedGoods;
  String awg;
  int terminalFrom;
  int terminalTo;
  int? cvmRejectionsCable;
  int? cvmRejectionsCableTerminalTo;
  int? cvmRejectionsCableTerminalFrom;
  int? cfmRejectionsCable;
  int ?cfmRejectionsCableTerminalTo;
  int ?cfmRejectionsCableTerminalFrom;
  int ?endWire;
  int ?rejectionsTerminalTo;
  int ?rejectionsTerminalFrom;
  int ?lengthVariation;
  int ?stringLengthVariation;
  int ?nickMark;
  int ?bellMouthError;
  int ?brushLengthLessMore;
  int ?wrongTerminal;
  int ?wrongCable;
  int ?wrongCutLength;
  int ?extrusionBurr;
  String crimpFromSchId;
  String crimpToSchId;
  String preparationCompleteFlag;
  String viCompleted;
  String processType;

  factory PostPreparationDetail.fromJson(Map<String, dynamic> json) =>
      PostPreparationDetail(
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
        status: json["Status"],
        machineIdentification: json["machineIdentification"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        color: json["color"],
        finishedGoods: json["finishedGoods"],
        awg: json["awg"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        cvmRejectionsCable: json["cvmRejectionsCable"],
        cvmRejectionsCableTerminalTo: json["cvmRejectionsCableTerminalTo"],
        cvmRejectionsCableTerminalFrom: json["cvmRejectionsCableTerminalFrom"],
        cfmRejectionsCable: json["cfmRejectionsCable"],
        cfmRejectionsCableTerminalTo: json["cfmRejectionsCableTerminalTo"],
        cfmRejectionsCableTerminalFrom: json["cfmRejectionsCableTerminalFrom"],
        endWire: json["endWire"],
        rejectionsTerminalTo: json["rejectionsTerminalTo"],
        rejectionsTerminalFrom: json["rejectionsTerminalFrom"],
        lengthVariation: json["lengthVariation"],
        stringLengthVariation: json["stringLengthVariation"],
        nickMark: json["nickMark"],
        bellMouthError: json["bellMouthError"],
        brushLengthLessMore: json["brushLengthLessMore"],
        wrongTerminal: json["wrongTerminal"],
        wrongCable: json["wrongCable"],
        wrongCutLength: json["wrongCutLength"],
        extrusionBurr: json["extrusionBurr"],
        crimpFromSchId: json["crimpFromSchId"],
        crimpToSchId: json["crimpToSchId"],
        preparationCompleteFlag: json["preparationCompleteFlag"],
        viCompleted: json["viCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "bundleIdentification": bundleIdentification ?? 0,
        "bundleQuantity": bundleQuantity ?? 0,
        "passedQuantity": passedQuantity ?? 0,
        "rejectedQuantity": rejectedQuantity ?? 0,
        "crimpInslation": crimpInslation ?? 0,
        "insulationSlug": insulationSlug ?? 0,
        "windowGap": windowGap ?? 0,
        "exposedStrands": exposedStrands ?? 0,
        "burrOrCutOff": burrOrCutOff ?? 0,
        "terminalBendORClosedORDamage": terminalBendOrClosedOrDamage ?? 0,
        "nickMarkOrStrandsCut": nickMarkOrStrandsCut ?? 0,
        "seamOpen": seamOpen ?? 0,
        "missCrimp": missCrimp ?? 0,
        "frontBellMouth": frontBellMouth ?? 0,
        "backBellMouth": backBellMouth ?? 0,
        "extrusionOnBurr": extrusionOnBurr ?? 0,
        "brushLength": brushLength ?? 0,
        "cableDamage": cableDamage ?? 0,
        "terminalTwist": terminalTwist ?? 0,
        "orderId": orderId ?? 0,
        "fgPart": fgPart ?? 0,
        "scheduleId": scheduleId ?? 0,
        "binId": binId ?? 0,
        "processType": processType ?? 0,
        "method": method ?? 0,
        "Status": status ?? 0,
        "machineIdentification": machineIdentification ?? 0,
        "cablePartNumber": cablePartNumber ?? 0,
        "cutLength": cutLength ?? 0,
        "color": color ?? 0,
        "finishedGoods": finishedGoods ?? 0,
        "awg": awg ?? 0,
        "terminalFrom": terminalFrom ?? 0,
        "terminalTo": terminalTo ?? 0,
        "cvmRejectionsCable": cvmRejectionsCable ?? 0,
        "cvmRejectionsCableTerminalTo": cvmRejectionsCableTerminalTo ?? 0,
        "cvmRejectionsCableTerminalFrom": cvmRejectionsCableTerminalFrom ?? 0,
        "cfmRejectionsCable": cfmRejectionsCable ?? 0,
        "cfmRejectionsCableTerminalTo": cfmRejectionsCableTerminalTo ?? 0,
        "cfmRejectionsCableTerminalFrom": cfmRejectionsCableTerminalFrom ?? 0,
        "endWire": endWire ?? 0,
        "rejectionsTerminalTo": rejectionsTerminalTo ?? 0,
        "rejectionsTerminalFrom": rejectionsTerminalFrom ?? 0,
        "lengthVariation": lengthVariation ?? 0,
        "stringLengthVariation": stringLengthVariation ?? 0,
        "nickMark": nickMark ?? 0,
        "bellMouthError": bellMouthError ?? 0,
        "brushLengthLessMore": brushLengthLessMore ?? 0,
        "wrongTerminal": wrongTerminal ?? 0,
        "wrongCable": wrongCable ?? 0,
        "wrongCutLength": wrongCutLength ?? 0,
        "extrusionBurr": extrusionBurr ?? 0,
        "crimpFromSchId": crimpFromSchId ?? "",
        "crimpToSchId": crimpToSchId ?? '',
        "preparationCompleteFlag": preparationCompleteFlag ?? '0',
        "viCompleted": viCompleted ?? '0',
      };
}
