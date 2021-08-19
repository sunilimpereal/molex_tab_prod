// To parse this JSON data, do
//
//     final viInspectedbundle = viInspectedbundleFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

ViInspectedbundle viInspectedbundleFromJson(String str) =>
    ViInspectedbundle.fromJson(json.decode(str));

String viInspectedbundleToJson(ViInspectedbundle data) =>
    json.encode(data.toJson());

class ViInspectedbundle {
  ViInspectedbundle(
      {this.bundleIdentification,
      this.bundleQuantity,
      this.passedQuantity,
      this.rejectedQuantity,
      this.crimpInslation,
      this.insulationSlug,
      this.windowGap,
      this.exposedStrands,
      this.burrOrCutOff,
      this.terminalBendOrClosedOrDamage,
      this.seamOpen,
      this.missCrimp,
      this.frontBellMouth,
      this.backBellMouth,
      this.extrusionOnBurr,
      this.brushLength,
      this.cableDamage,
      this.terminalTwist,
      @required this.orderId,
      @required this.fgPart,
      @required this.scheduleId,
      this.binId,
      @required this.awg,
      @required this.method,
      this.terminalFrom,
      this.terminalTo,
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
      this.employeeid,
      this.locationId,
      this.status,
      @required this.crimpFromSchId,
      @required this.crimpToSchId,
      @required this.preparationCompleteFlag,
      @required this.viCompleted,
      @required this.processType});

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
  int seamOpen;
  int missCrimp;
  int frontBellMouth;
  int backBellMouth;
  int extrusionOnBurr;
  int brushLength;
  int cableDamage;
  int terminalTwist;
  String orderId;
  String fgPart;
  String scheduleId;
  String binId;
  String awg;
  String method;
  int terminalFrom;
  int terminalTo;
  int cvmRejectionsCable;
  int cvmRejectionsCableTerminalTo;
  int cvmRejectionsCableTerminalFrom;
  int cfmRejectionsCable;
  int cfmRejectionsCableTerminalTo;
  int cfmRejectionsCableTerminalFrom;
  int endWire;
  int rejectionsTerminalTo;
  int rejectionsTerminalFrom;
  int lengthVariation;
  int stringLengthVariation;
  int nickMark;
  int bellMouthError;
  int brushLengthLessMore;
  int wrongTerminal;
  int wrongCable;
  int wrongCutLength;
  int extrusionBurr;
  String employeeid;
  String status;
  String locationId;
  String crimpFromSchId;
  String crimpToSchId;
  String preparationCompleteFlag;
  String viCompleted;
  String processType;

  factory ViInspectedbundle.fromJson(Map<String, dynamic> json) =>
      ViInspectedbundle(
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
        awg: json["awg"],
        method: json["method"],
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
        processType: json["processType"],
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
        "awg": awg ?? 0,
        "method": method ?? 0,
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
        "processType": processType ?? '',
      };
}
