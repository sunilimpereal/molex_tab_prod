// To parse this JSON data, do
//
//     final getFgDetails = getFgDetailsFromJson(jsonString);

import 'dart:convert';

GetFgDetails getFgDetailsFromJson(String str) => GetFgDetails.fromJson(json.decode(str));

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
  String? customer;
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
// [{"fgPartNumber":367690267,"orderId":"12345","cablePartNumber":"100007801","cableType":"","length":142,"wireCuttingColor":"BK","average":0,"customerName":"","routeMaster":"","scheduledQty":0,"actualQty":0,"binId":"889900","binLocation":"LOKIT1A1","bundleId":["3142534"],"bundleQty":100,"SuggetedScheduledQty":100,"suggestedActualQty":100,"SuggestedBinLocation":"LOKIT1A1","suggestedBundleId":"889900","suggestedBundleQty":100,"status":"Active","userId":"0000A4280"},{"fgPartNumber":367690267,"orderId":"12345","cablePartNumber":"100007803","cableType":"","length":142,"wireCuttingColor":"RD","average":0,"customerName":"","routeMaster":"","scheduledQty":0,"actualQty":0,"binId":"10872","binLocation":"LOKIT2H19","bundleId":["2142782"],"bundleQty":2000,"SuggetedScheduledQty":2000,"suggestedActualQty":2000,"SuggestedBinLocation":"LOKIT2H19","suggestedBundleId":"10872","suggestedBundleQty":2000,"status":"Active","userId":"0000A4280"},{"fgPartNumber":367690267,"orderId":"12345","cablePartNumber":"100007805","cableType":"","length":142,"wireCuttingColor":"YL","average":0,"customerName":"","routeMaster":"","scheduledQty":0,"actualQty":0,"binId":"10872","binLocation":"LOKIT2H19","bundleId":["2145657"],"bundleQty":500,"SuggetedScheduledQty":500,"suggestedActualQty":500,"SuggestedBinLocation":"LOKIT2H19","suggestedBundleId":"10872","suggestedBundleQty":500,"status":"Active","userId":"0000A4280"},{"fgPartNumber":367690267,"orderId":"12345","cablePartNumber":"100007807","cableType":"","length":142,"wireCuttingColor":"BL","average":0,"customerName":"","routeMaster":"","scheduledQty":0,"actualQty":0,"binId":"12591","binLocation":"LOKIT4U16","bundleId":["2152646"],"bundleQty":400,"SuggetedScheduledQty":400,"suggestedActualQty":400,"SuggestedBinLocation":"LOKIT4U16","suggestedBundleId":"12591","suggestedBundleQty":400,"status":"Active","userId":"0000A4280"}]