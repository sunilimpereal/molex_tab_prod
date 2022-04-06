import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProcessTimer extends StatefulWidget {
  DateTime startTime;
  String endTime;
  ProcessTimer({Key? key, required this.startTime, required this.endTime}) : super(key: key);

  @override
  Process_TimerState createState() => Process_TimerState();
}

class Process_TimerState extends State<ProcessTimer> {
  late DateTime startTime;
  late DateTime endTime;
  bool timer = true;
  Duration timeRemaining = Duration(seconds: 30);
  bool properFormat = true;
  updateTime() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        print(timer.tick);
        timeRemaining = endTime.difference(DateTime.now());
        log("time1 : $timeRemaining.");
      });
    });
  }

  @override
  void initState() {
    try {
      log("rad" + widget.endTime);
      startTime = DateTime.now();
      log("rad" + widget.endTime.substring(3, 5));
      endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          int.parse(widget.endTime.substring(0, 2)), int.parse(widget.endTime.substring(3, 5)));
      widget.startTime = DateTime.now();
      timeRemaining = endTime.difference(DateTime.now());
      timer ? updateTime() : null;
    } catch (e) {
      setState(() {
        properFormat = false;
      });
    }

    super.initState();
  }

  // "14:45:00"
  @override
  void dispose() {
    setState(() {
      timer = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: !properFormat
                ? Colors.red
                : timeRemaining.toString().contains("-")
                    ? Colors.red
                    : Colors.green,
          )),
      child: Container(
        padding: EdgeInsets.all(4),
        // color: Colors.red,
        width: MediaQuery.of(context).size.width * 0.088,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !properFormat
                ? Container(
                    child: Center(
                      child: Text("Invalid Time Format"),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      startTimeWidget(),
                      timeLeft(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget startTimeWidget() {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Start Time",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.blue,
              ),
              SizedBox(
                width: 4,
              ),
              Text("${DateFormat('hh:mm').format(widget.startTime)}",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget timeLeft() {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Time Left",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.timer_rounded,
                size: 14,
                color: timeRemaining.toString().contains("-") ? Colors.red : Colors.green,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "${timeRemaining.toString().contains("-") ? timeRemaining.toString().substring(0, 5) : timeRemaining.toString().substring(0, 4)}",
                // "${timeRemaining.inHours}:${(timeRemaining.inMinutes % 60)}",
                style: TextStyle(
                  color: timeRemaining.toString().contains("-") ? Colors.red : Colors.green,
                  fontSize: 18,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
