// To parse this JSON data, do
//
//     final getCableDetail = getCableDetailFromJson(jsonString);

import 'dart:convert';

GetCableDetail getCableDetailFromJson(String str) => GetCableDetail.fromJson(json.decode(str));

String getCableDetailToJson(GetCableDetail data) => json.encode(data.toJson());

class GetCableDetail {
    GetCableDetail({
      required  this.status,
      required  this.statusMsg,
      required  this.errorCode,
      required  this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetCableDetail.fromJson(Map<String, dynamic> json) => GetCableDetail(
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
       required this.findCableDetails,
    });

    List<CableDetails> findCableDetails;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        findCableDetails: List<CableDetails>.from(json["findCableDetails "].map((x) => CableDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "findCableDetails ": List<dynamic>.from(findCableDetails.map((x) => x.toJson())),
    };
}

class CableDetails {
    CableDetails({
       required this.cutLengthSpec,
       required this.cablePartNumber,
       required this.description,
       required this.stripLengthFrom,
       required this.stripLengthTo,
       required this.crimpFrom,
       required this.crimpTo,
       required this.crimpColor,
       required this.wireCuttingSortingNumber,
    });

    int cutLengthSpec;
    int cablePartNumber;
    String description;
    String stripLengthFrom;
    String stripLengthTo;
    String crimpFrom;
    String crimpTo;
    String crimpColor;
    int wireCuttingSortingNumber;

    factory CableDetails.fromJson(Map<String, dynamic> json) => CableDetails(
        cutLengthSpec: json["cutLengthSpec"],
        cablePartNumber: json["cablePartNumber"],
        description: json["description"].toString().replaceAll("Â±", "±"),
        stripLengthFrom: json["stripLengthFrom"].toString().replaceAll("Â±", "±"),
        stripLengthTo: json["stripLengthTo"].toString().replaceAll("Â±", "±"),
        crimpFrom: json["crimpFrom"],
        crimpTo: json["crimpTo"],
        crimpColor: json["crimpColor"],
        wireCuttingSortingNumber: json["wireCuttingSortingNumber"],
    );

    Map<String, dynamic> toJson() => {
        "cutLengthSpec": cutLengthSpec,
        "cablePartNumber": cablePartNumber,
        "description": description,
        "stripLengthFrom": stripLengthFrom,
        "stripLengthTo": stripLengthTo,
        "crimpFrom": crimpFrom,
        "crimpTo": crimpTo,
        "crimpColor": crimpColor,
        "wireCuttingSortingNumber": wireCuttingSortingNumber,
    };
}
