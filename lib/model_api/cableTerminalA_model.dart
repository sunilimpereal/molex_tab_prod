// To parse this JSON data, do
//
//     final getCableTerminalA = getCableTerminalAFromJson(jsonString);

import 'dart:convert';

GetCableTerminalA getCableTerminalAFromJson(String str) => GetCableTerminalA.fromJson(json.decode(str));

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
      required  this.findCableTerminalADto,
    });

    CableTerminalA findCableTerminalADto;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        findCableTerminalADto: CableTerminalA.fromJson(json["findCableTerminalADto "]),
    );

    Map<String, dynamic> toJson() => {
        "findCableTerminalADto ": findCableTerminalADto.toJson(),
    };
}

class CableTerminalA {
    CableTerminalA({
        this.fronStripLengthSpec,
        this.processType,
        this.terminalPart,
        this.specCrimpLength,
        this.pullforce,
        this.comment,
        this.unsheathingLength,
        this.stripLength,
    });

    String? fronStripLengthSpec;
    String? processType;
    int ?terminalPart;
    String? specCrimpLength;
    double? pullforce;
    String? comment;
    String? unsheathingLength;
    String? stripLength;

    factory CableTerminalA.fromJson(Map<String, dynamic> json) => CableTerminalA(
        fronStripLengthSpec: json["fronStripLengthSpec"]?.toString()?.replaceAll("Â±", "±"),
        processType: json["processType"]?.toString()?.replaceAll("Â±", "±"),
        terminalPart: json["terminalPart"],
        specCrimpLength: json["specCrimpLength"]?.toString()?.replaceAll("Â±", "±"),
        pullforce: json["pullforce"]?.toDouble(),
        comment: json["comment"]?.toString()?.replaceAll("Â±", "±"),
        unsheathingLength: json["unsheathingLength"]?.toString()?.replaceAll("Â±", "±"),
        stripLength: json["stripLength"]?.toString()?.replaceAll("Â±", "±"),
    );

    Map<String, dynamic> toJson() => {
        "fronStripLengthSpec": fronStripLengthSpec,
        "processType": processType,
        "terminalPart": terminalPart,
        "specCrimpLength": specCrimpLength,
        "pullforce": pullforce,
        "comment": comment,
        "unsheathingLength": unsheathingLength,
        "stripLength": stripLength,
    };
}
