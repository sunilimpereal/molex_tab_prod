// To parse this JSON data, do
//
//     final getViSchedule = getViScheduleFromJson(jsonString);

import 'dart:convert';

GetViSchedule getViScheduleFromJson(String str) => GetViSchedule.fromJson(json.decode(str));

String getViScheduleToJson(GetViSchedule data) => json.encode(data.toJson());

class GetViSchedule {
    GetViSchedule({
        required this.status,
        required this.statusMsg,
       required this.errorCode,
        required this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetViSchedule.fromJson(Map<String, dynamic> json) => GetViSchedule(
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
        required this.viScheduler,
    });

    List<ViScheduler> viScheduler;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        viScheduler: List<ViScheduler>.from(json[" Visual Inspection Scheduler "].map((x) => ViScheduler.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        " Visual Inspection Scheduler ": List<dynamic>.from(viScheduler.map((x) => x.toJson())),
    };
}

class ViScheduler {
    ViScheduler({
       required this.orderId,
       required this.fgNo,
       required this.scheduleId,
       required this.scheduleType,
       required this.binId,
       required this.totalBundles,
       required this.binLocationId,
    });

    String orderId;
    String fgNo;
    String scheduleId;
    String scheduleType;
    String binId;
    String totalBundles;
    String binLocationId;

    factory ViScheduler.fromJson(Map<String, dynamic> json) => ViScheduler(
        orderId: json["orderId"]??'',
        fgNo: json["fgNo"]??'',
        scheduleId: json["scheduleId"]??'',
        scheduleType: json["scheduleType"]??'',
        binId: json["binId"]??'',
        totalBundles: json["totalBundles"]??'',
        binLocationId: json["binLocationId"]??'',
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "fgNo": fgNo,
        "scheduleId": scheduleId,
        "scheduleType": scheduleType,
        "binId": binId,
        "totalBundles": totalBundles,
        "binLocationId": binLocationId,
    };
}

