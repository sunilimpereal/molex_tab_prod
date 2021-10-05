import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:molex/main.dart';
import 'package:molex/screens/operator%202/widgets/crimpig_schedule_data_row.dart';
import 'package:molex/screens/operator%202/widgets/filter%20_dashboard_crimping.dart';
import 'package:molex/screens/operator/widgets/filter_dashboard.dart';
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
  HomePageOp2({required this.employee, required this.machine});
  @override
  _HomePageOp2State createState() => _HomePageOp2State();
}

class _HomePageOp2State extends State<HomePageOp2> {
  int type = 0;
  late ApiService apiService;
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
                //     color: Colors.red.shade500,
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     border: Border.all(color: Colors.red.shade500),
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            employee: widget.employee, machineDetails: widget.machine, type: "process"),
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
              query: _searchController.text,
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
            dropdown(options: ["Order Id", "FG Part No.", "Cable Part No"], name: "Order Id"),
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
                      color: Colors.red.shade400,
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
                          hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 13, top: 11, right: 0),
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

  Widget dropdown({required List<String> options, required String name}) {
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
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
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
  final Employee employee;
  final MachineDetails machine;
  String scheduleType;
  String type;
  String searchType;
  String query;
  SchudleTable(
      {Key? key,
      required this.employee,
      required this.machine,
      required this.scheduleType,
      required this.type,
      required this.searchType,
      required this.query})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<DataRow> datarows = [];
  late ApiService apiService;
  late List<CrimpingSchedule> crimpingSchedule;
  late PostStartProcessP1 postStartprocess;

  //Filter
  late DateTime startDate =
      sharedPref.startDate ?? DateTime.now().subtract(const Duration(days: 5));
  late DateTime endDate = sharedPref.endDate ?? DateTime.now().add(const Duration(days: 5));
  bool floatingActionLoading = false;
  List<String> selectedMachine = [];
  @override
  void initState() {
    apiService = new ApiService();
    startDate = DateUtils.dateOnly(startDate);
    endDate = DateUtils.dateOnly(endDate);
    super.initState();
  }

  List<CrimpingSchedule>? searchfilter(List<CrimpingSchedule>? scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList!
            .where((element) => element.purchaseOrder.toString().startsWith(widget.query))
            .toList();
        break;
      case "FG Part No.":
        return scheduleList!
            .where((element) => element.finishedGoods.toString().startsWith(widget.query))
            .toList();
        break;
      case "Cable Part No":
        return scheduleList!
            .where((element) => element.cablePartNo.toString().startsWith(widget.query))
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
      height: widget.type == "M" ? 465 : 538,
      child: Scaffold(
        body: Container(
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
                          machineNo: widget.machine.machineNumber ?? '',
                          sameMachine: "${widget.scheduleType}"),
                      builder: (context, AsyncSnapshot<List<CrimpingSchedule>> snapshot) {
                        if (snapshot.hasData) {
                          List<CrimpingSchedule>? schedulelist = searchfilter(snapshot.data);
                          schedulelist = schedulelist!
                              .where((element) =>
                                  element.schedulestatus.toLowerCase() != "Complete".toLowerCase())
                              .toList();
                          schedulelist = schedulelist
                              .where((element) =>
                                  element.scheduleDate.isBefore(endDate) &&
                                      element.scheduleDate.isAfter(startDate) ||
                                  element.scheduleDate == startDate ||
                                  element.scheduleDate == endDate)
                              .toList();
                          schedulelist.sort((a, b) => a.scheduleId.compareTo(b.scheduleId));

                          if (schedulelist.length > 0) {
                            return RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: schedulelist.length,
                                  itemBuilder: (context, index) {
                                    return CrimpingScheduleDataRow(
                                      schedule: schedulelist![index],
                                      machine: widget.machine,
                                      employee: widget.employee,
                                      type: widget.type,
                                      sameMachine: widget.scheduleType,
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
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide(color: Colors.transparent))),
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors
                                                  .red.shade400; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            setState(() {
              floatingActionLoading = !floatingActionLoading;
            });
            apiService
                .getCrimpingSchedule(
                    scheduleType: "${widget.type}",
                    machineNo: widget.machine.machineNumber ?? '',
                    sameMachine: "${widget.scheduleType}")
                .then((value) {
              setState(() {
                floatingActionLoading = !floatingActionLoading;
              });
              floatingActionLoading
                  ? null
                  : showFilterDashBoardCrimping(
                      context: context,
                      startDate: startDate,
                      endDate: endDate,
                      onchangedDateRange: (startDate1, endDate1) {
                        setState(() {
                          sharedPref.setStartandEndDate(
                              startDate: startDate1,
                              endDate: endDate1 ??
                                  DateUtils.dateOnly(DateTime.now().add(Duration(days: 7))));
                          startDate = DateUtils.dateOnly(startDate1);
                          endDate =
                              DateUtils.dateOnly(endDate1 ?? DateTime.now().add(Duration(days: 7)));
                          log("dater ${startDate.toString()}");
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
}

class CrimpingStartButton extends StatefulWidget {
  Function onPressed;
  Widget child;
  ButtonStyle style;
  CrimpingStartButton({required this.onPressed, required this.child, required this.style})
      : super();

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
                try {
                  a = await widget.onPressed();
                } catch (e) {
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
