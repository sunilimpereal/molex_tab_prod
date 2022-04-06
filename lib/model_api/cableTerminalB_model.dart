// To parse this JSON data, do
//
//     final getCableTerminalB = getCableTerminalBFromJson(jsonString);

import 'dart:convert';

GetCableTerminalB getCableTerminalBFromJson(String str) => GetCableTerminalB.fromJson(json.decode(str));

String getCableTerminalBToJson(GetCableTerminalB data) => json.encode(data.toJson());

class GetCableTerminalB {
    GetCableTerminalB({
        required this.status,
        required this.statusMsg,
        required this.errorCode,
        required this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetCableTerminalB.fromJson(Map<String, dynamic> json) => GetCableTerminalB(
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
       required this.findCableTerminalBDto,
    });

    List<CableTerminalB> findCableTerminalBDto;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        findCableTerminalBDto: List<CableTerminalB>.from(json["findCableTerminalBDto "].map((x) => CableTerminalB.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "findCableTerminalBDto ": List<dynamic>.from(findCableTerminalBDto.map((x) => x.toJson())),
    };
}

class CableTerminalB {
    CableTerminalB({
      required  this.fronStripLengthSpec,
      required  this.processType,
      required  this.terminalPart,
      required  this.specCrimpLength,
      required  this.pullforce,
      required  this.comment,
      required  this.unsheathingLength,
      required  this.crimpFrom,
      required  this.crimpTo,
      required  this.crimpColor,
      required  this.wireCuttingSortingNumber,
      required  this.stripLength,
    });

    String fronStripLengthSpec;
    String processType;
    int terminalPart;
    String specCrimpLength;
    dynamic pullforce;
    String comment;
    String unsheathingLength;
    String crimpFrom;
    String crimpTo;
    String crimpColor;
    int wireCuttingSortingNumber;
    String stripLength;

    factory CableTerminalB.fromJson(Map<String, dynamic> json) => CableTerminalB(
        fronStripLengthSpec: json["fronStripLengthSpec"].toString().replaceAll("Â±", "±"),
        processType: json["processType"].toString().replaceAll("Â±", "±"),
        terminalPart: json["terminalPart"],
        specCrimpLength: json["specCrimpLength"].toString().replaceAll("Â±", "±"),
        pullforce: json["pullforce"],
        comment: json["comment"].toString().replaceAll("Â±", "±"),
        unsheathingLength: json["unsheathingLength"].toString().replaceAll("Â±", "±"),
        crimpFrom: json["crimpFrom"],
        crimpTo: json["crimpTo"],
        crimpColor: json["crimpColor"],
        wireCuttingSortingNumber: json["wireCuttingSortingNumber"],
        stripLength: json["stripLength"].toString().replaceAll("Â±", "±"),
    );

    Map<String, dynamic> toJson() => {
        "fronStripLengthSpec": fronStripLengthSpec,
        "processType": processType,
        "terminalPart": terminalPart,
        "specCrimpLength": specCrimpLength,
        "pullforce": pullforce,
        "comment": comment,
        "unsheathingLength": unsheathingLength,
        "crimpFrom": crimpFrom,
        "crimpTo": crimpTo,
        "crimpColor": crimpColor,
        "wireCuttingSortingNumber": wireCuttingSortingNumber,
        "stripLength": stripLength,
    };
}
