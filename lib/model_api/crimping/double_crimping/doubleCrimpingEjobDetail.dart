// To parse this JSON data, do
//
//     final dcEjobDetail = dcEjobDetailFromJson(jsonString);

import 'dart:convert';

DcEjobDetail dcEjobDetailFromJson(String str) => DcEjobDetail.fromJson(json.decode(str));

String dcEjobDetailToJson(DcEjobDetail data) => json.encode(data.toJson());

class DcEjobDetail {
  DcEjobDetail({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory DcEjobDetail.fromJson(Map<String, dynamic> json) => DcEjobDetail(
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
    required this.eJobTicketMasterDetails,
  });

  List<EJobTicketMasterDetails> eJobTicketMasterDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        eJobTicketMasterDetails: List<EJobTicketMasterDetails>.from(
            json["EJobTicketMaster Details  "].map((x) => EJobTicketMasterDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EJobTicketMaster Details  ":
            List<dynamic>.from(eJobTicketMasterDetails.map((x) => x.toJson())),
      };
}

class EJobTicketMasterDetails {
  EJobTicketMasterDetails({
    required this.combPartNumberAndMachine,
    required this.id,
    required this.combPartNumberAndWireSortNumber,
    required this.comboPartNumberAndCrimpSortNumber,
    required this.fgPartNumber,
    required this.molexDrgRev,
    required this.customerPartNumber,
    required this.customerName,
    required this.manualMachineWc,
    required this.unsheathingLengthFrom,
    required this.crimpHeightFrom,
    required this.pullForceFrom,
    required this.stripLengthFrom,
    required this.terminalPartNumberFrom,
    required this.fromName,
    required this.from,
    required this.typeOfCrimpFrom,
    required this.typeOfCrimpTo,
    required this.to,
    required this.toName,
    required this.terminalPartNumberTo,
    required this.stripLengthTo,
    required this.crimpHeightTo,
    required this.pullForceTo,
    required this.unsheathingLengthTo,
    required this.cablePartNumber,
    required this.description,
    required this.cableType,
    required this.awg,
    required this.crimpColor,
    required this.wireCuttingColor,
    required this.length,
    required this.lengthTolerance,
    required this.cableNumber,
    required this.wireCuttingSortingNumber,
    required this.crimpingSortingNumber,
    required this.wireCuttingRemarks,
    required this.fromCrimpingRemarks,
    required this.toCrimpingRemarks,
    required this.quantityOrPiece,
    required this.route,
  });

  int id;
  String combPartNumberAndMachine;
  int combPartNumberAndWireSortNumber;
  int comboPartNumberAndCrimpSortNumber;
  int fgPartNumber;
  String molexDrgRev;
  String customerPartNumber;
  String customerName;
  String manualMachineWc;
  String unsheathingLengthFrom;
  String crimpHeightFrom;
  double pullForceFrom;
  String stripLengthFrom;
  int terminalPartNumberFrom;
  String fromName;
  String from;
  String typeOfCrimpFrom;
  String typeOfCrimpTo;
  String to;
  String toName;
  int terminalPartNumberTo;
  String stripLengthTo;
  String crimpHeightTo;
  double pullForceTo;
  String unsheathingLengthTo;
  int cablePartNumber;
  String description;
  String cableType;
  int awg;
  String crimpColor;
  String wireCuttingColor;
  int length;
  String lengthTolerance;
  String cableNumber;
  int wireCuttingSortingNumber;
  int crimpingSortingNumber;
  String wireCuttingRemarks;
  String fromCrimpingRemarks;
  String toCrimpingRemarks;
  int quantityOrPiece;
  String route;

  factory EJobTicketMasterDetails.fromJson(Map<String, dynamic> json) => EJobTicketMasterDetails(
        id: json["id"],
        combPartNumberAndMachine: json["combPartNumberAndMachine"],
        combPartNumberAndWireSortNumber: json["combPartNumberAndWireSortNumber"],
        comboPartNumberAndCrimpSortNumber: json["comboPartNumberAndCrimpSortNumber"],
        fgPartNumber: json["fgPartNumber"],
        molexDrgRev: json["molexDrgRev"],
        customerPartNumber: json["customerPartNumber"],
        customerName: json["customerName"],
        manualMachineWc: json["manualMachineWC"],
        unsheathingLengthFrom: json["unsheathingLengthFrom"],
        crimpHeightFrom: json["crimpHeightFrom"],
        pullForceFrom: json["pullForceFrom"],
        stripLengthFrom: json["stripLengthFrom"],
        terminalPartNumberFrom: json["terminalPartNumberFrom"],
        fromName: json["fromName"],
        from: json["from"],
        typeOfCrimpFrom: json["typeOfCrimpFrom"],
        typeOfCrimpTo: json["typeOfCrimpTo"],
        to: json["to"],
        toName: json["toName"],
        terminalPartNumberTo: json["terminalPartNumberTo"],
        stripLengthTo: json["stripLengthTo"],
        crimpHeightTo: json["crimpHeightTo"],
        pullForceTo: json["pullForceTo"],
        unsheathingLengthTo: json["unsheathingLengthTo"],
        cablePartNumber: json["cablePartNumber"],
        description: json["description"],
        cableType: json["cableType"],
        awg: json["awg"],
        crimpColor: json["crimpColor"],
        wireCuttingColor: json["wireCuttingColor"],
        length: json["length"],
        lengthTolerance: json["lengthTolerance"],
        cableNumber: json["cableNumber"].toString(),
        wireCuttingSortingNumber: json["wireCuttingSortingNumber"],
        crimpingSortingNumber: json["crimpingSortingNumber"],
        wireCuttingRemarks: json["wireCuttingRemarks"],
        fromCrimpingRemarks: json["fromCrimpingRemarks"],
        toCrimpingRemarks: json["toCrimpingRemarks"],
        quantityOrPiece: json["quantityOrPiece"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "combPartNumberAndMachine": combPartNumberAndMachine,
        "combPartNumberAndWireSortNumber": combPartNumberAndWireSortNumber,
        "comboPartNumberAndCrimpSortNumber": comboPartNumberAndCrimpSortNumber,
        "fgPartNumber": fgPartNumber,
        "molexDrgRev": molexDrgRev,
        "customerPartNumber": customerPartNumber,
        "customerName": customerName,
        "manualMachineWC": manualMachineWc,
        "unsheathingLengthFrom": unsheathingLengthFrom,
        "crimpHeightFrom": crimpHeightFrom,
        "pullForceFrom": pullForceFrom,
        "stripLengthFrom": stripLengthFrom,
        "terminalPartNumberFrom": terminalPartNumberFrom,
        "fromName": fromName,
        "from": from,
        "typeOfCrimpFrom": typeOfCrimpFrom,
        "typeOfCrimpTo": typeOfCrimpTo,
        "to": to,
        "toName": toName,
        "terminalPartNumberTo": terminalPartNumberTo,
        "stripLengthTo": stripLengthTo,
        "crimpHeightTo": crimpHeightTo,
        "pullForceTo": pullForceTo,
        "unsheathingLengthTo": unsheathingLengthTo,
        "cablePartNumber": cablePartNumber,
        "description": description,
        "cableType": cableType,
        "awg": awg,
        "crimpColor": crimpColor,
        "wireCuttingColor": wireCuttingColor,
        "length": length,
        "lengthTolerance": lengthTolerance,
        "cableNumber": cableNumber,
        "wireCuttingSortingNumber": wireCuttingSortingNumber,
        "crimpingSortingNumber": crimpingSortingNumber,
        "wireCuttingRemarks": wireCuttingRemarks,
        "fromCrimpingRemarks": fromCrimpingRemarks,
        "toCrimpingRemarks": toCrimpingRemarks,
        "quantityOrPiece": quantityOrPiece,
        "route": route,
      };
}
