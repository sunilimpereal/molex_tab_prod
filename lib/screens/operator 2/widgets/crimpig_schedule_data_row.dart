import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:molex/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex/model_api/login_model.dart';
import 'package:molex/model_api/machinedetails_model.dart';
import 'package:molex/model_api/startProcess_model.dart';
import 'package:molex/screens/operator/materialPick.dart';
import 'package:molex/service/apiService.dart';

import '../materialPick2.dart';

class CrimpingScheduleDataRow extends StatefulWidget {
  CrimpingSchedule schedule;
  Employee employee;
  MachineDetails machine;
  //variables for schedule type
  String type;
  String sameMachine;
  List<CrimpingSchedule> extraCrimpingSchedules;
  CrimpingScheduleDataRow({
    required this.schedule,
    required this.machine,
    required this.employee,
    required this.sameMachine,
    required this.type,
    required this.extraCrimpingSchedules,
  }) : super();

  @override
  _CrimpingScheduleDataRowState createState() => _CrimpingScheduleDataRowState();
}

class _CrimpingScheduleDataRowState extends State<CrimpingScheduleDataRow> {
  late ApiService apiService;
  bool loading = false;
  @override
  void initState() {
    loading = false;
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 1,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: 2 % 2 == 0 ? Colors.grey.shade50 : Colors.white,
          child: Container(
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell('${widget.schedule.purchaseOrder}', 0.065),
                //Fg Part
                cell('${widget.schedule.finishedGoods}', 0.068),
                //Schudule ID
                Tooltip(
                    showDuration: const Duration(seconds: 2),
                    waitDuration: const Duration(seconds: 1),
                    message: "${widget.machine.machineNumber}",
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: 34,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.schedule.scheduleId.toString(),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                            // Text(
                            //   widget.schedule ?? '',
                            //   style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
                            // ),
                          ],
                        ),
                      ),
                    )),
                //Cable Part
                cell('${widget.schedule.cablePartNo}', 0.065),
                //Process
                cell('${widget.schedule.process}', 0.10),

                // Cut length
                cell('${widget.schedule.length}', 0.06),
                //Color2
                Container(
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: 34,
                  child: Column(
                    children: [
                      Text(
                        'WC : ${widget.schedule.wireColour}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'CC : ${widget.schedule.crimpColor}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                //Bin Id
                cell('${widget.schedule.awg}', 0.03),
                // Total bundles
                cell("${widget.schedule.bundleIdentificationCount}", 0.05),
                //Total Bundle Qty
                cell("${widget.schedule.bundleQuantityTotal}", 0.07),
                cell(
                    "${widget.schedule.actualQuantity}/${widget.schedule.schdeuleQuantity}", 0.085),
                Container(
                  width: MediaQuery.of(context).size.width * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${widget.schedule.shiftType}",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "No : ${widget.schedule.shiftNumber}",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                // cell("${widget.schedule.actualQuantity}", 0.07),
                Container(
                  width: MediaQuery.of(context).size.width * 0.085,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.schedule.scheduleDate == null
                                ? ""
                                : DateFormat("dd-MM-yyyy").format(widget.schedule.scheduleDate),
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
                // cell("${widget.schedule.scheduledStatus}", 0.09),
                //Action
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 45,
                  child: widget.schedule.schedulestatus.toLowerCase() == "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: widget.schedule.schedulestatus.toLowerCase() ==
                                          "Partially Completed".toLowerCase()
                                      ? Colors.green.shade500
                                      : Colors.green.shade500,
                                ),
                                child: loading
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Container(
                                        child: widget.schedule.schedulestatus.toLowerCase() ==
                                                    "Allocated".toLowerCase() ||
                                                widget.schedule.schedulestatus.toLowerCase() ==
                                                    "Open".toLowerCase() ||
                                                widget.schedule.schedulestatus == null
                                            ? Text(
                                                "Accept",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              )
                                            : widget.schedule.schedulestatus.toLowerCase() ==
                                                        "Pending".toLowerCase() ||
                                                    widget.schedule.schedulestatus.toLowerCase() ==
                                                        "Partially Completed".toLowerCase() ||
                                                    widget.schedule.schedulestatus.toLowerCase() ==
                                                        "Started".toLowerCase()
                                                ? Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),
                                                  )
                                                : Text('')),
                                onPressed: loading
                                    ? () {}
                                    : () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        // After [onPressed], it will trigger animation running backwards, from end to beginning
                                        PostStartProcessP1 postStartprocess =
                                            new PostStartProcessP1(
                                          cablePartNumber: "${widget.schedule.cablePartNo ?? "0"}",
                                          color: widget.schedule.wireColour,
                                          finishedGoodsNumber:
                                              "${widget.schedule.finishedGoods ?? "0"}",
                                          lengthSpecificationInmm:
                                              "${widget.schedule.length ?? "0"}",
                                          machineIdentification: widget.machine.machineNumber,
                                          orderIdentification:
                                              "${widget.schedule.purchaseOrder ?? "0"}",
                                          scheduledIdentification:
                                              "${widget.schedule.scheduleId ?? "0"}",
                                          scheduledQuantity:
                                              widget.schedule.schdeuleQuantity ?? "0",
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
                                        apiService.startProcess1(postStartprocess).then((value) {
                                          if (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MaterialPickOp2(
                                                      schedule: widget.schedule,
                                                      employee: widget.employee,
                                                      machine: widget.machine,
                                                      materialPickType: MaterialPickType.newload,
                                                      reload: () {},
                                                      type: widget.type,
                                                      sameMachine: widget.sameMachine,
                                                      extraCrimpingSchedules:
                                                          widget.extraCrimpingSchedules)),
                                            );
                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Unable to Start Process",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        });
                                      },
                              ),
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
}
