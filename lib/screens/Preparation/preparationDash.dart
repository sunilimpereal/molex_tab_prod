import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex/model_api/machinedetails_model.dart';
import 'package:molex/screens/widgets/drawer.dart';

import '../../Machine_Id.dart';
import '../../model_api/Preparation/getpreparationSchedule.dart';
import '../../model_api/login_model.dart';
import '../../model_api/schedular_model.dart';
import 'process/preparationProcess.dart';
import '../widgets/time.dart';
import '../../service/apiService.dart';

class PreprationDash extends StatefulWidget {
  Employee employee;
  String machineId;
  PreprationDash({required this.employee, required this.machineId});
  @override
  _PreprationDashState createState() => _PreprationDashState();
}

class _PreprationDashState extends State<PreprationDash> {
  int type = 0;
  late ApiService apiService;

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
      drawer: Drawer(
        child: DrawerWidget(
            employee: widget.employee,
            machineDetails: MachineDetails(machineNumber: "preparation"),
            type: "process"),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        backwardsCompatibility: false,
        title: const Text(
          'Preparation DashBoard',
          style: TextStyle(color: Colors.red),
        ),
        elevation: 0,
        actions: [
          // machineID
          Container(
            padding: EdgeInsets.all(1),
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
                          ),
                        ],
                      )),
                    ),
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
                            widget.machineId ?? "",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.redAccent,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent))),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                          return Colors.green.shade500; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Preparationprocess(
                                  employee: widget.employee,
                                  machineId: widget.machineId,
                                )),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/image/scan.png"))),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Process',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )),
                )
              ],
            ),
            search(),
            SchudleTable(
              userId: widget.employee.empId,
              machineId: widget.machineId,
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
            Container(
                width: 130,
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  decoration: new InputDecoration(
                    labelText: "FG Part No.",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                )),
            SizedBox(width: 10),
            Container(
                width: 120,
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  decoration: new InputDecoration(
                    labelText: "Order Id.",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                )),
            SizedBox(width: 10),
            Container(
                width: 150,
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  decoration: new InputDecoration(
                    labelText: "Cable Part No.",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                )),
            SizedBox(width: 10),
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Search'),
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class SchudleTable extends StatefulWidget {
  String userId;
  String machineId;
  SchudleTable({Key? key, required this.machineId, required this.userId}) : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  late ApiService apiService;
  List<Schedule> rowList = [];

  List<DataRow> datarows = [];
  @override
  void initState() {
    apiService = ApiService();
    super.initState();
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            tableHeading(),
            Container(
                // height: double.parse("${rowList.length*60}"),
                child: FutureBuilder(
              future: apiService.getPreparationSchedule(type: "A", machineNo: widget.machineId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PreparationSchedule>? preparationSchedulelist =
                      snapshot.data as List<PreparationSchedule>?;
                  return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: preparationSchedulelist!.length,
                          itemBuilder: (context, index) {
                            return buildDataRow(schedule: preparationSchedulelist[index], c: index);
                          }));
                } else {
                  return Container();
                }
              },
            )),
          ],
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
                    fontSize: 12,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order Id", 0.1),
                  cell("FG Part", 0.1),
                  cell("Schedule ID", 0.1),
                  cell("Cable Part No.", 0.1),
                  cell("Process", 0.07),
                  cell("Cut Length\n(mm)", 0.07),
                  cell("Color", 0.04),
                  cell("Bin Id", 0.09),
                  cell("Total \nBundles", 0.05),
                  cell("Total \nBundle Qty", 0.07),
                  cell("Status", 0.09),
                  // cell("Action", 0.1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataRow({required PreparationSchedule schedule, required int c}) {
    Widget cell(String name, double width) {
      return Container(
        width: MediaQuery.of(context).size.width * width,
        height: 30,
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: c % 2 == 0 ? Colors.grey.shade50 : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
            color: schedule.scheduledStatus == ""
                ? Colors.green
                : schedule.scheduledStatus == "Partial"
                    ? Colors.orange.shade100
                    : Colors.blue.shade100,
            width: 5,
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // orderId
            cell(schedule.orderId ?? '', 0.1),
            //Fg Part
            cell(schedule.finishedGoodsNumber ?? '', 0.1),

            //Schudule ID
            cell(schedule.scheduledId ?? 'NULL', 0.1),
            //Cable Part
            cell(schedule.cablePartNumber ?? 'null', 0.1),

            //Process
            cell(schedule.process ?? 'null', 0.07),
            // Cut length
            cell(schedule.length ?? "null", 0.07),
            //Color
            cell(schedule.color ?? "null", 0.04),
            //Bin Id
            cell("${schedule.binIdentification}", 0.09),
            // Total bundles
            cell("${schedule.numberOfBundles}", 0.05),
            //Total Bundle Qty
            cell("${schedule.bundleQuantity}", 0.07),

            //Status
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: 30,
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: schedule.scheduledStatus == 'Complete'
                      ? Colors.green.shade50
                      : schedule.scheduledStatus == "Partial"
                          ? Colors.red.shade100
                          : Colors.blue.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    schedule.scheduledStatus ?? "status",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: schedule.scheduledStatus == 'Complete'
                          ? Colors.green
                          : schedule.scheduledStatus == "Partial"
                              ? Colors.yellow[900]
                              : Colors.blue[900],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
