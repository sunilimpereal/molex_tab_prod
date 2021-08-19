import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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


// Process 1 Auto Cut and Crimp
class Homepage extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Homepage({this.employee, this.machine});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int type = 0;
  String sameMachine = 'true';
  int scheduleType = 0;
  ApiService apiService;

  String dropdownName = "FG part";

  var _chosenValue = "Order Id";

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();
    apiService.getScheduelarData(
        machId: widget.machine.machineNumber, type: type == 0 ? "A" : "B");
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
                //     // color: Colors.red[500],
                //     borderRadius: BorderRadius.all(Radius.circular(50)),
                //     // border: Border.all(color: Colors.red[500]),
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
                            style: TextStyle(
                                    fontSize: 13, color: Colors.black)
                          ),
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
                            style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            
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
                query: _searchController.text ?? "",
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
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.red[500],
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
                        style:  TextStyle(fontSize: 16),
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
                          hintStyle:TextStyle(
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

  Widget dropdown({List<String> options, String name}) {
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
      hint: Text(name,
          style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
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
  Schedule schedule;
  Employee employee;
  MachineDetails machine;
  String scheduleType;
  String type;
  String searchType;
  String query;
  SchudleTable(
      {Key key,
      this.schedule,
      this.employee,
      this.type,
      this.searchType,
      this.query,
      this.machine,
      this.scheduleType})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<Schedule> schedualrList = [];

  List<DataRow> datarows = [];
  ApiService apiService;

  PostStartProcessP1 postStartprocess;
  @override
  void initState() {
    apiService = new ApiService();

    super.initState();
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void _doSomething() async {
    Timer(Duration(seconds: 3), () {});
  }

  List<Schedule> searchfilter(List<Schedule> scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList
            .where((element) => element.orderId.startsWith(widget.query))
            .toList();
        break;
      case "FG Part No.":
        return scheduleList
            .where((element) =>
                element.finishedGoodsNumber.startsWith(widget.query))
            .toList();
        break;
      case "Cable Part No":
        return scheduleList
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
      setState(() {
              
            });
    });
    return completer.future;
  }



  void homeReload(){
    setState(() {
          
        });
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
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
                    child: FutureBuilder(
                      future: apiService.getScheduelarData(
                          machId: widget.machine.machineNumber,
                          type: widget.type,
                          sameMachine: widget.scheduleType),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // return  buildDataRow(schedule:widget.schedule,c:2);
                          List<Schedule> schedulelist =
                              searchfilter(snapshot.data);
                          schedulelist = schedulelist
                              .where((element) =>
                                  element.scheduledStatus.toLowerCase() !=
                                  "complete".toLowerCase())
                              .toList();
                       schedulelist=   schedulelist
                              .where((element) =>
                                  element.currentDate.compareTo(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  )) <=
                                  0)
                              .toList();
                          schedulelist.sort(
                              (a, b) => a.currentDate.compareTo(b.currentDate));
                              //  schedulelist =  schedulelist+ schedulelist+ schedulelist+ schedulelist+ schedulelist;

                          if (schedulelist.length > 0) {
                            return RefreshIndicator(
                             onRefresh: _onRefresh,
                              child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,

                                  shrinkWrap: true,
                                  itemCount: schedulelist.length,
                                  itemBuilder: (context, index) {
                                    return buildDataRow(
                                        schedule: schedulelist[index],
                                        c: index + 1);
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
                          if (snapshot.connectionState == ConnectionState.done) {
                          return Padding(
                          padding: const EdgeInsets.all(108.0),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  'No Schedule Found',
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
              Text(name,
                  style:  TextStyle(
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

  Widget buildDataRow({Schedule schedule, int c}) {
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
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 1,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          color: c % 2 == 0 ? Colors.white : Colors.grey[50],
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                color: schedule.scheduledStatus.toLowerCase() ==
                        "Complete".toLowerCase()
                    ? Colors.green
                    : schedule.scheduledStatus.toLowerCase() ==
                            "Partially".toLowerCase()
                        ? Colors.orange[100]
                        : Colors.blue[100],
                width: 5,
              )),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell(schedule.orderId, 0.07),
                //Fg Part
                cell(schedule.finishedGoodsNumber, 0.07),

                //Schudule ID
                cell(schedule.scheduledId, 0.07),
                //Cable Part
                cell(schedule.cablePartNumber, 0.08),

                //Process
                cell(schedule.process, 0.12),
                // Cut length
                cell(schedule.length, 0.060),
                //Color
                cell(schedule.color, 0.05),
                //Scheduled Qty
                cell(schedule.scheduledQuantity, 0.065),
                cell(schedule.actualQuantity.toString(), 0.05),
                cell(schedule.awg.toString(), 0.035),
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
                              "${schedule.shiftNumber}",
                              style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),

                            ),
                          ],
                        ),
                        Text(
                          "${schedule.shiftType}",
                          style:TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          
                        ),
                      ],
                    ),
                  ),
                ),
                // cell("${schedule.shiftType}", 0.074),
                Container(
                  width: MediaQuery.of(context).size.width * 0.085,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            schedule.currentDate == null
                                ? ""
                                : DateFormat("dd-MM-yyyy")
                                    .format(schedule.currentDate),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: schedule.scheduledStatus.toLowerCase() ==
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
                            color: schedule.scheduledStatus.toLowerCase() ==
                                    'Complete'.toLowerCase()
                                ? Colors.green[100]
                                : schedule.scheduledStatus.toLowerCase() ==
                                        "Partially Completed".toLowerCase()
                                    ? Colors.red[50]
                                    : Colors.blue[50],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 4
                              ),
                              child: Text(
                                schedule.scheduledStatus,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: schedule.scheduledStatus
                                                .toLowerCase() ==
                                            'Complete'.toLowerCase()
                                        ? Colors.green
                                        : schedule.scheduledStatus
                                                    .toLowerCase() ==
                                                "Partially Completed"
                                                    .toLowerCase()
                                            ? Colors.red[400]
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
                                width:
                                    MediaQuery.of(context).size.width * 0.07,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.07 *
                                    ((schedule.actualQuantity /
                                        int.parse(schedule.scheduledQuantity ??
                                            '1'))),
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green[300],
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
                  child: schedule.scheduledStatus.toLowerCase() ==
                          "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ProgressButton(
                                  color: schedule.scheduledStatus
                                              .toLowerCase() ==
                                          "Partially Completed".toLowerCase()
                                      ? Colors.green[500]
                                      : Colors.green[500],
                                  defaultWidget: Container(
                                      child: schedule.scheduledStatus
                                                      .toLowerCase() ==
                                                  "Allocated".toLowerCase() ||
                                              schedule.scheduledStatus
                                                      .toLowerCase() ==
                                                  "Open".toLowerCase() ||
                                              schedule.scheduledStatus
                                                      .toLowerCase() ==
                                                  "".toLowerCase() ||
                                              schedule.scheduledStatus == null
                                          ? Text(
                                              "Accept",
                                              style:  TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              
                                            )
                                          : schedule.scheduledStatus
                                                          .toLowerCase() ==
                                                      "Pending".toLowerCase() ||
                                                  schedule.scheduledStatus
                                                          .toLowerCase() ==
                                                      "Partially Completed"
                                                          .toLowerCase() ||
                                                  schedule.scheduledStatus
                                                          .toLowerCase() ==
                                                      "started".toLowerCase()
                                              ? Text(
                                                  'Continue',
                                                  style:  TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  
                                                )
                                              : Text('')),
                                  animate: true,
                                  progressWidget: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Container(
                                        height: 10,
                                        child: ColorLoader4(
                                          dotOneColor: Colors.white,
                                          dotThreeColor: Colors.white,
                                          dotTwoColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  width: 30,
                                  height: 40,
                                  onPressed: () async {
                                    if (schedule.shiftType == "Allocated") {
                                      // After [onPressed], it will trigger animation running backwards, from end to beginning
                                      postStartprocess = new PostStartProcessP1(
                                        cablePartNumber:
                                            schedule.cablePartNumber ?? "0",
                                        color: schedule.color,
                                        finishedGoodsNumber:
                                            schedule.finishedGoodsNumber ?? "0",
                                        lengthSpecificationInmm:
                                            schedule.length ?? "0",
                                        machineIdentification:
                                            widget.machine.machineNumber,
                                        orderIdentification:
                                            schedule.orderId ?? "0",
                                        scheduledIdentification:
                                            schedule.scheduledId ?? "0",
                                        scheduledQuantity:
                                            schedule.scheduledQuantity ?? "0",
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
                                                      schedule: schedule,
                                                      employee: widget.employee,
                                                      machine: widget.machine,
                                                      materialPickType:
                                                          MaterialPickType
                                                              .newload,
                                                    )),
                                          ).then((value) {
                                            _onRefresh();
                                            log("nabk");
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
                                        }
                                        return () {};
                                      });
                                    } else {
                                      showScheduleDetail(schedule: schedule)
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

  Future<void> showScheduleDetail({Schedule schedule}) {
    Widget feild({String heading, String value, double width}) {
      width = MediaQuery.of(context).size.width * width;
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          // color: Colors.red[100],
          width: width,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
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
                      style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      
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
                                  value: schedule.orderId,
                                  width: 0.14),
                              feild(
                                  heading: "FG Part",
                                  value: "${schedule.finishedGoodsNumber}",
                                  width: 0.14),
                              feild(
                                  heading: "Schedule ID",
                                  value: "${schedule.scheduledId}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Cable Part No.",
                                  value: "${schedule.cablePartNumber}",
                                  width: 0.14),
                              feild(
                                  heading: "Process",
                                  value: "${schedule.process}",
                                  width: 0.14),
                              feild(
                                  heading: "cable#",
                                  value: "${schedule.cableNumber}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Cut Length",
                                  value: "${schedule.length}",
                                  width: 0.14),
                              feild(
                                  heading: "Color",
                                  value: "${schedule.color}",
                                  width: 0.14),
                              feild(
                                  heading: "Scheduled Qty",
                                  value: "${schedule.scheduledQuantity}",
                                  width: 0.14),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              feild(
                                  heading: "Date",
                                  value: schedule.currentDate == null
                                      ? ""
                                      : DateFormat("dd-MM-yyyy")
                                          .format(schedule.currentDate),
                                  width: 0.14),
                              feild(
                                  heading: "Shift Type",
                                  value: "${schedule.shiftType}",
                                  width: 0.14),
                              feild(heading: "", width: 0.14)
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
                                      return Colors.green[200];
                                    return Colors.green[
                                        500]; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green[200];
                                    return Colors.green[
                                        500]; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                postStartprocess = new PostStartProcessP1(
                                  cablePartNumber:
                                      schedule.cablePartNumber ?? "0",
                                  color: schedule.color,
                                  finishedGoodsNumber:
                                      schedule.finishedGoodsNumber ?? "0",
                                  lengthSpecificationInmm:
                                      schedule.length ?? "0",
                                  machineIdentification:
                                      widget.machine.machineNumber,
                                  orderIdentification: schedule.orderId ?? "0",
                                  scheduledIdentification:
                                      schedule.scheduledId ?? "0",
                                  scheduledQuantity:
                                      schedule.scheduledQuantity ?? "0",
                                  scheduleStatus: "complete",
                                );
                                FullyCompleteModel fullyComplete =
                                    FullyCompleteModel(
                                        finishedGoodsNumber: int.parse(
                                            schedule.finishedGoodsNumber),
                                        purchaseOrder:
                                            int.parse(schedule.orderId),
                                        orderId: int.parse(schedule.orderId),
                                        cablePartNumber:
                                            int.parse(schedule.cablePartNumber),
                                        length: int.parse(schedule.length),
                                        color: schedule.color,
                                        scheduledStatus: "Complete",
                                        scheduledId:
                                            int.parse(schedule.scheduledId),
                                        scheduledQuantity: int.parse(
                                            schedule.scheduledQuantity),
                                        machineIdentification:
                                            widget.machine.machineNumber,
                                        //TODO bundle ID
                                        firstPieceAndPatrol: 0,
                                        applicatorChangeover: 0);
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
                                      return Colors.green[200];
                                    return Colors.green[
                                        500]; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green[200];
                                    return Colors.green[
                                        500]; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context1);
                                postStartprocess = new PostStartProcessP1(
                                  cablePartNumber:
                                      schedule.cablePartNumber ?? "0",
                                  color: schedule.color,
                                  finishedGoodsNumber:
                                      schedule.finishedGoodsNumber ?? "0",
                                  lengthSpecificationInmm:
                                      schedule.length ?? "0",
                                  machineIdentification:
                                      widget.machine.machineNumber,
                                  orderIdentification: schedule.orderId ?? "0",
                                  scheduledIdentification:
                                      schedule.scheduledId ?? "0",
                                  scheduledQuantity:
                                      schedule.scheduledQuantity ?? "0",
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
                                                  schedule: schedule,
                                                  employee: widget.employee,
                                                  machine: widget.machine,
                                                  homeReload: homeReload,
                                                  materialPickType:
                                                      MaterialPickType.newload,
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
