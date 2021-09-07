// To parse this JSON data, do
//
//     final getCableTerminalB = getCableTerminalBFromJson(jsonString);

import 'dart:convert';

GetCableTerminalB getCableTerminalBFromJson(String str) => GetCableTerminalB.fromJson(json.decode(str));

String getCableTerminalBToJson(GetCableTerminalB data) => json.encode(data.toJson());

class GetCableTerminalB {
    GetCableTerminalB({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String? status;
    String? statusMsg;
    dynamic errorCode;
    Data? data;

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
        "data": data!.toJson(),
    };
}

class Data {
    Data({
      required this.findCableTerminalBDto,
    });

    CableTerminalB findCableTerminalBDto;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        findCableTerminalBDto: CableTerminalB.fromJson(json["findCableTerminalBDto "]),
    );

    Map<String, dynamic> toJson() => {
        "findCableTerminalBDto ": findCableTerminalBDto.toJson(),
    };
}

class CableTerminalB{
    CableTerminalB({
        this.fronStripLengthSpec,
        this.processType,
        this.terminalPart,
        this.specCrimpLength,
        this.pullforce,
        this.comment,
        this.unsheathingLength,
        this.stripLength,
    });

    String ?fronStripLengthSpec;
    String ?processType;
    int ?terminalPart;
    String ?specCrimpLength;
    double? pullforce;
    String? comment;
    String? unsheathingLength;
    String? stripLength;

    factory CableTerminalB.fromJson(Map<String, dynamic> json) => CableTerminalB(
        fronStripLengthSpec: json["fronStripLengthSpec"]?.toString()?.replaceAll("Â±", "±"),
        processType: json["processType"].toString().replaceAll("Â±", "±"),
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
