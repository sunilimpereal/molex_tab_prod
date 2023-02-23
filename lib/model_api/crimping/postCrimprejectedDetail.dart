// To parse this JSON data??0, do
//
//     final postCrimpingRejectedDetail = postCrimpingRejectedDetailFromJson(jsonString);

import 'dart:convert';

List<PostCrimpingRejectedDetail> postCrimpingRejectedDetailFromJsonList(
        String str) =>
    List<PostCrimpingRejectedDetail>.from(
        json.decode(str).map((x) => PostCrimpingRejectedDetail.fromJson(x)));

String postCrimpingRejectedDetailToJsonList(
        List<PostCrimpingRejectedDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

PostCrimpingRejectedDetail postCrimpingRejectedDetailFromJson(String str) =>
    PostCrimpingRejectedDetail.fromJson(json.decode(str));

String postCrimpingRejectedDetailToJson(PostCrimpingRejectedDetail data) =>
    json.encode(data.toJson());

class PostCrimpingRejectedDetail {
  PostCrimpingRejectedDetail({
    this.bundleIdentification,
    this.bundleQuantity,
    this.passedQuantity,
    this.rejectedQuantity,
    this.crimpInslation,
    this.insulationSlug,
    this.windowGap,
    this.exposedStrands,
    this.burrOrCutOff,
    this.terminalBendOrClosedOrDamage,
    this.nickMarkOrStrandsCut,
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
    this.processType,
    this.method,
    this.status,
    this.machineIdentification,
    this.cablePartNumber,
    this.cutLength,
    this.color,
    this.finishedGoods,
    this.terminalFrom,
    this.terminalTo,
    this.awg,
    this.setUpRejections,
    this.setUpRejectionTerminalFrom,
    this.setUpRejectionTerminalTo,
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
    this.seamOpen,
    this.wrongCutLength,
    this.missCrimp,
    this.extrusionBurr,
    this.crimpFromSchId,
    this.crimpToSchId,
    this.preparationCompleteFlag,
    this.viCompleted,
    this.halfCurling,
    this.lockingTapOpenClose,
    this.terminalDamage,
  });

  String? bundleIdentification;
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
  String? method;
  String? status;
  String? machineIdentification;
  int? cablePartNumber;
  int? cutLength;
  String? color;
  int? finishedGoods;
  int? terminalFrom;
  int? terminalTo;
  String? awg;
  int? setUpRejections;
  int? setUpRejectionTerminalFrom;
  int? setUpRejectionTerminalTo;
  int? cvmRejectionsCable;
  int? cvmRejectionsCableTerminalTo;
  int? cvmRejectionsCableTerminalFrom;
  int? cfmRejectionsCable;
  int? cfmRejectionsCableTerminalTo;
  int? cfmRejectionsCableTerminalFrom;
  int? endWire;
  int? rejectionsTerminalTo;
  int? rejectionsTerminalFrom;
  int? lengthVariation;
  int? stringLengthVariation;
  int? nickMark;
  int? bellMouthError;
  int? brushLengthLessMore;
  int? wrongTerminal;
  int? wrongCable;
  int? seamOpen;
  int? wrongCutLength;
  int? missCrimp;
  int? extrusionBurr;
  String? crimpFromSchId;
  String? crimpToSchId;
  String? preparationCompleteFlag;
  String? viCompleted;
  String? processType;
  int? lockingTapOpenClose;
  int? halfCurling;
  int? terminalDamage;

  factory PostCrimpingRejectedDetail.fromJson(Map<String, dynamic> json) =>
      PostCrimpingRejectedDetail(
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
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        awg: json["awg"],
        setUpRejections: json["setUpRejections"], // cable
        setUpRejectionTerminalFrom: json["setUpRejectionTerminalFrom"],
        setUpRejectionTerminalTo: json["setUpRejectionTerminalTo"],
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
        seamOpen: json["seamOpen"],
        wrongCutLength: json["wrongCutLength"],
        missCrimp: json["missCrimp"],
        extrusionBurr: json["extrusionBurr"],
        crimpFromSchId: json["crimpFromSchId"],
        crimpToSchId: json["crimpToSchId"],
        preparationCompleteFlag: json["preparationCompleteFlag"],
        viCompleted: json["viCompleted"],
        lockingTapOpenClose: json["lockingTapOpenClose"],
        halfCurling: json["halfCurling"],
        terminalDamage: json["terminalDamage"],
      );

  Map<String, dynamic> toJson() => {
        "bundleIdentification": bundleIdentification ?? '',
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
        "frontBellMouth": frontBellMouth ?? 0,
        "backBellMouth": backBellMouth ?? 0,
        "extrusionOnBurr": extrusionOnBurr ?? 0,
        "brushLength": brushLength ?? 0,
        "cableDamage": cableDamage ?? 0,
        "terminalTwist": terminalTwist ?? 0,
        "orderId": orderId ?? 0,
        "fgPart": fgPart ?? 0,
        "scheduleId": scheduleId ?? 0,
        "binId": binId ?? '',
        "processType": processType ?? '',
        "method": method ?? '',
        "Status": status ?? '',
        "machineIdentification": machineIdentification ?? '',
        "cablePartNumber": cablePartNumber ?? 0,
        "cutLength": cutLength ?? 0,
        "color": color ?? '',
        "finishedGoods": finishedGoods ?? 0,
        "terminalFrom": terminalFrom ?? 0,
        "terminalTo": terminalTo ?? 0,
        "awg": awg ?? '',
        // "setUpRejection": setUpRejections ?? 0,
        "setUpRejectionCable": setUpRejections ?? 0,
        "setUpRejectionTerminalFrom": setUpRejectionTerminalFrom ?? 0,
        "setUpRejectionTerminalTo": setUpRejectionTerminalTo ?? 0,
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
        "seamOpen": seamOpen ?? 0,
        "wrongCutLength": wrongCutLength ?? 0,
        "missCrimp": missCrimp ?? 0,
        "extrusionBurr": extrusionBurr ?? 0,
        "crimpFromSchId": crimpFromSchId ?? "",
        "crimpToSchId": crimpToSchId ?? '',
        "preparationCompleteFlag": preparationCompleteFlag ?? '0',
        "viCompleted": viCompleted ?? '0',
        "lockingTapOpenClose": lockingTapOpenClose,
        "halfCurling": halfCurling,
        "terminalDamage": terminalDamage,
      };
}
