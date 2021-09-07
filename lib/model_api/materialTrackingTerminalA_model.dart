// To parse this JSON data, do
//
//     final getMaterialTrackingTerminalA = getMaterialTrackingTerminalAFromJson(jsonString);

import 'dart:convert';

GetMaterialTrackingTerminalA getMaterialTrackingTerminalAFromJson(String str) => GetMaterialTrackingTerminalA.fromJson(json.decode(str));

String getMaterialTrackingTerminalAToJson(GetMaterialTrackingTerminalA data) => json.encode(data.toJson());

class GetMaterialTrackingTerminalA {
    GetMaterialTrackingTerminalA({
       required this.status,
       required this.statusMsg,
       required this.errorCode,
       required this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetMaterialTrackingTerminalA.fromJson(Map<String, dynamic> json) => GetMaterialTrackingTerminalA(
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
      required this.materialTrackingTerminalA,
    });

    List<MaterialTrackingTerminalA> materialTrackingTerminalA;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        materialTrackingTerminalA: List<MaterialTrackingTerminalA>.from(json[" Material Tracking Terminal A "].map((x) => MaterialTrackingTerminalA.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        " Material Tracking Terminal A ": List<dynamic>.from(materialTrackingTerminalA.map((x) => x.toJson())),
    };
}

class MaterialTrackingTerminalA {
    MaterialTrackingTerminalA({
       required this.partNumber,
       required this.uom,
       required this.required,
       required this.loaded,
       required this.available,
       required this.pending,
    });

    int partNumber;
    String uom;
    int required;
    int loaded;
    int available;
    int pending;

    factory MaterialTrackingTerminalA.fromJson(Map<String, dynamic> json) => MaterialTrackingTerminalA(
        partNumber: json["partNumber"],
        uom: json["uom"],
        required: json["required"],
        loaded: json["loaded"],
        available: json["available"],
        pending: json["pending"],
    );

    Map<String, dynamic> toJson() => {
        "partNumber": partNumber,
        "uom": uom,
        "required": required,
        "loaded": loaded,
        "available": available,
        "pending": pending,
    };
}
