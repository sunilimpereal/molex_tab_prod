// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
       required this.status,
       required this.statusMsg,
       required this.errorCode,
       required this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
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
       required this.employeeList,
    });

    Employee employeeList;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        employeeList: Employee.fromJson(json["Employee List "]),
    );

    Map<String, dynamic> toJson() => {
        "Employee List ": employeeList.toJson(),
    };
}

class Employee {
    Employee({
       required this.employeeName,
       required this.empId,
       required this.emolyeeType,
       required this.status,
       required this.contractEndDate,
    });

    String employeeName;
    String empId;
    String emolyeeType;
    bool status;
    DateTime contractEndDate;

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeName: json["employeeName"],
        empId: json["empId"],
        emolyeeType: json["emolyeeType"],
        status: json["status"],
        contractEndDate: DateTime.parse(json["contractEndDate"]),
    );

    Map<String, dynamic> toJson() => {
        "employeeName": employeeName,
        "empId": empId,
        "emolyeeType": emolyeeType,
        "status": status,
        "contractEndDate": "${contractEndDate.year.toString().padLeft(4, '0')}-${contractEndDate.month.toString().padLeft(2, '0')}-${contractEndDate.day.toString().padLeft(2, '0')}",
    };
}
