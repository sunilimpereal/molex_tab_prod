import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  String? get baseIp => _sharedPref!.getString("baseIp") ?? "";
  List<String>? get ipList => _sharedPref!.getStringList("ipList");
  //setters
  setipList(List<String> list) {
    _sharedPref!.setStringList("ipList", list);
  }

  setbaseip({required String baseip}) {
    _sharedPref!.setString("baseIp", baseip);
  }

  DateTime? get startDate => DateTime.parse( _sharedPref!.getString("startDate") ?? "${DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 5)))}");
  DateTime? get endDate => DateTime.parse( _sharedPref!.getString("endDate") ?? "${DateUtils.dateOnly(DateTime.now().add(const Duration(days: 3)))}");

  setStartandEndDate({required DateTime startDate, required DateTime endDate}) {
    log("message1 staert :$startDate");
    log("message1 endDate :$endDate");
    _sharedPref!.setString("startDate", startDate.toString());
    _sharedPref!.setString("endDate", endDate.toString());
  }
}

final sharedPrefs = SharedPref();
