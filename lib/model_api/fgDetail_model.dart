// To parse this JSON data, do
//
//     final getFgDetails = getFgDetailsFromJson(jsonString);

import 'dart:convert';

GetFgDetails getFgDetailsFromJson(String str) =>
    GetFgDetails.fromJson(json.decode(str));

String getFgDetailsToJson(GetFgDetails data) => json.encode(data.toJson());

class GetFgDetails {
  GetFgDetails({
   required this.status,
   required this.statusMsg,
   required this.errorCode,
   required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory GetFgDetails.fromJson(Map<String, dynamic> json) => GetFgDetails(
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
   required this.getFgDetaials,
  });

  FgDetails getFgDetaials;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        getFgDetaials: FgDetails.fromJson(json["get FG Detaials "]),
      );

  Map<String, dynamic> toJson() => {
        "get FG Detaials ": getFgDetaials.toJson(),
      };
}

class FgDetails {
  FgDetails({
    this.fgDescription,
    this.fgScheduleDate,
    this.customer,
    this.drgRev,
    this.cableSerialNo,
    this.tolrance,
  });

  String? fgDescription;
  dynamic fgScheduleDate;
  String ?customer;
  String? drgRev;
  int? cableSerialNo;
  String? tolrance;

  factory FgDetails.fromJson(Map<String, dynamic> json) => FgDetails(
        fgDescription: json["fgDescription"],
        fgScheduleDate: json["fgScheduleDate"],
        customer: json["customer"],
        drgRev: json["drgRev"],
        cableSerialNo: json["cableSerialNo"],
        tolrance: json["tolrance"].toString().replaceAll("Â±", "±"),
      );

  Map<String, dynamic> toJson() => {
        "fgDescription": fgDescription,
        "fgScheduleDate": fgScheduleDate,
        "customer": customer,
        "drgRev": drgRev,
        "cableSerialNo": cableSerialNo,
        "tolrance": tolrance,
      };
}
