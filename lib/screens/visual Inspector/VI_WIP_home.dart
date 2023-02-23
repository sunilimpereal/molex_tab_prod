import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model_api/Transfer/postgetBundleMaster.dart';
import '../../model_api/process1/getBundleListGl.dart';
import '../../utils/config.dart';
import '../widgets/alertDialog/alertDialogVI.dart';
import '../../main.dart';
import '../../model_api/Transfer/bundleToBin_model.dart';
import '../../model_api/cableTerminalA_model.dart';
import '../../model_api/cableTerminalB_model.dart';
import '../../model_api/crimping/bundleDetail.dart';
import '../../model_api/login_model.dart';
import '../../model_api/machinedetails_model.dart';
import '../../model_api/visualInspection/saveinspectedBundle_model.dart';
import '../operator/location.dart';
import '../visual%20Inspector/VI_WIP_joint.dart';
import '../visual%20Inspector/VI_locationTransfer.dart';
import '../widgets/keypad.dart';
import '../widgets/time.dart';
import '../../service/apiService.dart';

enum Status {
  dash,
  rejCase,
  binScan,
}

class VIWIP_Home extends StatefulWidget {
  Employee employee;
  VIWIP_Home({required this.employee});
  @override
  _VIWIP_HomeState createState() => _VIWIP_HomeState();
}

class _VIWIP_HomeState extends State<VIWIP_Home> {
  TextEditingController _userScanController = new TextEditingController();
  FocusNode _userScanFocus = new FocusNode();
  TextEditingController _bundleIdScanController = new TextEditingController();
  FocusNode _bundleIdScanFocus = new FocusNode();
  late String userId;
  late String bundleId;
  List<ViInspectedbundle> viIspectionBundleList = [];
  TextEditingController scanBundleController = new TextEditingController();
  TextEditingController crimpInslController = new TextEditingController();
  TextEditingController insulationSlugController = new TextEditingController();
  TextEditingController windowgapController = new TextEditingController();
  TextEditingController exposedStrandsController = new TextEditingController();
  TextEditingController burrCutOffController = new TextEditingController();
  TextEditingController terminalBendCloseddamageController = new TextEditingController();
  TextEditingController insulationCurlingController = new TextEditingController();
  TextEditingController nickMarkStrandcutController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController frontBelMouthController = new TextEditingController();
  TextEditingController backBellMouthController = new TextEditingController();
  TextEditingController extructionOnBurrController = new TextEditingController();
  TextEditingController brushLengthController = new TextEditingController();
  TextEditingController cabledamageController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();

  FocusNode scanFocus = new FocusNode();

  String _output = '';

  TextEditingController maincontroller = new TextEditingController();

  TextEditingController _binController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();

  late String binId;

  TextEditingController passedQtyController = new TextEditingController();
  TextEditingController bundleQtyController = new TextEditingController();

  TextEditingController rejectedQtyController = new TextEditingController();

  TextEditingController userScanController = new TextEditingController();
  Status status = Status.dash;

  int selectedindex = 0;
  late ApiService apiService;
  List<String> usersList = [];
  bool loading = false;

  bool loadingBin = false;
  bool donotrepeatalert = false;

  getUser() {
    apiService = new ApiService();
    apiService.getUserList().then((value) {
      setState(() {
        usersList = value!.map((e) => e.empId).toList();
      });
    });
  }

  late CableTerminalA terminalA;
  late CableTerminalB terminalB;
  getTerminal({required String fgNumber, required String cablePtNo, required String length, required String color, required int awg}) {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(isCrimping: false, fgpartNo: fgNumber, cablepartno: cablePtNo, length: length, color: color, awg: awg)
        .then((termiA) {
      apiService
          .getCableTerminalB(isCrimping: false, fgpartNo: fgNumber, cablepartno: cablePtNo, length: length, color: color, awg: awg)
          .then((termiB) {
        setState(() {
          terminalA = termiA!;
          terminalB = termiB!;
        });
      });
    });
  }

