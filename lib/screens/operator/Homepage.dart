import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:molex/screens/operator/widgets/filter_dashboard.dart';
import 'package:molex/screens/operator/widgets/schedule_data_row.dart';
import 'package:molex/screens/utils/loadingButton.dart';
import '../../main.dart';
import '../../model_api/login_model.dart';
import '../../model_api/machinedetails_model.dart';
import '../../model_api/process1/100Complete_model.dart';
import '../../model_api/schedular_model.dart';
import '../../model_api/startProcess_model.dart';
import 'materialPick.dart';
import '../utils/colorLoader.dart';
import '../widgets/drawer.dart';
import '../widgets/switchButton.dart';
import '../widgets/time.dart';
import '../../service/apiService.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// Process 1 Auto Cut and Crimp
class Homepage extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Homepage({required this.employee, required this.machine});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int type = 0;
  String sameMachine = 'true';
  int scheduleType = 0;
  ApiService? apiService;

  String dropdownName = "FG part";

  var _chosenValue = "Order Id";

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();

    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Future<Null> _refresh() async {
    setState(() {});
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
          '${widget.machine.category}',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        elevation: 0,
        actions: [
          //typeselect

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3),
            decoration: BoxDecoration(),
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
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                SwitchButton(
                  options: ['Same MC', 'Other MC'],
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
                //     // color: Colors.red.shade500,
                //     borderRadius: BorderRadius.all(Radius.circular(50)),
                //     // border: Border.all(color: Colors.red.shade500),
                //   ),
                //   child: ToggleSwitch(
                //     minWidth: 75.0,
                //     cornerRadius: 5.0,
                //     activeBgColor: Colors.red.shade500,
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
                //         _searchController.clear();
                //         scheduleType = index;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),

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
                        color: Colors.grey.shade100,
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
                          Text(widget.employee.empId,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black)),
                        ],
                      )),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
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
                          ),
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
      body: Column(
        children: [
          search(),
          SchudleTable(
            employee: widget.employee,
            machine: widget.machine,
            type: type == 0 ? "A" : "M",
            scheduleType: scheduleType == 0 ? "true" : "false",
            searchType: _chosenValue,
            query: _searchController.text,
          ),
        ],
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
            SizedBox(width: 15),
            dropdown(
                options: ["Order Id", "FG Part No.", "Cable Part No"],
                name: "Order Id"),
            SizedBox(width: 10),
            Container(
              height: 38,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.red.shade500,
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
                          // suffix: _searchController.text.length > 1
                          //     ? GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //              SystemChannels.textInput
                          //         .invokeMethod('TextInput.hide');
                          //             _searchController.clear();
                          //           });
                          //         },
                          //         child: Icon(Icons.clear,
                          //             size: 16, color: Colors.red))
                          //     : Container(),
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
            SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget dropdown({required List<String> options, required String name}) {
    return Container(
        child: DropdownButton<String>(
      focusColor: Colors.red,
      value: _chosenValue,
      underline: Container(
        height: 2,
        color: Colors.red,
      ),
      isDense: false,
      isExpanded: false,
      style: TextStyle(color: Colors.white),
      iconSize: 28,
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
      hint: Text(
        name,
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value!;
        });
      },
    ));
  }
}

