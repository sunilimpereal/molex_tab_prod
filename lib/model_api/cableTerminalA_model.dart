// To parse this JSON data, do
//
//     final getCableTerminalA = getCableTerminalAFromJson(jsonString);

import 'dart:convert';

GetCableTerminalA getCableTerminalAFromJson(String str) =>
    GetCableTerminalA.fromJson(json.decode(str));

String getCableTerminalAToJson(GetCableTerminalA data) => json.encode(data.toJson());

class GetCableTerminalA {
  GetCableTerminalA({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory GetCableTerminalA.fromJson(Map<String, dynamic> json) => GetCableTerminalA(
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
    required this.findCableTerminalADto,
  });

  List<CableTerminalA> findCableTerminalADto;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        findCableTerminalADto: List<CableTerminalA>.from(
            json["findCableTerminalADto "].map((x) => CableTerminalA.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "findCableTerminalADto ": List<dynamic>.from(findCableTerminalADto.map((x) => x.toJson())),
      };
}

class CableTerminalA {
  CableTerminalA({
    required this.fronStripLengthSpec,
    required this.processType,
    required this.terminalPart,
    required this.specCrimpLength,
    required this.pullforce,
    required this.comment,
    required this.unsheathingLength,
    required this.crimpFrom,
    required this.crimpTo,
    required this.crimpColor,
    required this.wireCuttingSortingNumber,
    required this.stripLength,
  });

  String fronStripLengthSpec;
  String processType;
  int terminalPart;
  String specCrimpLength;
  double pullforce;
  String comment;
  String unsheathingLength;
  String crimpFrom;
  String crimpTo;
  String crimpColor;
  int wireCuttingSortingNumber;
  String stripLength;

  factory CableTerminalA.fromJson(Map<String, dynamic> json) => CableTerminalA(
        fronStripLengthSpec: json["fronStripLengthSpec"].toString().replaceAll("Â±", "±"),
        processType: json["processType"].toString().replaceAll("Â±", "±"),
        terminalPart: json["terminalPart"],
        specCrimpLength: json["specCrimpLength"].toString().replaceAll("Â±", "±"),
        pullforce: json["pullforce"]?.toDouble(),
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



//     factory CableTerminalA.fromJson(Map<String, dynamic> json) => CableTerminalA(
//         fronStripLengthSpec: json["fronStripLengthSpec"]?.toString()?.replaceAll("Â±", "±"),
//         processType: json["processType"]?.toString()?.replaceAll("Â±", "±"),
//         terminalPart: json["terminalPart"],
//         specCrimpLength: json["specCrimpLength"]?.toString()?.replaceAll("Â±", "±"),
//         pullforce: json["pullforce"]?.toDouble(),
//         comment: json["comment"]?.toString()?.replaceAll("Â±", "±"),
//         unsheathingLength: json["unsheathingLength"]?.toString()?.replaceAll("Â±", "±"),
//         stripLength: json["stripLength"]?.toString()?.replaceAll("Â±", "±"),
//     );

//     Map<String, dynamic> toJson() => {
//         "fronStripLengthSpec": fronStripLengthSpec,
//         "processType": processType,
//         "terminalPart": terminalPart,
//         "specCrimpLength": specCrimpLength,
//         "pullforce": pullforce,
//         "comment": comment,
//         "unsheathingLength": unsheathingLength,
//         "stripLength": stripLength,
//     };
// }
