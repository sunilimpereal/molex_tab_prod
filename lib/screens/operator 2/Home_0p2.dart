import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:molex/screens/operator%202/widgets/crimpig_schedule_data_row.dart';
import '../../model_api/crimping/getCrimpingSchedule.dart';
import '../../model_api/login_model.dart';
import '../../model_api/machinedetails_model.dart';
import '../../model_api/schedular_model.dart';
import '../../model_api/startProcess_model.dart';
import '../operator%202/materialPick2.dart';
import '../operator/materialPick.dart';
import '../utils/colorLoader.dart';
import '../widgets/drawer.dart';
import '../widgets/switchButton.dart';
import '../widgets/time.dart';
import '../../service/apiService.dart';

class HomePageOp2 extends StatefulWidget {
  final Employee employee;
  final MachineDetails machine;
  HomePageOp2({this.employee, this.machine});
  @override
  _HomePageOp2State createState() => _HomePageOp2State();
}

class _HomePageOp2State extends State<HomePageOp2> {
  int type = 0;
  ApiService apiService;
  int scheduleType = 0;

  var _chosenValue = "Order Id";
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        backwardsCompatibility: false,
        title: Text(
          'Crimping',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        elevation: 0,
        actions: [
          //typeselect
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3),
            child: Row(
              children: [
                SwitchButton(
                  options: ['Auto', "Manual"],
                  onToggle: (index) {
                    print('switched to: $index');
                    type = index;

                    setState(() {
                      _searchController.clear();
                      type = index;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                SwitchButton(
                  options: [' Same MC ', ' Other MC '],
                  onToggle: (index) {
                    print('switched to: $index');
                    scheduleType = index;
                    setState(() {
                      _searchController.clear();
                      scheduleType = index;
                    });
                  },
                ),
                // Container(
                //   height: 25,
                //   decoration: BoxDecoration(
                //     color: Colors.red[500],
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     border: Border.all(color: Colors.red[500]),
                //   ),
                //   child: ToggleSwitch(
                //     minWidth: 75.0,
                //     cornerRadius: 5.0,
                //     activeBgColor: Colors.red[500],
                //     activeFgColor: Colors.white,
                //     initialLabelIndex: scheduleType,
                //     inactiveBgColor: Colors.white,
                //     inactiveFgColor: Colors.red,
                //     labels: ['Same MC', 'Other MC'],
                //     fontSize: 12,
                //     onToggle: (index) {
                //       print('switched to: $index');
                //       scheduleType = index;
                //       setState(() {
                //         scheduleType = index;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          //shift
          //shift
          SizedBox(width: 10),
          //machine Id
          Container(
            padding: EdgeInsets.all(1),
            // width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            widget.employee.empId,
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          )
                        ],
                      )),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.settings,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            widget.machine.machineNumber ?? "",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          )
                        ],
                      )),
                    ),
                  ],
                )
              ],
            ),
          ),

          TimeDisplay(),
        ],
      ),
      drawer: Drawer(
        child: DrawerWidget(
            employee: widget.employee,
            machineDetails: widget.machine,
            type: "process"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.redAccent,
              thickness: 2,
            ),
            search(),
            SchudleTable(
              employee: widget.employee,
              machine: widget.machine,
              type: type == 0 ? "A" : "M",
              scheduleType: scheduleType == 0 ? "true" : "false",
              searchType: _chosenValue,
              query: _searchController.text ?? "",
            ),
          ],
        ),
      ),
    );
  }

  Widget search() {
    if (type == 1) {
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SizedBox(width: 10),
            dropdown(
                options: ["Order Id", "FG Part No.", "Cable Part No"],
                name: "Order Id"),
            SizedBox(width: 10),
            Container(
              height: 38,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.red[400],
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 180,
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(fontSize: 16),
                        onTap: () {},
                        decoration: new InputDecoration(
                          hintText: _chosenValue,
                          hintStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 13, top: 11, right: 0),
                          fillColor: Colors.white,
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget dropdown({List<String> options, String name}) {
    return Container(
        child: DropdownButton<String>(
      focusColor: Colors.white,
      value: _chosenValue,
      underline: Container(),
      isDense: false,
      isExpanded: false,
      style: TextStyle(color: Colors.white),
      iconEnabledColor: Colors.redAccent,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      onChanged: (String value) {
        setState(() {
          _chosenValue = value;
        });
      },
    ));
  }
}

class SchudleTable extends StatefulWidget {
  final Schedule schedule;
  final Employee employee;
  final MachineDetails machine;
  String scheduleType;
  String type;
  String searchType;
  String query;
  SchudleTable(
      {Key key,
      this.schedule,
      this.employee,
      this.machine,
      this.scheduleType,
      this.type,
      this.searchType,
      this.query})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<DataRow> datarows = [];
  ApiService apiService;
  List<CrimpingSchedule> crimpingSchedule;
  PostStartProcessP1 postStartprocess;
  @override
  void initState() {
    apiService = new ApiService();

    super.initState();
  }

  List<CrimpingSchedule> searchfilter(List<CrimpingSchedule> scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList
            .where((element) =>
                element.purchaseOrder.toString().startsWith(widget.query))
            .toList();
        break;
      case "FG Part No.":
        return scheduleList
            .where((element) =>
                element.finishedGoods.toString().startsWith(widget.query))
            .toList();
        break;
      case "Cable Part No":
        return scheduleList
            .where((element) =>
                element.cablePartNo.toString().startsWith(widget.query))
            .toList();
        break;
      default:
        return scheduleList;
    }
  }

  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 3), () {
      completer.complete();
      setState(() {});
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          tableHeading(),
          SingleChildScrollView(
            child: Container(
                height: widget.type == "M" ? 430 : 490,
                // height: double.parse("${rowList.length*60}"),
                child: FutureBuilder(
                  future: apiService.getCrimpingSchedule(
                      scheduleType: "${widget.type}",
                      machineNo: widget.machine.machineNumber,
                      sameMachine: "${widget.scheduleType}"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CrimpingSchedule> schedulelist =
                          searchfilter(snapshot.data);
                      schedulelist = schedulelist
                          .where((element) =>
                              element.schedulestatus.toLowerCase() !=
                              "Complete".toLowerCase())
                          .toList();
                           
                      log("aaa ${schedulelist}");

                      if (schedulelist.length > 0) {
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: schedulelist.length,
                              itemBuilder: (context, index) {
                                return  CrimpingScheduleDataRow(schedule: schedulelist[index], machine: widget.machine, employee: widget.employee);
                              }),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(108.0),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  'No Schedule Found',
                                  style: TextStyle(color: Colors.black),
                                )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              side: BorderSide(
                                                  color: Colors.transparent))),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.green[200];
                                          return Colors.red[
                                              400]; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Refresh  ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.replay_outlined,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return CircularProgressIndicator();
                      }

                      return Padding(
                        padding: const EdgeInsets.all(108.0),
                        child: Center(
                          child: Container(
                              child: Text(
                            'No Schedule Found',
                            style: TextStyle(color: Colors.black),
                          )),
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget tableHeading() {
    Widget cell(String name, double width) {
      return Container(
        width: MediaQuery.of(context).size.width * width,
        height: 40,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: TextStyle(
                    // color: Color(0xffBF3947),
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 4,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order ID", 0.065),
                  cell("FG Part", 0.065),
                  cell("Schedule ID", 0.065),
                  cell("  Cable Part \n  No.", 0.065),
                  cell("Process", 0.10),
                  cell("Cut Length\n(mm)", 0.06),
                  cell("Color", 0.05),
                  cell("AWG", 0.030),
                  cell("Total \nBundles", 0.05),
                  cell("Total \nBundle Qty", 0.07),
                  // cell("Schedule\n Qty", 0.07),
                  cell("Actual/Schedule\n Qty", 0.085),
                  cell("Shift", 0.07),
                  cell("Time", 0.085),
                  cell("Action", 0.1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataRow({CrimpingSchedule schedule, int c}) {
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

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 1,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: c % 2 == 0 ? Colors.grey[50] : Colors.white,
          child: Container(
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell('${schedule.purchaseOrder}', 0.065),
                //Fg Part
                cell('${schedule.finishedGoods}', 0.065),
                //Schudule ID
                cell('${schedule.scheduleId}', 0.065),
                //Cable Part
                cell('${schedule.cablePartNo}', 0.065),
                //Process
                cell('${schedule.process}', 0.10),

                // Cut length
                cell('${schedule.length}', 0.06),
                //Color2
                cell('${schedule.wireColour}', 0.05),
                //Bin Id
                cell('${schedule.awg}', 0.03),
                // Total bundles
                cell("${schedule.bundleIdentificationCount}", 0.05),
                //Total Bundle Qty
                cell("${schedule.bundleQuantityTotal}", 0.07),
                cell("${schedule.actualQuantity}/${schedule.schdeuleQuantity}",
                    0.085),
                Container(
                  width: MediaQuery.of(context).size.width * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${schedule.shiftType}",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "No : ${schedule.shiftNumber}",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                // cell("${schedule.actualQuantity}", 0.07),
                Container(
                  width: MediaQuery.of(context).size.width * 0.085,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            schedule.scheduleDate == null
                                ? ""
                                : DateFormat("dd-MM-yyyy")
                                    .format(schedule.scheduleDate),
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
                            "${schedule.shiftStart.length > 2 ? schedule.shiftStart.substring(0, 5) : schedule.shiftStart}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            " - ${schedule.shiftEnd.length > 2 ? schedule.shiftEnd.substring(0, 5) : schedule.shiftEnd}",
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
                // cell("${schedule.scheduledStatus}", 0.09),
                //Action
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 45,
                  child: schedule.schedulestatus.toLowerCase() ==
                          "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CrimpingStartButton(
                                style: ElevatedButton.styleFrom(
                                  primary: schedule.schedulestatus
                                              .toLowerCase() ==
                                          "Partially Completed".toLowerCase()
                                      ? Colors.green[500]
                                      : Colors.green[500],
                                ),
                                child: Container(
                                    child: schedule.schedulestatus
                                                    .toLowerCase() ==
                                                "Allocated".toLowerCase() ||
                                            schedule.schedulestatus
                                                    .toLowerCase() ==
                                                "Open".toLowerCase() ||
                                            schedule.schedulestatus == null
                                        ? Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : schedule.schedulestatus
                                                        .toLowerCase() ==
                                                    "Pending".toLowerCase() ||
                                                schedule.schedulestatus
                                                        .toLowerCase() ==
                                                    "Partially Completed"
                                                        .toLowerCase() ||
                                                schedule.schedulestatus
                                                        .toLowerCase() ==
                                                    "Started".toLowerCase()
                                            ? Text(
                                                'Continue',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text('')),
                                onPressed: () async {
                                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                                  postStartprocess = new PostStartProcessP1(
                                    cablePartNumber:
                                        "${schedule.cablePartNo ?? "0"}",
                                    color: schedule.wireColour,
                                    finishedGoodsNumber:
                                        "${schedule.finishedGoods ?? "0"}",
                                    lengthSpecificationInmm:
                                        "${schedule.length ?? "0"}",
                                    machineIdentification:
                                        widget.machine.machineNumber,
                                    orderIdentification:
                                        "${schedule.purchaseOrder ?? "0"}",
                                    scheduledIdentification:
                                        "${schedule.scheduleId ?? "0"}",
                                    scheduledQuantity:
                                        schedule.schdeuleQuantity ?? "0",
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
                                                MaterialPickOp2(
                                                  schedule: schedule,
                                                  employee: widget.employee,
                                                  machine: widget.machine,
                                                  materialPickType:
                                                      MaterialPickType.newload,
                                                )),
                                      );
                                      return true;
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Unable to Start Process",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      return true;
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
}

class CrimpingStartButton extends StatefulWidget {
  Function onPressed;
  Widget child;
  ButtonStyle style;
  CrimpingStartButton({this.onPressed, this.child, this.style}) : super();

  @override
  _CrimpingStartButtonState createState() => _CrimpingStartButtonState();
}

class _CrimpingStartButtonState extends State<CrimpingStartButton> {
  bool loading = false;
  @override
  void initState() {
    loading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: widget.style,
        onPressed: loading
            ? () {}
            : () async {
                setState(() {
                  loading = true;
                });
                bool a = true;
                try{
                 a = await widget.onPressed();
                }catch(e){
                  setState(() {
                    loading = false;
                  });
                }
                if (a) {
                  setState(() {
                    loading = false;
                  });
                }
                Future.delayed(Duration(seconds: 4)).then((value) {
                  setState(() {
                    loading = false;
                  });
                });
              },
        child: loading ? CircularProgressIndicator() : widget.child);
  }
}