class SchudleTable extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  String scheduleType;
  String type;
  String searchType;
  String query;
  SchudleTable(
      {Key? key,
      required this.employee,
      required this.type,
      required this.searchType,
      required this.query,
      required this.machine,
      required this.scheduleType})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<Schedule> schedualrList = [];

  List<DataRow> datarows = [];
  ApiService? apiService;

  PostStartProcessP1? postStartprocess;
  //Filter
  late DateTime startDate = sharedPref.startDate ??
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 5)));
  late DateTime endDate = sharedPref.endDate ??
      DateUtils.dateOnly(DateTime.now().add(const Duration(days: 3)));
  bool floatingActionLoading = false;
  List<String> selectedMachine = [];
  @override
  void initState() {
    apiService = new ApiService();
    selectedMachine = [widget.machine.machineNumber ?? ''];

    super.initState();
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void _doSomething() async {
    Timer(Duration(seconds: 3), () {});
  }

  List<Schedule>? searchfilter(List<Schedule>? scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList!
            .where((element) => element.orderId.startsWith(widget.query))
            .toList();
        break;
      case "FG Part No.":
        return scheduleList!
            .where((element) =>
                element.finishedGoodsNumber.startsWith(widget.query))
            .toList();
        break;
      case "Cable Part No":
        return scheduleList!
            .where(
                (element) => element.cablePartNumber.startsWith(widget.query))
            .toList();
        break;
      default:
        return scheduleList;
    }
  }

  ScrollController _scrollController = new ScrollController();
  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 3), () {
      log("message reload");
      completer.complete();
      setState(() {});
    });
    return completer.future;
  }

  void homeReload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log("messagedate ${selectedMachine}");
    return Container(
      height: widget.type == "M" ? 465 : 535,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                tableHeading(),
                SingleChildScrollView(
                  child: Container(
                      height: widget.type == "M" ? 425 : 495,
                      // height: double.parse("${rowList.length*60}"),
                      child: FutureBuilder<List<Schedule>?>(
                        future: apiService!.getScheduelarData(
                            machId: widget.machine.machineNumber ?? '',
                            type: widget.type,
                            sameMachine: widget.scheduleType),
                        builder:
                            (context, AsyncSnapshot<List<Schedule>?> snapshot) {
                          if (snapshot.hasData) {
                            // return  buildDataRow(schedule:widget.schedule,c:2);
                            List<Schedule>? schedulelist =
                                searchfilter(snapshot.data??[]);
                            schedulelist = schedulelist!
                                .where((element) =>
                                    element.scheduledStatus.toLowerCase() !=
                                    "complete".toLowerCase())
                                .toList();
                            schedulelist = schedulelist
                                .where((element) =>
                                    element.currentDate.isBefore(endDate) &&
                                        element.currentDate
                                            .isAfter(startDate) ||
                                    element.currentDate == startDate ||
                                    element.currentDate == endDate)

                                // compareTo(DateTime(
                                //   DateTime.now().year,
                                //   DateTime.now().month,
                                //   DateTime.now().day,
                                // ).add(Duration(days: 7))) <=
                                // 0)
                                .toList();
                            schedulelist = schedulelist
                                .where((element) => selectedMachine.length <= 1
                                    ? true
                                    : selectedMachine
                                        .contains(element.machineNumber))
                                .toList();
                            schedulelist.sort((a, b) => int.parse(a.scheduledId)
                                .compareTo(int.parse(b.scheduledId)));

                            //  schedulelist =  schedulelist+ schedulelist+ schedulelist+ schedulelist+ schedulelist;

                            if (schedulelist.length > 0) {
                              return RefreshIndicator(
                                onRefresh: _onRefresh,
                                child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: schedulelist.length,
                                    itemBuilder: (context, index) {
                                      return ScheduleDataRow(
                                        schedule: schedulelist![index],
                                        machine: widget.machine,
                                        employee: widget.employee,
                                        onrefresh: _onRefresh,
                                      );
                                    }),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(108.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text('No Schedule Found',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
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
                                                        BorderRadius.circular(
                                                            100.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .transparent))),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed))
                                                  return Colors.green.shade200;
                                                return Colors.red
                                                    .shade400; // Use the component's default.
                                              },
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Refresh  ",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Padding(
                                padding: const EdgeInsets.all(108.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text('No Schedule Found',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
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
                                                        BorderRadius.circular(
                                                            100.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .transparent))),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed))
                                                  return Colors.green.shade200;
                                                return Colors.red
                                                    .shade400; // Use the component's default.
                                              },
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Refresh  ",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                    // color: Colors.red,
                                    ),
                              );
                            }
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            setState(() {
              floatingActionLoading = !floatingActionLoading;
            });
            apiService!
                .getScheduelarData(
                    machId: widget.machine.machineNumber ?? '',
                    type: widget.type,
                    sameMachine: widget.scheduleType)
                .then((value) {
              setState(() {
                floatingActionLoading = !floatingActionLoading;
              });
              floatingActionLoading
                  ? null
                  : showFilterDashBoard(
                      context: context,
                      startDate: startDate,
                      endDate: endDate,
                      //machine
                      machineIds: value!
                          .map((e) => e.machineNumber.toString())
                          .toSet()
                          .toList(),
                      selectedMachine: selectedMachine,
                      onChangedMachine: (selectedList) {
                        setState(() {
                          selectedMachine = selectedList;
                        });
                      },
                      onchangedDateRange: (startDate1, endDate1) {
                        setState(() {
                          sharedPref.setStartandEndDate(
                              startDate: startDate1, endDate: endDate1?? DateUtils.dateOnly(
                                  DateTime.now().add(Duration(days: 7))));
                          startDate = DateUtils.dateOnly(startDate1);
                          endDate = endDate1 ??
                              DateUtils.dateOnly(
                                  DateTime.now().add(Duration(days: 7)));
                        });
                      });
            });
          },
          child: floatingActionLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.sort),
        ),
      ),
    );
  }

  // no data
  // empty list

  Widget tableHeading() {
    Widget cell(String name, double width, bool sort) {
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
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600),
              )
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order ID", 0.07, true),
                  cell("FG Part", 0.07, true),
                  cell("Schedule ID", 0.07, false),
                  cell("  Cable Part \n  No.", 0.08, true),
                  cell("Process", 0.115, false),
                  cell("Cut Length\n(mm)", 0.065, true),
                  cell("Color", 0.05, false),
                  cell("Scheduled\nQty", 0.065, true),
                  cell("Actual\nQty", 0.05, true),
                  cell("AWG", 0.035, true),
                  cell("Shift", 0.073, true),
                  cell("Time", 0.085, true),
                  cell("Status", 0.08, true),
                  cell("Action", 0.08, true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
