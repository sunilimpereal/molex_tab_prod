import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:molex/model_api/login_model.dart';
import 'package:molex/model_api/machinedetails_model.dart';
import 'package:molex/model_api/process1/100Complete_model.dart';
import 'package:molex/model_api/schedular_model.dart';
import 'package:molex/model_api/startProcess_model.dart';
import 'package:molex/screens/utils/loadingButton.dart';
import 'package:molex/service/apiService.dart';

import '../../../main.dart';
import '../materialPick.dart';

class ScheduleDataRow extends StatefulWidget {
  Schedule schedule;
  MachineDetails machine;
  Employee employee;
  Function onrefresh;
  ScheduleDataRow({required this.schedule, required this.machine, required this.employee, required this.onrefresh})
      : super();

  @override
  _ScheduleDataRowState createState() => _ScheduleDataRowState();
}

class _ScheduleDataRowState extends State<ScheduleDataRow> {
  late ApiService apiService;
  late bool loading;
  @override
  void initState() {
    apiService = new ApiService();
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 1,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          color: 2 % 2 == 0 ? Colors.white : Colors.grey.shade50,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                color: widget.schedule.scheduledStatus.toLowerCase() ==
                        "Complete".toLowerCase()
                    ? Colors.green
                    : widget.schedule.scheduledStatus.toLowerCase() ==
                            "Partially".toLowerCase()
                        ? Colors.orange.shade100
                        : Colors.blue.shade100,
                width: 5,
              )),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell(widget.schedule.orderId, 0.07),
                //Fg Part
                cell(widget.schedule.finishedGoodsNumber, 0.07),

                //Schudule ID
                Tooltip(
                    showDuration: const Duration(seconds: 2),
                    waitDuration: const Duration(seconds: 1),
                    message: "${widget.schedule.machineNumber}",
                    child: cell(widget.schedule.scheduledId, 0.07)),
                //Cable Part
                cell(widget.schedule.cablePartNumber, 0.08),

                //Process
                cell(widget.schedule.process, 0.12),
                // Cut length
                cell(widget.schedule.length, 0.060),
                //Color
                cell(widget.schedule.color, 0.05),
                //Scheduled Qty
                cell(widget.schedule.scheduledQuantity, 0.065),
                cell(widget.schedule.actualQuantity.toString(), 0.05),
                cell(widget.schedule.awg.toString(), 0.035),
                Container(
                  width: MediaQuery.of(context).size.width * 0.073,
                  height: 34,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No:",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.schedule.shiftNumber}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Text(
                          "${widget.schedule.shiftType}",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                // cell("${widget.schedule.shiftType}", 0.074),
                Container(
                  width: MediaQuery.of(context).size.width * 0.085,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.schedule.currentDate == null
                                ? ""
                                : DateFormat("dd-MM-yyyy")
                                    .format(widget.schedule.currentDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.schedule.shiftStart.length > 2 ? widget.schedule.shiftStart.substring(0, 5) : widget.schedule.shiftStart}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            " - ${widget.schedule.shiftEnd.length > 2 ? widget.schedule.shiftEnd.substring(0, 5) : widget.schedule.shiftEnd}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Status
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: widget.schedule.scheduledStatus.toLowerCase() ==
                          "Partially Completed".toLowerCase()
                      ? 45
                      : 30,
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                widget.schedule.scheduledStatus.toLowerCase() ==
                                        'Complete'.toLowerCase()
                                    ? Colors.green.shade100
                                    : widget.schedule.scheduledStatus
                                                .toLowerCase() ==
                                            "Partially Completed".toLowerCase()
                                        ? Colors.red.shade50
                                        : Colors.blue.shade50,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4),
                              child: Text(
                                widget.schedule.scheduledStatus,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: widget.schedule.scheduledStatus
                                              .toLowerCase() ==
                                          'Complete'.toLowerCase()
                                      ? Colors.green
                                      : widget.schedule.scheduledStatus
                                                  .toLowerCase() ==
                                              "Partially Completed"
                                                  .toLowerCase()
                                          ? Colors.red.shade400
                                          : Colors.blue[900],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.07,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.07 *
                                    ((widget.schedule.actualQuantity /
                                        int.parse(
                                            widget.schedule.scheduledQuantity ??
                                                '1'))),
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: 45,
                  child: widget.schedule.scheduledStatus.toLowerCase() ==
                          "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: LoadingButton(
                                  loading: loading,
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.all(0)),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => widget
                                                  .schedule.scheduledStatus
                                                  .toLowerCase() ==
                                              "Partially Completed"
                                                  .toLowerCase()
                                          ? Colors.green.shade500
                                          : Colors.green.shade500,
                                    ),
                                  ),
                                  loadingChild: Container(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                        child: widget.schedule.scheduledStatus
                                                        .toLowerCase() ==
                                                    "Allocated".toLowerCase() ||
                                                widget.schedule.scheduledStatus
                                                        .toLowerCase() ==
                                                    "Open".toLowerCase() ||
                                                widget.schedule.scheduledStatus
                                                        .toLowerCase() ==
                                                    "".toLowerCase() ||
                                                widget.schedule.scheduledStatus ==
                                                    null
                                            ? Text(
                                                "Accept",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : widget
                                                            .schedule.scheduledStatus
                                                            .toLowerCase() ==
                                                        "Pending"
                                                            .toLowerCase() ||
                                                    widget.schedule
                                                            .scheduledStatus
                                                            .toLowerCase() ==
                                                        "Partially Completed"
                                                            .toLowerCase() ||
                                                    widget.schedule
                                                            .scheduledStatus
                                                            .toLowerCase() ==
                                                        "started".toLowerCase()
                                                ? Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : Text('')),
                                  ),
                                  onPressed: loading
                                      ? () {}
                                      : () async {
                                          if (widget.schedule.shiftType ==
                                              "Allocated") {
                                            // After [onPressed], it will trigger animation running backwards, from end to beginning
                                            PostStartProcessP1
                                                postStartprocess =
                                                new PostStartProcessP1(
                                              cablePartNumber: widget.schedule
                                                      .cablePartNumber ??
                                                  "0",
                                              color: widget.schedule.color,
                                              finishedGoodsNumber: widget
                                                      .schedule
                                                      .finishedGoodsNumber ??
                                                  "0",
                                              lengthSpecificationInmm:
                                                  widget.schedule.length ?? "0",
                                              machineIdentification:
                                                  widget.machine.machineNumber,
                                              orderIdentification:
                                                  widget.schedule.orderId ??
                                                      "0",
                                              scheduledIdentification:
                                                  widget.schedule.scheduledId ??
                                                      "0",
                                              scheduledQuantity: widget.schedule
                                                      .scheduledQuantity ??
                                                  "0",
                                              scheduleStatus: "started",
                                            );
                                            Fluttertoast.showToast(
                                                msg: "Loading",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            apiService
                                                .startProcess1(postStartprocess)
                                                .then((value) {
                                              if (value) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MaterialPick(
                                                            schedule:
                                                                widget.schedule,
                                                            employee:
                                                                widget.employee,
                                                            machine:
                                                                widget.machine,
                                                            materialPickType:
                                                                MaterialPickType
                                                                    .newload, homeReload: (){}, reload: (){},
                                                          )),
                                                ).then((value) {
                                                  widget.onrefresh();
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Unable to Start Process",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                setState(() {
                                                  loading = false;
                                                });
                                              }
                                              return true;
                                            });
                                          } else {
                                            showScheduleDetail(
                                                    schedule: widget.schedule)
                                                .then((value) {
                                              setState(() {});
                                            });
                                          }
                                        }),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cell(String name, double width) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: 34,
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> showScheduleDetail({required Schedule schedule}) {
    Widget feild({required String heading, required String value, required double width}) {
      width = MediaQuery.of(context).size.width * width;
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          // color: Colors.red.shade100,
          width: width,
          child: Column(
            children: [
              Row(
                children: [
                  Text(heading,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Row(
                  children: [
                    Text(
                      value ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context1) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            title: Container(
                height: 380,
                width: 550,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: 550,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Order Id",
                                  value: widget.schedule.orderId,
                                  width: 0.14),
                              feild(
                                  heading: "FG Part",
                                  value:
                                      "${widget.schedule.finishedGoodsNumber}",
                                  width: 0.14),
                              feild(
                                  heading: "Schedule ID",
                                  value: "${widget.schedule.scheduledId}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Cable Part No.",
                                  value: "${widget.schedule.cablePartNumber}",
                                  width: 0.14),
                              feild(
                                  heading: "Process",
                                  value: "${widget.schedule.process}",
                                  width: 0.14),
                              feild(
                                  heading: "cable#",
                                  value: "${widget.schedule.cableNumber}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Cut Length",
                                  value: "${widget.schedule.length}",
                                  width: 0.14),
                              feild(
                                  heading: "Color",
                                  value: "${widget.schedule.color}",
                                  width: 0.14),
                              feild(
                                  heading: "Scheduled Qty",
                                  value: "${widget.schedule.scheduledQuantity}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Date",
                                  value: widget.schedule.currentDate == null
                                      ? ""
                                      : DateFormat("dd-MM-yyyy")
                                          .format(widget.schedule.currentDate),
                                  width: 0.14),
                              feild(
                                  heading: "Shift Type",
                                  value: "${widget.schedule.shiftType}",
                                  width: 0.14),
                              feild(heading: "", width: 0.14, value: '')
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.green))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green.shade200;
                                    return Colors.green.shade500
                                        ; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green.shade200;
                                    return Colors.green.shade500
                                        ; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                PostStartProcessP1 postStartprocess =
                                    new PostStartProcessP1(
                                  cablePartNumber:
                                      widget.schedule.cablePartNumber ?? "0",
                                  color: widget.schedule.color,
                                  finishedGoodsNumber:
                                      widget.schedule.finishedGoodsNumber ??
                                          "0",
                                  lengthSpecificationInmm:
                                      widget.schedule.length ?? "0",
                                  machineIdentification:
                                      widget.machine.machineNumber,
                                  orderIdentification:
                                      widget.schedule.orderId ?? "0",
                                  scheduledIdentification:
                                      widget.schedule.scheduledId ?? "0",
                                  scheduledQuantity:
                                      widget.schedule.scheduledQuantity ?? "0",
                                  scheduleStatus: "complete",
                                );
                                FullyCompleteModel fullyComplete =
                                    FullyCompleteModel(
                                        finishedGoodsNumber: int.parse(widget
                                            .schedule.finishedGoodsNumber),
                                        purchaseOrder:
                                            int.parse(widget.schedule.orderId),
                                        orderId:
                                            int.parse(widget.schedule.orderId),
                                        cablePartNumber: int.parse(
                                            widget.schedule.cablePartNumber),
                                        length:
                                            int.parse(widget.schedule.length),
                                        color: widget.schedule.color,
                                        scheduledStatus: "Complete",
                                        scheduledId: int.parse(
                                            widget.schedule.scheduledId),
                                        scheduledQuantity: int.parse(
                                            widget.schedule.scheduledQuantity),
                                        machineIdentification:
                                            widget.machine.machineNumber??"",
                                        //TODO bundle ID
                                        firstPieceAndPatrol: 0,
                                        applicatorChangeover: 0, bundleIdentification: '');
                                apiService
                                    .post100Complete(fullyComplete)
                                    .then((value) {
                                  if (value) {
                                    Navigator.pop(context1);

                                    Fluttertoast.showToast(
                                      msg: "Schedule Completed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Schedule not Completed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                              },
                              child: Text('Complete')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.green))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green.shade200;
                                    return Colors.green.shade500
                                        ; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green.shade200;
                                    return Colors.green.shade500
                                        ; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context1);
                                PostStartProcessP1 postStartprocess =
                                    new PostStartProcessP1(
                                  cablePartNumber:
                                      widget.schedule.cablePartNumber ?? "0",
                                  color: widget.schedule.color,
                                  finishedGoodsNumber:
                                      widget.schedule.finishedGoodsNumber ??
                                          "0",
                                  lengthSpecificationInmm:
                                      widget.schedule.length ?? "0",
                                  machineIdentification:
                                      widget.machine.machineNumber,
                                  orderIdentification:
                                      widget.schedule.orderId ?? "0",
                                  scheduledIdentification:
                                      widget.schedule.scheduledId ?? "0",
                                  scheduledQuantity:
                                      widget.schedule.scheduledQuantity ?? "0",
                                  scheduleStatus: "started",
                                );
                                Fluttertoast.showToast(
                                    msg: "Loading",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                apiService.startProcess1(postStartprocess).then(
                                  (value) {
                                    if (value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MaterialPick(
                                                  schedule: widget.schedule,
                                                  employee: widget.employee,
                                                  machine: widget.machine,
                                                  homeReload: widget.onrefresh,
                                                  materialPickType:
                                                      MaterialPickType.newload, reload: (){},
                                                )),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Unable to Start Process",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                );
                              },
                              child: Text(
                                "Start Process",
                                style: TextStyle(
                                  fontFamily: fonts.openSans,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }
}