  @override
  void initState() {
    apiService = new ApiService();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(_locationController.text);
    SystemChannels.textInput.invokeMethod(keyboardType);
    SystemChannels.textInput.invokeMethod(keyboardType);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.red,
            ),
            title: const Text(
              'Visual Inspection',
              style: TextStyle(color: Colors.red),
            ),
            elevation: 0,
            automaticallyImplyLeading: status == Status.dash ? true : false,
            actions: [
              //machineID
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
                      ],
                    )
                  ],
                ),
              ),

              TimeDisplay(),
            ],
            bottom: TabBar(
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text("Single Bundle", style: TextStyle(color: Colors.red)),
                ),
                Tab(
                  child: Text("Joint Bundle", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: main(status),
            ),
            VIWIP_Home_joint(
              employee: widget.employee,
            )
          ])),
    );
  }

  Widget main(Status status) {
    switch (status) {
      case Status.dash:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [scanUserAndBundle(), table()],
        );
        break;
      case Status.rejCase:
        return vitable(selectedindex);
        break;
      case Status.binScan:
        return binScan(selectedindex);
        break;
      default:
        return Container();
    }
  }

  Widget scanUserAndBundle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          color: Colors.transparent,
          height: 400,
          width: 300,
          child: Column(
            children: [userScan(), bundleScan(), button()],
          )),
    );
  }

  Widget button() {
    return Column(
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.22,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: Colors.green, // background
              onPrimary: Colors.white,
            ),
            onPressed: () {
              addBundletoList();
              _bundleIdScanFocus.requestFocus();
            },
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.22,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Colors.green, // background
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                final list = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViLocationTransfer(
                            type: "visualInspection",
                            employee: widget.employee,
                            locationType: LocationType.partialTransfer,
                            machine: MachineDetails(machineNumber: ""),
                          )),
                );
                log("lilst : $list");

                setState(() {
                  for (String bundle in list) {
                    try {
                      viIspectionBundleList
                          .remove(viIspectionBundleList[viIspectionBundleList.indexWhere((element) => element.bundleIdentification == bundle)]);
                    } catch (e) {}
                  }
                  list.map((e) {
                    print('blahhh');
                  });
                });
              },
              child: Text(
                'Transfer Bin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addBundletoList() {
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      scheduleId: 0,
      binId: 0,
      bundleId: bundleId,
      location: '',
      status: '',
      finishedGoods: 0,
      cablePartNumber: 0,
      orderId: "",
    );
    if (userId.length > 0 && bundleId.length > 0) {
      setState(() {
        print(" UserList $userId $usersList");
        if (usersList.contains(userId)) {
          apiService.getBundlesInSchedule(postgetBundleMaster: postgetBundleMaste, scheduleID: "").then((value) {
            if (value != null) {
              BundlesRetrieved bundleData = value[0];
              if (!viIspectionBundleList.map((e) => e.bundleIdentification).toList().contains(bundleData.bundleIdentification)) {
                if (bundleData.updateFromProcess.toLowerCase().contains("visualInspection".toLowerCase())) {
                  Fluttertoast.showToast(
                      msg: "Visual Inspection already completed for bundle Id ${bundleData.bundleIdentification}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return null;
                }
                if (bundleData.crimpFromSchId.length < 2 || bundleData.crimpToSchId.length < 2) {
                  if (!donotrepeatalert) {
                    showBundleAlertVi(
                        context: context,
                        crimpfrom: bundleData.crimpFromSchId,
                        crimpto: bundleData.crimpToSchId,
                        bundleStaus: bundleData.bundleStatus.toLowerCase(),
                        onDoNotRemindAgain: (value) {
                          setState(() {
                            donotrepeatalert = value;
                            log("message donotrepeatalert $donotrepeatalert");
                          });
                        },
                        onSubmitted: () {
                          setState(() {
                            _locationController.text = bundleData.locationId.toString();
                            viIspectionBundleList.add(
                              ViInspectedbundle(
                                  locationId: bundleData.locationId.toString(),
                                  bundleIdentification: bundleData.bundleIdentification.toString(),
                                  binId: bundleData.binId.toString(),
                                  employeeid: userId,
                                  orderId: bundleData.orderId ?? '',
                                  awg: bundleData.awg,
                                  fgPart: bundleData.finishedGoodsPart.toString(),
                                  scheduleId: bundleData.scheduledId.toString() ?? '',
                                  bundleQuantity: bundleData.bundleQuantity,
                                  status: "Not Completed",
                                  crimpFromSchId: bundleData.crimpFromSchId,
                                  crimpToSchId: bundleData.crimpToSchId,
                                  preparationCompleteFlag: bundleData.preparationCompleteFlag,
                                  viCompleted: bundleData.preparationCompleteFlag,
                                  method: "",
                                  processType: "visualInspection"),
                            );
                          });
                        });
                  } else {
                    setState(() {
                      _locationController.text = bundleData.locationId.toString();
                      viIspectionBundleList.add(
                        ViInspectedbundle(
                            locationId: bundleData.locationId.toString(),
                            bundleIdentification: bundleData.bundleIdentification.toString(),
                            binId: bundleData.binId.toString(),
                            employeeid: userId,
                            orderId: bundleData.orderId ?? '',
                            awg: bundleData.awg,
                            fgPart: bundleData.finishedGoodsPart.toString(),
                            scheduleId: bundleData.scheduledId.toString() ?? '',
                            bundleQuantity: bundleData.bundleQuantity,
                            status: "Not Completed",
                            crimpFromSchId: bundleData.crimpFromSchId,
                            crimpToSchId: bundleData.crimpToSchId,
                            preparationCompleteFlag: bundleData.preparationCompleteFlag,
                            viCompleted: bundleData.preparationCompleteFlag,
                            method: "",
                            processType: "visualInspection"),
                      );
                    });
                    Fluttertoast.showToast(
                        msg: "Incomplete Bundle Crimping",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  setState(() {
                    _locationController.text = bundleData.locationId.toString();
                    viIspectionBundleList.add(
                      ViInspectedbundle(
                          locationId: bundleData.locationId.toString(),
                          bundleIdentification: bundleData.bundleIdentification.toString(),
                          binId: bundleData.binId.toString(),
                          employeeid: userId,
                          orderId: bundleData.orderId ?? '',
                          awg: bundleData.awg,
                          fgPart: bundleData.finishedGoodsPart.toString(),
                          scheduleId: bundleData.scheduledId.toString() ?? '',
                          bundleQuantity: bundleData.bundleQuantity,
                          status: "Not Completed",
                          crimpFromSchId: bundleData.crimpFromSchId,
                          crimpToSchId: bundleData.crimpToSchId,
                          preparationCompleteFlag: bundleData.preparationCompleteFlag,
                          viCompleted: bundleData.preparationCompleteFlag,
                          method: "",
                          processType: "visualInspection"),
                    );
                  });
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Bundle already added",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Invalid Bundle Id",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "Invalid user",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        _bundleIdScanController.clear();
        bundleId = '';
      });
    } else {
      Fluttertoast.showToast(
          msg: "Invalid userId and Bundle Id",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  onSubmittedNext() {}

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod(keyboardType);
    });
  }

  int total() {
    int total = int.parse(crimpInslController.text.length > 0 ? crimpInslController.text : '0') +
        int.parse(insulationSlugController.text.length > 0 ? insulationSlugController.text : '0') +
        int.parse(windowgapController.text.length > 0 ? windowgapController.text : '0') +
        int.parse(exposedStrandsController.text.length > 0 ? exposedStrandsController.text : '0') +
        int.parse(burrCutOffController.text.length > 0 ? burrCutOffController.text : '0') +
        int.parse(terminalBendCloseddamageController.text.length > 0 ? terminalBendCloseddamageController.text : '0') +
        int.parse(nickMarkStrandcutController.text.length > 0 ? nickMarkStrandcutController.text : '0') +
        int.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int.parse(frontBelMouthController.text.length > 0 ? frontBelMouthController.text : '0') +
        int.parse(backBellMouthController.text.length > 0 ? backBellMouthController.text : '0') +
        int.parse(insulationCurlingController.text.length > 0 ? insulationCurlingController.text : '0') +
        int.parse(extructionOnBurrController.text.length > 0 ? extructionOnBurrController.text : '0') +
        int.parse(brushLengthController.text.length > 0 ? brushLengthController.text : '0') +
        int.parse(cabledamageController.text.length > 0 ? cabledamageController.text : '0') +
        int.parse(terminalTwistController.text.length > 0 ? terminalTwistController.text : '0');
    return total;
  }

  Widget userScan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) => handleKey(event.data),
                        child: TextField(
                            focusNode: _userScanFocus,
                            controller: _userScanController,
                            onTap: () {
                              SystemChannels.textInput.invokeMethod(keyboardType);
                            },
                            onSubmitted: (value) {
                              setState(() {
                                _bundleIdScanFocus.requestFocus();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                userId = value;
                              });
                            },
                            decoration: new InputDecoration(
                                suffix: _userScanController.text.length > 1
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _userScanController.clear();
                                          });
                                        },
                                        child: Icon(Icons.clear, size: 18, color: Colors.red))
                                    : Container(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                                ),
                                labelText: '  Scan User  ',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 5.0))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget bundleScan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                          focusNode: _bundleIdScanFocus,
                          controller: _bundleIdScanController,
                          onTap: () {
                            SystemChannels.textInput.invokeMethod(keyboardType);
                          },
                          onSubmitted: (value) {
                            addBundletoList();
                            _bundleIdScanFocus.requestFocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              bundleId = value;
                            });
                          },
                          decoration: new InputDecoration(
                              suffix: _bundleIdScanController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _bundleIdScanController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear, size: 18, color: Colors.red))
                                  : Container(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                              ),
                              labelText: '  Scan Bundle ID  ',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget table() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 600,
        width: 600,
        color: Colors.transparent,
        child: Column(
          children: [
            DataTable(
              columnSpacing: 40,
              columns: [
                DataColumn(
                  label: Text(
                    'Employee ID',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Bundle ID',
                  style: TextStyle(fontSize: 12),
                )),
                DataColumn(
                  label: Text(
                    'BIN ID',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                    label: Text(
                  '',
                  style: TextStyle(fontSize: 12),
                ))
              ],
              rows: viIspectionBundleList
                  .map(
                    (e) => DataRow(cells: <DataCell>[
                      DataCell(Text(
                        "${e.employeeid}",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        "${e.bundleIdentification}",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        e.binId ?? '-',
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        e.status ?? "",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(e.status == 'completed'
                          ? Text("-")
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedindex = viIspectionBundleList.indexOf(e);
                                  status = Status.rejCase;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                primary: Colors.green, // background
                                onPrimary: Colors.white,
                              ),
                              child: Text('Process'),
                            )),
                    ]),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget vitable(int selectedindex) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Row(
                          children: [
                            feild(heading: "User Id", value: "${viIspectionBundleList[selectedindex].employeeid}", width: 0.15),
                            feild(heading: "Bundle Id", value: "${viIspectionBundleList[selectedindex].bundleIdentification}", width: 0.15),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('  Reason For Rejection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              quantitycell(
                                name: "Crimp Insulation",
                                quantity: 10,
                                textEditingController: crimpInslController,
                              ),
                              quantitycell(
                                name: "Insulation Slug",
                                quantity: 10,
                                textEditingController: insulationSlugController,
                              ),
                              quantitycell(
                                name: "Window Gap",
                                quantity: 10,
                                textEditingController: windowgapController,
                              ),
                              quantitycell(
                                name: "Exposed Strands",
                                quantity: 10,
                                textEditingController: exposedStrandsController,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              quantitycell(
                                name: "Burr / Cut Off",
                                quantity: 10,
                                textEditingController: burrCutOffController,
                              ),
                              quantitycell(
                                name: "Terminal Bend / Closed / Damage",
                                quantity: 10,
                                textEditingController: terminalBendCloseddamageController,
                              ),
                              quantitycell(
                                name: "Insulation Curling / Half Curling",
                                quantity: 10,
                                textEditingController: insulationCurlingController,
                              ),
                              quantitycell(
                                name: "Nick Mark / Strands Cut",
                                quantity: 10,
                                textEditingController: nickMarkStrandcutController,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              quantitycell(
                                name: "Seam Open",
                                quantity: 10,
                                textEditingController: seamOpenController,
                              ),
                              quantitycell(
                                name: "Miss Crimp",
                                quantity: 10,
                                textEditingController: missCrimpController,
                              ),
                              quantitycell(
                                name: "Front Bell Mouth",
                                quantity: 10,
                                textEditingController: frontBelMouthController,
                              ),
                              quantitycell(
                                name: "Back Bell Mouth",
                                quantity: 10,
                                textEditingController: backBellMouthController,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              quantitycell(
                                name: "Extrusion on Burr",
                                quantity: 10,
                                textEditingController: extructionOnBurrController,
                              ),
                              quantitycell(
                                name: "Brush Length",
                                quantity: 10,
                                textEditingController: brushLengthController,
                              ),
                              quantitycell(
                                name: "Cable Damage",
                                quantity: 10,
                                textEditingController: cabledamageController,
                              ),
                              quantitycell(
                                name: "Terminal Twist",
                                quantity: 10,
                                textEditingController: terminalTwistController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("Bundle Qty:   "),
                            Text(
                              viIspectionBundleList[selectedindex].bundleQuantity.toString() ?? "0",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ]),
                          SizedBox(width: 40),
                          Row(
                            children: [
                              Text("Rejected Qty:   "),
                              Text(
                                rejectedQtyController.text.length == 0 ? "0" : rejectedQtyController.text,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                              return Colors.green.shade500; // Use the component's default.
                                            },
                                          ),
                                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed)) return Colors.green;
                                              return Colors.green.shade500; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ))
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                              return Colors.green.shade500; // Use the component's default.
                                            },
                                          ),
                                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed)) return Colors.green;
                                              return Colors.green.shade500; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          if (int.parse(rejectedQtyController.text.length == 0 ? "0" : rejectedQtyController.text) <=
                                              int.parse(viIspectionBundleList[selectedindex].bundleQuantity.toString() ?? "0")) {
                                            setState(() {
                                              loading = true;
                                            });

                                            apiService.postVIinspectedBundle(viInspectedbudle: getVisualInspectedBundle()).then((value) {
                                              log("Visual inp : ${viIspectionBundleList[selectedindex].bundleQuantity}");
                                              if (value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Inspected data uploaded",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);

                                                setState(() {
                                                  status = Status.binScan;
                                                });
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });
                                              }
                                              setState(() {
                                                loading = false;
                                              });
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Rejected Qty Greater than Bundle Qty",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Save & Scan Next'),
                                        ),
                                      ),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              KeyPad(
                  controller: maincontroller,
                  buttonPressed: (buttonText) {
                    setState(() {
                      rejectedQtyController.text = total().toString();
                    });
                    if (buttonText == 'X') {
                      _output = '';
                    } else {
                      _output = _output + buttonText;
                    }

                    print(_output);
                    setState(() {
                      maincontroller.text = _output;
                      setState(() {
                        rejectedQtyController.text = total().toString();
                      });
                      // output = int.parse(_output).toStringAsFixed(2);
                    });
                  })
            ],
          ),
        ));
  }

  ViInspectedbundle getVisualInspectedBundle() {
    //rejection cases
    viIspectionBundleList[selectedindex].backBellMouth = int.parse(backBellMouthController.text == '' ? "0" : backBellMouthController.text);
    viIspectionBundleList[selectedindex].brushLength = int.parse(brushLengthController.text == '' ? "0" : brushLengthController.text);
    viIspectionBundleList[selectedindex].crimpInslation = int.parse(crimpInslController.text == '' ? "0" : crimpInslController.text);
    viIspectionBundleList[selectedindex].burrOrCutOff = int.parse(burrCutOffController.text == '' ? "0" : burrCutOffController.text);
    viIspectionBundleList[selectedindex].seamOpen = int.parse(seamOpenController.text == '' ? "0" : seamOpenController.text);
    viIspectionBundleList[selectedindex].insulationSlug = int.parse(insulationSlugController.text == '' ? "0" : insulationSlugController.text);
    viIspectionBundleList[selectedindex].terminalBendOrClosedOrDamage =
        int.parse(terminalBendCloseddamageController.text == '' ? "0" : terminalBendCloseddamageController.text);
    viIspectionBundleList[selectedindex].extrusionOnBurr = int.parse(extructionOnBurrController.text == '' ? "0" : extructionOnBurrController.text);
    viIspectionBundleList[selectedindex].frontBellMouth = int.parse(frontBelMouthController.text == '' ? "0" : frontBelMouthController.text);

    viIspectionBundleList[selectedindex].missCrimp = int.parse(missCrimpController.text == '' ? "0" : missCrimpController.text);
    viIspectionBundleList[selectedindex].brushLength = int.parse(brushLengthController.text == '' ? "0" : brushLengthController.text);
    viIspectionBundleList[selectedindex].windowGap = int.parse(windowgapController.text == '' ? "0" : windowgapController.text);
    viIspectionBundleList[selectedindex].cableDamage = int.parse(cabledamageController.text == '' ? "0" : cabledamageController.text);
    viIspectionBundleList[selectedindex].exposedStrands = int.parse(exposedStrandsController.text == '' ? "0" : exposedStrandsController.text);
    viIspectionBundleList[selectedindex].backBellMouth = int.parse(backBellMouthController.text == '' ? "0" : backBellMouthController.text);
    viIspectionBundleList[selectedindex].terminalTwist = int.parse(terminalTwistController.text == '' ? "0" : terminalTwistController.text);
    viIspectionBundleList[selectedindex].rejectedQuantity = int.parse(rejectedQtyController.text == '' ? "0" : rejectedQtyController.text);
    viIspectionBundleList[selectedindex].passedQuantity =
        (viIspectionBundleList[selectedindex].bundleQuantity! - int.parse(rejectedQtyController.text == '' ? "0" : rejectedQtyController.text))!;
    viIspectionBundleList[selectedindex].status = "completed";
    viIspectionBundleList[selectedindex].viCompleted = "1";
    return viIspectionBundleList[selectedindex];
  }

  Widget quantity(String title, int quantity, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.15 * 0.4,
              child: Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  )),
            ),
            Container(
              height: 30,
              width: 70,
              child: TextField(
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                controller: textEditingController,
                onTap: () {
                  SystemChannels.textInput.invokeMethod(keyboardType);
                  setState(() {
                    _output = '';
                    maincontroller = textEditingController;
                  });
                },
                decoration: new InputDecoration(
                  labelText: "Qty",
                  fillColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 10),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),

                //fillColor: Colors.green
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell({
    required String name,
    required int quantity,
    required TextEditingController textEditingController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 40,
                width: 160,
                child: TextField(
                  showCursor: false,
                  controller: textEditingController,
                  readOnly: true,
                  onTap: () {
                    SystemChannels.textInput.invokeMethod(keyboardType);
                    setState(() {
                      _output = '';
                      maincontroller = textEditingController;
                    });
                  },
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: fonts.openSans,
                  ),
                  decoration: new InputDecoration(
                    labelText: name,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ))
          ],
        ),
      ),
    );
  }

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
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget binScan(int selectedindex) {
    SystemChannels.textInput.invokeMethod(keyboardType);
    return Padding(
      padding: const EdgeInsets.all(108.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 250,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) => handleKey(event.data),
                    child: TextField(
                        controller: _binController,
                        onSubmitted: (value) {
                          // _bundleFocus.requestFocus();
                          Future.delayed(
                            const Duration(milliseconds: 50),
                            () {
                              SystemChannels.textInput.invokeMethod(keyboardType);
                            },
                          );
                        },
                        onTap: () {
                          SystemChannels.textInput.invokeMethod(keyboardType);

                          _binController.clear();
                          setState(() {});
                        },
                        onChanged: (value) {
                          setState(() {
                            binId = value;
                          });
                        },
                        decoration: new InputDecoration(
                            suffix: _binController.text.length > 1
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _binController.clear();
                                          });
                                        },
                                        child: Icon(Icons.clear, size: 18, color: Colors.red)),
                                  )
                                : Container(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                            ),
                            labelText: 'Scan bin',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0))),
                  ),
                ),
              ),
            ),
            //Scan Location

            //Scan Bin Button
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  child: loadingBin
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: Colors.red, // background
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: Colors.red, // background
                            onPrimary: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'Save & Scan Next',
                            ),
                          ),
                          onPressed: () {
                            if (_binController.text.length > 0 && _locationController.text.length > 0) {
                              setState(() {
                                loadingBin = true;
                                clear();

                                viIspectionBundleList[selectedindex].binId = "${_binController.text}";
                              });
                              apiService.postTransferBundletoBin(transferBundleToBin: [
                                TransferBundleToBin(
                                  binIdentification: _binController.text,
                                  userId: widget.employee.empId,
                                  bundleId: viIspectionBundleList[selectedindex].bundleIdentification ?? '',
                                  locationId: _locationController.text == '' ? "" : _locationController.text,
                                )
                              ]).then((value) {
                                if (value != null) {
                                  BundleTransferToBin bundleTransferToBinTracking = value[0];
                                  Fluttertoast.showToast(
                                      msg:
                                          "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() {
                                    loadingBin = false;
                                    // viIspectionBundleList.remove(
                                    //     viIspectionBundleList[selectedindex]);
                                    status = Status.dash;
                                  });
                                  scanBundleController.clear();
                                  userScanController.clear();
                                  _binController.clear();
                                } else {
                                  setState(() {
                                    loadingBin = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Unable to Transfer bundle",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });

                              Future.delayed(
                                const Duration(milliseconds: 50),
                                () {
                                  SystemChannels.textInput.invokeMethod(keyboardType);
                                },
                              );
                            } else {
                              if (_binController.text.length <= 0) {
                                Fluttertoast.showToast(
                                    msg: "Scan Bin to Transfer",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              if (_locationController.text.length <= 0) {
                                Fluttertoast.showToast(
                                    msg: "Scan Location to Transfer",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          })),
            ),
          ],
        ),
      ),
    );
  }

  void clear() {
    crimpInslController.clear();
    insulationSlugController.clear();
    windowgapController.clear();
    exposedStrandsController.clear();
    burrCutOffController.clear();
    terminalBendCloseddamageController.clear();
    insulationCurlingController.clear();
    nickMarkStrandcutController.clear();
    seamOpenController.clear();
    missCrimpController.clear();
    frontBelMouthController.clear();
    backBellMouthController.clear();
    extructionOnBurrController.clear();
    brushLengthController.clear();
    cabledamageController.clear();
    terminalTwistController.clear();
    rejectedQtyController.clear();
  }
}
// // getMaterialTrackingCableDetail post body details {"machineId":"EMU-m/c-006D","schedulerId":"80118","cablePartNumbers":["191150046","191150046"]}
// {"bundleIdentification":"2000171","bundleQuantity":0,"passedQuantity":0,"rejectedQuantity":1,"crimpInslation":0,"insulationSlug":0,"windowGap":0,"exposedStrands":0,"burrOrCutOff":0,"terminalBendORClosedORDamage":0,"seamOpen":0,"missCrimp":0,"frontBellMouth":0,"backBellMouth":1,"extrusionOnBurr":0,"brushLength":0,"cableDamage":0,"terminalTwist":0,"orderId":"846714504","fgPart":"369100004","scheduleId":"80050","binId":"123456","awg":"20"}
