import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex/screens/utils/loadingButton.dart';
import '../../../model_api/Transfer/binToLocation_model.dart';
import '../../../model_api/Transfer/postgetBundleMaster.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../model_api/process1/getBundleListGl.dart';
import '../../widgets/alertDialog/alertDialogCrimping.dart';
import '../../widgets/alertDialog/alertDialogVI.dart';
import '../../widgets/showBundleDetail.dart';
import '../../widgets/showBundles.dart';
import '../../widgets/timer.dart';
import '../../../main.dart';
import '../../../model_api/Transfer/bundleToBin_model.dart';
import '../../../model_api/cableTerminalA_model.dart';
import '../../../model_api/cableTerminalB_model.dart';
import '../../../model_api/crimping/bundleDetail.dart';
import '../../../model_api/crimping/getCrimpingSchedule.dart';
import '../../../model_api/crimping/postCrimprejectedDetail.dart';
import '../../operator/process/materialTableWIP.dart';
import '../../widgets/keypad.dart';
import '../../../service/apiService.dart';
import 'package:visibility_detector/visibility_detector.dart';
// 3008
// 3009
//

enum Status {
  scan,
  rejection,
  showbundle,
  scanBin,
  bundleDetail,
}

class ScanBundle extends StatefulWidget {
  String userId;
  String machineId;
  String method;
  MatTrkPostDetail matTrkPostDetail;
  @required
  CrimpingSchedule schedule;
  Function updateQty;
  Function fullyComplete;
  Function partiallyComplete;
  int totalQuantity;
  Function reload;
  Function transfer;
  bool processStarted;
  String processName;
  Function startProcess;
  ScanBundle(
      {required this.machineId,
      required this.method,
      required this.userId,
      required this.schedule,
      required this.totalQuantity,
      required this.fullyComplete,
      required this.updateQty,
      required this.processStarted,
      required this.processName,
      required this.startProcess,
      required this.reload,
      required this.transfer,
      required this.partiallyComplete,
      required this.matTrkPostDetail});
  @override
  _ScanBundleState createState() => _ScanBundleState();
}

class _ScanBundleState extends State<ScanBundle> {
  TextEditingController mainController = new TextEditingController();
  TextEditingController endwireController = new TextEditingController();
  TextEditingController endTerminalControllerFrom = new TextEditingController();
  TextEditingController endTerminalControllerTo = new TextEditingController();
  TextEditingController setUpRejectionControllerCable =
      new TextEditingController();
  TextEditingController setUpRejectionControllerTo =
      new TextEditingController();
  TextEditingController setUpRejectionControllerFrom =
      new TextEditingController();
  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController =
      new TextEditingController();
  TextEditingController bellMouthErrorController = new TextEditingController();
  TextEditingController cutoffBurrController = new TextEditingController();
  TextEditingController exposureStrands = new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessMoreController =
      new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();

  TextEditingController lockingTabOpenController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();

  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();
  //Quantity
  TextEditingController rejectedQtyController = new TextEditingController();
  TextEditingController bundlQtyController = new TextEditingController();
  FocusNode _scanfocus = new FocusNode();
  TextEditingController _scanIdController = new TextEditingController();
  bool next = false;
  bool showTable = false;
  List<BundlesRetrieved> bundleList = [];
  Status status = Status.scan;

  String _output = '';

  TextEditingController _binController = new TextEditingController();

  bool? hasBin;
  bool loading = false;
  BundlesRetrieved? scannedBundle;
  bool checkmappingdone = false;
  bool donotrepeatalert = false;
  bool visibility = true;
  bool scanbundleLoading = false;

  String? binId;
  //to store the bundle Quantity fetched from api after scanning bundle Id
  String bundleQty = '';
  ApiService apiService = new ApiService();
  late CableTerminalA? terminalA;
  late CableTerminalB? terminalB;
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: "${widget.schedule.finishedGoods}",
            cablepartno: widget.schedule.cablePartNo.toString(),
            length: "${widget.schedule.length}",
            color: widget.schedule.wireColour,
            awg: int.parse(widget.schedule.awg))
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: "${widget.schedule.finishedGoods}",
              cablepartno: widget.schedule.cablePartNo.toString(),
              length: "${widget.schedule.length}",
              color: widget.schedule.wireColour,
              awg: int.parse(widget.schedule.awg))
          .then((termiB) {
        setState(() {
          terminalA = termiA;
          terminalB = termiB;
        });
      });
    });
  }

  @override
  void initState() {
    status = Status.scan;
    apiService = new ApiService();
    getTerminal();
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  //8765902
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Container(
            child: topSection(),
          ),
          Material(
            elevation: 5,
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.transparent)),
            child: Container(
              height: 241,
              child: Row(
                children: [
                  VisibilityDetector(
                      key: Key("unique key"),
                      onVisibilityChanged: (VisibilityInfo info) {
                        setState(() {
                          visibility = info.visibleFraction > 0 ? true : false;
                        });
                        debugPrint(
                            "${info.visibleFraction} of my widget is visible");
                      },
                      child: main(status)),
                  KeyPad(
                    controller: mainController,
                    buttonPressed: (String buttonText) {
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
                        mainController.text = _output;
                        setState(() {
                          rejectedQtyController.text = total().toString();
                        });
                        // output = int.parse(_output).toStringAsFixed(2);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget main(Status status) {
    visibility ? SystemChannels.textInput.invokeMethod('TextInput.hide') : null;
    switch (status) {
      case Status.scan:
        return scanBundlePop();
        break;

      case Status.rejection:
        return rejectioncase();
        break;
      case Status.scanBin:
        return binScan();
        break;
      default:
        return Container();
    }
  }

  Widget topSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MaterialtableWIP(
            matTrkPostDetail: widget.matTrkPostDetail,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.64,
            child: Material(
              elevation: 2,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.transparent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showBundleButton(),
                  quantityDisp(),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ProcessTimer(
                        startTime: DateTime.now(),
                        endTime: widget.schedule.shiftEnd),
                  ),

                  //buttons and num pad
                  Container(
                    // width: 350,
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //100% complete
                            widget.totalQuantity >=
                                    int.parse(widget.schedule.schdeuleQuantity)
                                ? Container(
                                    height: 40,
                                    width: 160,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                    color:
                                                        Colors.transparent))),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green.shade200;
                                            return Colors.green
                                                .shade500; // Use the component's default.
                                          },
                                        ),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green;
                                            return Colors.green
                                                .shade500; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        checkMapping().then((value) {
                                          if (value) {
                                            widget.fullyComplete();
                                          }
                                        });
                                      },
                                      child: Text(
                                        "100% complete",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            widget.totalQuantity !=
                                    int.parse(widget.schedule.schdeuleQuantity)
                                ? Container(
                                    height: 40,
                                    width: 160,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                    color: Colors.green))),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green.shade200;
                                            return Colors
                                                .white; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        checkMapping().then((value) {
                                          if (value) {
                                            widget.partiallyComplete();
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Partially  complete",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.green),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showBundleButton() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: BorderSide(color: Colors.red),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Colors.red.shade200;
            return Colors.red.shade500; // Use the component's default.
          },
        ),
      ),
      onPressed: () {
        showBundles();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Bundles"),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Future<List<BundleData>?> getBundlesCrimping() async {
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      binId: 0,
      scheduleId: 0,
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: widget.schedule.finishedGoods,
      cablePartNumber: widget.schedule.cablePartNo,
      orderId: widget.schedule.purchaseOrder.toString(),
    );

    apiService
        .getBundlesInSchedule(
            postgetBundleMaster: postgetBundleMaste,
            scheduleID: widget.schedule.scheduleId.toString())
        .then((value) {
      List<BundlesRetrieved> totalbundleList = value!;
      if (totalbundleList.length > 0) {
        totalbundleList = totalbundleList.where((element) {
          if ("${element.cutLengthSpecificationInmm}" ==
                  "${widget.schedule.length}" &&
              "${element.color}" == "${widget.schedule.wireColour}" &&
              "${element.orderId}" == "${widget.schedule.purchaseOrder}") {
            return true;
          } else {
            return false;
          }
        }).toList();
        log("message $totalbundleList");
        return totalbundleList;
      } else {
        return [];
      }
    });
  }

  Future<void> showBundles() {
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      binId: 0,
      scheduleId: 0,
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: widget.schedule.finishedGoods,
      cablePartNumber: widget.schedule.cablePartNo,
      orderId: widget.schedule.purchaseOrder.toString(),
    );

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            title: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.white,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: FutureBuilder(
                        future: apiService.getBundlesInSchedule(
                            postgetBundleMaster: postgetBundleMaste,
                            scheduleID: ""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<BundlesRetrieved>? totalbundleList =
                                snapshot.data as List<BundlesRetrieved>?;
                            totalbundleList = totalbundleList!.where((element) {
                              if ("${element.cutLengthSpecificationInmm}" ==
                                      "${widget.schedule.length}" &&
                                  "${element.color}" ==
                                      "${widget.schedule.wireColour}" &&
                                  "${element.orderId}" ==
                                      "${widget.schedule.purchaseOrder}") {
                                return true;
                              } else {
                                return false;
                              }
                            }).toList();
                            log("message $totalbundleList");
                            return Container(
                              child: CustomTable(
                                height: 500,
                                width: 650,
                                colums: [
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Bundle ID',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fonts.openSans,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Bin ID',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fonts.openSans,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Location ID',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fonts.openSans,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fonts.openSans,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'info',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fonts.openSans,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: totalbundleList
                                    .map((e) => CustomRow(
                                            completed: e.updateFromProcess
                                                .toLowerCase()
                                                .contains(widget.processName
                                                    .toLowerCase()),
                                            cells: [
                                              CustomCell(
                                                width: 100,
                                                child: Text(
                                                  e.bundleIdentification,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    // color: !e
                                                    //         .updateFromProcess
                                                    //         .contains(widget
                                                    //             .processName,
                                                    //             )
                                                    //     ? Colors.red
                                                    //     : Colors.green
                                                  ),
                                                ),
                                              ),
                                              CustomCell(
                                                width: 100,
                                                color: e.binId == null
                                                    ? Colors.red.shade100
                                                    : Colors.transparent,
                                                child: Text(
                                                  "${e.binId}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              CustomCell(
                                                width: 100,
                                                color: e.locationId == null
                                                    ? Colors.red.shade100
                                                    : Colors.transparent,
                                                child: Text(
                                                  e.locationId,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              CustomCell(
                                                width: 100,
                                                child: Text(
                                                  "${e.bundleQuantity}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              CustomCell(
                                                width: 100,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      showBundleDetail(e);
                                                    },
                                                    child: Icon(
                                                      Icons.info_outline,
                                                      color: Colors.blue,
                                                    )),
                                              )
                                            ]))
                                    .toList(),
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context2);
                          },
                          icon:
                              Icon(Icons.close, size: 20, color: Colors.red))),
                ],
              ),
            ),
          );
        });
  }

  String getProcessType(String process) {
    if (widget.method.contains("a")) {
      process = process + ",crimp from";
    }
    if (widget.method.contains("c")) {
      process = process + "cutlength";
    }
    if (widget.method.contains("b")) {
      process = process + ",Crimp to";
    }
    return process;
  }

  Future<bool> checkMapping() async {
    if (!checkmappingdone) {
      showMappingAlert();
      setState(() {
        checkmappingdone = true;
      });
      return false;
    }

    return true;
  }

  Future<void> showMappingAlert() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(0),
            // titlePadding: EdgeInsets.all(0),
            title: Text(
              "Incomplete Bundle Mapping",
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Map all bundles to Bin and Location to Complete Schedule"),
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
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.transparent))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green.shade200;
                                  return Colors.green
                                      .shade400; // Use the component's default.
                                },
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green;
                                  return Colors.green
                                      .shade500; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context2);
                              widget.reload();
                              widget.transfer();
                            },
                            child: Text("Map Bin & Location")),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget field({required String title, required String data}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$title",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$data",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> showBundleDetail(BundlesRetrieved bundlesRetrieved) async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context1) {
        return Center(
          child: AlertDialog(
            title: Container(
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context1);
                          },
                          icon: Icon(Icons.close),
                          color: Colors.red)),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Bundle Detail"),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  field(
                                      title: "Bundle ID",
                                      data: bundlesRetrieved
                                          .bundleIdentification),
                                  field(
                                      title: "Bundle Qty",
                                      data: bundlesRetrieved.bundleQuantity
                                          .toString()),
                                  field(
                                      title: "Bundle Status",
                                      data: "${bundlesRetrieved.bundleStatus}"),
                                  field(
                                      title: "Cut Length",
                                      data:
                                          "${bundlesRetrieved.cutLengthSpecificationInmm}"),
                                  field(
                                      title: "Color",
                                      data: "${bundlesRetrieved.color}"),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                      title: "Cable Part Number",
                                      data: bundlesRetrieved.cablePartNumber
                                          .toString()),
                                  field(
                                    title: "Cable part Description",
                                    data:
                                        "${bundlesRetrieved.cablePartDescription}",
                                  ),
                                  field(
                                      title: "Finished Goods",
                                      data:
                                          "${bundlesRetrieved.finishedGoodsPart}"),
                                  field(
                                    title: "Order Id",
                                    data:
                                        "${bundlesRetrieved.operatorIdentification}",
                                  ),
                                  field(
                                      title: "Update From",
                                      data:
                                          "${bundlesRetrieved.updateFromProcess}"),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                    title: "Machine Id",
                                    data: widget.machineId,
                                  ),
                                  field(
                                    title: "Schedule ID",
                                    data:
                                        bundlesRetrieved.scheduledId.toString(),
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: bundlesRetrieved.finishedGoodsPart
                                        .toString(),
                                  ),
                                  field(
                                    title: "Bin Id",
                                    data: bundlesRetrieved.binId.toString(),
                                  ),
                                  field(
                                    title: "Location Id",
                                    data: bundlesRetrieved.locationId,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget scanBundlePop() {
    // Future.delayed(
    //   const Duration(milliseconds: 50),
    //   () {
    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   },
    // );
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 100,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 200,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          });
                        },
                        controller: _scanIdController,
                        onChanged: (value) {
                          setState(() {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          });
                        },
                        onSubmitted: (value) {
                          getScannedBundle();
                        },
                        autofocus: true,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 14),
                        decoration: new InputDecoration(
                          suffix: _scanIdController.text.length > 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _scanIdController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red)),
                                )
                              : Container(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3),
                          labelText: "Scan Bundle",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       updateLocationtoempty("678678");
                  //     },
                  //     child: Text("")),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 200,
                            child: LoadingButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(color: Colors.red))),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.red.shade900;
                                      return Colors
                                          .red; // Use the component's default.
                                    },
                                  ),
                                ),
                                child: Text('Scan Bundle  '),
                                loading: false,
                                loadingChild: Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                                onPressed: () {
                                  getScannedBundle();
                                }))
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  getScannedBundle() {
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      scheduleId: 0,
      binId: 0,
      bundleId: _scanIdController.text,
      location: '',
      status: '',
      finishedGoods: 0,
      cablePartNumber: 0,
      orderId: "",
    );

    if (_scanIdController.text.length > 0) {
      apiService
          .getBundlesInSchedule(
              postgetBundleMaster: postgetBundleMaste, scheduleID: "")
          .then((value) {
        List<BundlesRetrieved> bundleList = value!;
        BundlesRetrieved bundleDetail = bundleList[0];

        if (value != null) {
          if ((widget.totalQuantity + bundleDetail.bundleQuantity) >
              int.parse(widget.schedule.schdeuleQuantity)) {
                setState(() {
                  
                });
            Fluttertoast.showToast(
                msg: "Total Quantity Exceeds Schedule Qty",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return true;
          } else {
            if (validateBundle(bundleDetail)) {
              if (bundleDetail.bundleStatus.toLowerCase() == "dropped") {
                setState(() {
                  scannedBundle = bundleDetail;
                  clear();
                  bundleQty = "${bundleDetail.bundleQuantity}";
                  bundlQtyController.text = "${bundleDetail.bundleQuantity}";
                  next = !next;
                  status = Status.rejection;
                });
              } else {
                if (!donotrepeatalert) {
                  showBundleAlertCrimping(
                      context: context,
                      bundleStaus: bundleDetail.bundleStatus,
                      onDoNotRemindAgain: (value) {
                        setState(() {
                          donotrepeatalert = value;
                          log("message donotrepeatalert $donotrepeatalert");
                        });
                      },
                      onSubmitted: () {
                        setState(() {
                          scannedBundle = bundleDetail;
                          clear();
                          bundleQty = "${bundleDetail.bundleQuantity}";
                          bundlQtyController.text =
                              "${bundleDetail.bundleQuantity}";
                          next = !next;
                          status = Status.rejection;
                        });
                      });
                } else {
                  setState(() {
                    scannedBundle = bundleDetail;
                    clear();
                    bundleQty = "${bundleDetail.bundleQuantity}";
                    bundlQtyController.text = "${bundleDetail.bundleQuantity}";
                    next = !next;
                    status = Status.rejection;
                  });
                }
              }
            }
          }
        } else {
          setState(() {
            _scanIdController.clear();
          });
        }
      });
    }
  }

  /// to validate the bundle and check wheather it is peresent in same fg
  bool validateBundle(BundlesRetrieved bundleDetail) {
    bool checkCrimping(
      String crimpfrom,
      String crimpto,
    ) {
      log("message1");
      if (widget.processName == "Crimp From" &&
          (crimpfrom == null || crimpfrom.length <= 1)) {
        return true;
      }
      if (widget.processName == "Crimp To" &&
          (crimpto == null || crimpto.length <= 1)) {
        log("message1");

        return true;
      }
      // ignore: null_aware_before_operator
      if (widget.processName == "Crimp From & To" &&
          (crimpto == null || crimpto.length <= 1) &&
          (crimpto == null || crimpto.length <= 1)) {
        return true;
      }
      return false;
    }

    if ("${bundleDetail.finishedGoodsPart}" ==
            "${widget.schedule.finishedGoods}" &&
        "${bundleDetail.cablePartNumber}" == "${widget.schedule.cablePartNo}" &&
        "${bundleDetail.cutLengthSpecificationInmm}" ==
            "${widget.schedule.length}" &&
        "${bundleDetail.color}" == "${widget.schedule.wireColour}" &&
        "${bundleDetail.orderId}" == "${widget.schedule.purchaseOrder}") {
      // ignore: null_aware_in_logical_operator
      if (!bundleDetail.updateFromProcess
              .toLowerCase()
              .contains(widget.processName.toLowerCase()) &&
          checkCrimping(
              bundleDetail.crimpFromSchId, bundleDetail.crimpToSchId)) {
        return true;
      }
      Fluttertoast.showToast(
          msg: "Bundle terminal does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    Fluttertoast.showToast(
        msg: "Bundle does not match FG Detials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }

  handleKey(RawKeyEventData key) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget rejectioncase() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // Future.delayed(
    //   const Duration(milliseconds: 50),
    //   () {
    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   },
    // );
    return Container(
      width: MediaQuery.of(context).size.width * 0.74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.88,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Crimping Rejection Cases',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            )),
                        Text('Bundle Id : ${_scanIdController.text ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          doubleQuantityCell(
                            name: "End Termianl	",
                            textEditingControllerFrom:
                                endTerminalControllerFrom,
                            textEditingControllerTo: endTerminalControllerTo,
                          ),
                          tripleQuantityCell(
                            name: "Setup Rejections	",
                            textEditingControllerFrom:
                                setUpRejectionControllerFrom,
                            textEditingControllerCable:
                                setUpRejectionControllerCable,
                            textEditingControllerTo: setUpRejectionControllerTo,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "End Wire",
                            textEditingController: endwireController,
                          ),
                          quantitycell(
                            name: "Terminal Damage",
                            textEditingController: terminalDamageController,
                          ),
                          quantitycell(
                            name: "Terminal Bend",
                            textEditingController: terminalBendController,
                          ),
                          quantitycell(
                            name: "Terminal Twist",
                            textEditingController: terminalTwistController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Window Gap",
                            textEditingController: windowGapController,
                          ),
                          quantitycell(
                            name: "Crimp On Insulation",
                            textEditingController: crimpOnInsulationController,
                          ),
                          quantitycell(
                            name: "Bellmouth Error",
                            textEditingController: bellMouthErrorController,
                          ),
                          quantitycell(
                            name: "Cutt oFf Burr",
                            textEditingController: cutoffBurrController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Exposure Strands",
                            textEditingController: exposureStrands,
                          ),
                          quantitycell(
                            name: "Nick Mark",
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "Strands Cut",
                            textEditingController: strandsCutController,
                          ),
                          quantitycell(
                            name: "Brush Length Less/More",
                            textEditingController:
                                brushLengthLessMoreController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                              name: "Cable Damage",
                              textEditingController: cableDamageController),
                          quantitycell(
                            name: "Half Curling	",
                            textEditingController: halfCurlingController,
                          ),
                          quantitycell(
                            name: "Locking Tab Open/Close	",
                            textEditingController: lockingTabOpenController,
                          ),
                          quantitycell(
                            name: "Wrong Terminal	",
                            textEditingController: wrongTerminalController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Seam Open",
                            textEditingController: seamOpenController,
                          ),
                          quantitycell(
                            name: "Miss Crimp",
                            textEditingController: missCrimpController,
                          ),
                          quantitycell(
                            name: "Extrusion Burr",
                            textEditingController: extrusionBurrController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    Text("Bundle Qty:   "),
                    Text(
                      bundlQtyController.text ?? "0",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ]),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Text("Rejected Qty:   "),
                      Text(
                        rejectedQtyController.text ?? "0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),

                  // quantitycell(
                  //   name: "Bundle Qty",
                  //
                  //   textEditingController: bundlQtyController,
                  // ),
                  // quantitycell(
                  //   name: "Rejected Qty",
                  //
                  //   textEditingController: rejectedQtyController,
                  // ),
                  // binScan(),
                  SizedBox(width: 30),
                  Container(
                    height: 48,
                    child: Center(
                      child: Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side:
                                              BorderSide(color: Colors.green))),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.white;
                                      return Colors
                                          .white; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  Future.delayed(
                                    const Duration(milliseconds: 50),
                                    () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    },
                                  );
                                  setState(() {
                                    status = Status.scan;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.keyboard_arrow_left,
                                        color: Colors.green),
                                    Text(
                                      "Back",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                )),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green.shade200;
                                    return Colors.green
                                        .shade500; // Use the component's default.
                                  },
                                ),
                              ),
                              child: loading
                                  ? Container(
                                      height: 28,
                                      width: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text("Save & Scan Next"),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  },
                                );

                                apiService
                                    .postCrimpRejectedQty(
                                        getPostCrimpingRejectDetail())
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      loading = false;
                                    });
                                    setState(() {
                                      widget.updateQty(widget.totalQuantity +
                                          int.parse(bundleQty));

                                      Future.delayed(
                                          const Duration(milliseconds: 10), () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                      });
                                      status = Status.scanBin;
                                    });

                                    Fluttertoast.showToast(
                                      msg: "Saved Crimping Detail ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityDisp() {
    double percent =
        widget.totalQuantity / int.parse(widget.schedule.schdeuleQuantity);
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Quantity",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ))
          ],
        ),
        Stack(
          children: [
            Container(
              height: 60,
              width: 60,
              child: Center(
                  child: Text(
                "${(percent * 100).round()}%",
                style: TextStyle(
                    color: percent >= 0.9 ? Colors.green : Colors.red),
              )),
            ),
            Container(
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  value: percent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      percent >= 0.9 ? Colors.greenAccent : Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
        Text("${widget.totalQuantity}/${widget.schedule.schdeuleQuantity}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            )),
      ],
    ));
  }

  PostCrimpingRejectedDetail getPostCrimpingRejectDetail() {
    return PostCrimpingRejectedDetail(
      bundleIdentification: _scanIdController.text,
      finishedGoods: widget.schedule.finishedGoods,
      cutLength: widget.schedule.length,
      color: widget.schedule.wireColour,
      cablePartNumber: widget.schedule.cablePartNo,
      processType: getProcessType(scannedBundle!.updateFromProcess),
      method: "${widget.method}",
      crimpFromSchId:
          widget.method.contains("a") ? "${widget.schedule.scheduleId}" : "",
      crimpToSchId:
          widget.method.contains("b") ? "${widget.schedule.scheduleId}" : "",
      viCompleted: "0",
      preparationCompleteFlag: "0",

      status: "",

      machineIdentification: widget.machineId,
      binId: "",
      bundleQuantity: int.parse(bundleQty ?? '0'),
      passedQuantity: int.parse(bundleQty ?? '0') - total(),
      rejectedQuantity: total(),
      endWire: int.parse(
          endwireController.text.length > 0 ? endwireController.text : "0"),
      rejectionsTerminalFrom: int.parse(
          endTerminalControllerFrom.text.length > 0
              ? endTerminalControllerTo.text
              : "0"),
      rejectionsTerminalTo: int.parse(endTerminalControllerTo.text.length > 0
          ? endTerminalControllerTo.text
          : "0"),
      setUpRejectionTerminalFrom: int.parse(
          setUpRejectionControllerFrom.text.length > 0
              ? setUpRejectionControllerFrom.text
              : '0'),
      setUpRejections: int.parse(setUpRejectionControllerCable.text.length > 0
          ? setUpRejectionControllerCable.text
          : '0'),
      setUpRejectionTerminalTo: int.parse(
          setUpRejectionControllerTo.text.length > 0
              ? setUpRejectionControllerTo.text
              : '0'),
      //terminaldamage
      terminalBendOrClosedOrDamage: int.parse(
              terminalBendController.text.length > 0
                  ? terminalBendController.text
                  : '0') +
          int.parse(terminalDamageController.text.length > 0
              ? terminalDamageController.text
              : '0'),
      terminalTwist: int.parse(terminalTwistController.text.length > 0
          ? terminalTwistController.text
          : '0'),
      windowGap: int.parse(windowGapController.text.length > 0
              ? windowGapController.text
              : '0') +
          int.parse(halfCurlingController.text.length > 0
              ? halfCurlingController.text
              : '0'),

      crimpInslation: int.parse(crimpOnInsulationController.text.length > 0
          ? crimpOnInsulationController.text
          : "0"),
      bellMouthError: int.parse(bellMouthErrorController.text.length > 0
              ? bellMouthErrorController.text
              : '0') +
          int.parse(lockingTabOpenController.text.length > 0
              ? lockingTabOpenController.text
              : '0'),

      burrOrCutOff: int.parse(cutoffBurrController.text.length > 0
          ? cutoffBurrController.text
          : '0'),
      exposedStrands: int.parse(
          exposureStrands.text.length > 0 ? exposureStrands.text : '0'),
      nickMark: int.parse(
          nickMarkController.text.length > 0 ? nickMarkController.text : '0'),
      //strandscut
      brushLengthLessMore: int.parse(
          brushLengthLessMoreController.text.length > 0
              ? brushLengthLessMoreController.text
              : '0'),
      nickMarkOrStrandsCut: int.parse(strandsCutController.text.length > 0
          ? strandsCutController.text
          : '0'),
      cableDamage: int.parse(cableDamageController.text.length > 0
          ? cableDamageController.text
          : '0'),
      //half curling
      //locking tab open close
      wrongTerminal: int.parse(wrongTerminalController.text.length > 0
          ? wrongTerminalController.text
          : '0'),
      seamOpen: int.parse(
          seamOpenController.text.length > 0 ? seamOpenController.text : '0'),
      missCrimp: int.parse(
          missCrimpController.text.length > 0 ? missCrimpController.text : '0'),
      extrusionOnBurr: int.parse(extrusionBurrController.text.length > 0
          ? extrusionBurrController.text
          : '0'),

      orderId: widget.schedule.purchaseOrder,
      fgPart: widget.schedule.finishedGoods,
      scheduleId: widget.schedule.scheduleId,
      // ignore: unnecessary_null_comparison
      awg: widget.schedule.awg != null ? widget.schedule.awg.toString() : "",
      terminalFrom: int.parse('${terminalA!.terminalPart}'),
      terminalTo: int.parse('${terminalB!.terminalPart}'),
    );
  }

  int total() {
    int total = int.parse(terminalDamageController.text.length > 0 ? terminalDamageController.text : '0') +
        int.parse(terminalBendController.text.length > 0
            ? terminalBendController.text
            : '0') +
        int.parse(terminalTwistController.text.length > 0
            ? terminalTwistController.text
            : '0') +
        int.parse(windowGapController.text.length > 0
            ? windowGapController.text
            : '0') +
        int.parse(crimpOnInsulationController.text.length > 0
            ? crimpOnInsulationController.text
            : '0') +
        int.parse(bellMouthErrorController.text.length > 0
            ? bellMouthErrorController.text
            : '0') +
        int.parse(cutoffBurrController.text.length > 0
            ? cutoffBurrController.text
            : '0') +
        int.parse(
            exposureStrands.text.length > 0 ? exposureStrands.text : '0') +
        int.parse(nickMarkController.text.length > 0
            ? nickMarkController.text
            : '0') +
        int.parse(strandsCutController.text.length > 0
            ? strandsCutController.text
            : '0') +
        int.parse(wrongTerminalController.text.length > 0
            ? wrongTerminalController.text
            : '0') +
        int.parse(brushLengthLessMoreController.text.length > 0
            ? brushLengthLessMoreController.text
            : '0') +
        int.parse(
            cableDamageController.text.length > 0 ? cableDamageController.text : '0') +
        int.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int.parse(lockingTabOpenController.text.length > 0 ? lockingTabOpenController.text : '0') +
        int.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    //TODO nickMark
    return total;
  }

  Widget tripleQuantityCell({
    required String name,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerCable,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 250,
              child: Text(
                "$name",
                style: TextStyle(fontFamily: fonts.openSans, fontSize: 12),
              ),
            ),
            Container(
              width: 266,
              child: Row(
                mainAxisAlignment: textEditingControllerCable != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  Container(
                      height: 35,
                      width: 95,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerFrom,
                        onTap: () {
                          setState(() {
                            _output = '';
                            mainController = textEditingControllerFrom;
                          });
                        },
                        style: TextStyle(fontSize: 11),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "From Terminal",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                  SizedBox(
                    width: textEditingControllerCable != null ? 0 : 4,
                  ),
                  textEditingControllerCable != null
                      ? Container(
                          height: 35,
                          width: 70,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerCable,
                            onTap: () {
                              setState(() {
                                _output = '';
                                mainController = textEditingControllerCable;
                              });
                            },
                            style: TextStyle(fontSize: 12),
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                              labelText: "Cable",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                  Container(
                      height: 35,
                      width: 95,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerTo,
                        onTap: () {
                          setState(() {
                            _output = '';
                            mainController = textEditingControllerTo;
                          });
                        },
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "To Terminal",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doubleQuantityCell({
    required String name,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 266,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 35,
                      width: 130,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerFrom,
                        onTap: () {
                          setState(() {
                            _output = '';
                            mainController = textEditingControllerFrom;
                          });
                        },
                        style: TextStyle(fontSize: 11),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: " $name From ",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                  Container(
                      height: 35,
                      width: 130,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerTo,
                        onTap: () {
                          setState(() {
                            _output = '';
                            mainController = textEditingControllerTo;
                          });
                        },
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "$name To",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell({
    required String name,
    required TextEditingController textEditingController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 33,
                width: 140,
                child: TextField(
                  controller: textEditingController,
                  onTap: () {
                    setState(() {
                      _output = '';
                      mainController = textEditingController;
                    });
                  },
                  style: TextStyle(fontSize: 12),
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

  Widget quantity(String title, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.25 * 0.4,
            //   child: Text(title,
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 15,
            //       )),
            // ),
            Container(
              height: 35,
              width: 130,
              child: TextField(
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: title,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 15),
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

  void clear() {
    endTerminalControllerFrom.clear();
    endTerminalControllerTo.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMouthErrorController.clear();
    cutoffBurrController.clear();
    exposureStrands.clear();
    nickMarkController.clear();
    strandsCutController.clear();
    brushLengthLessMoreController.clear();
    cableDamageController.clear();
    halfCurlingController.clear();
    setUpRejectionControllerCable.clear();
    setUpRejectionControllerTo.clear();
    setUpRejectionControllerFrom.clear();
    lockingTabOpenController.clear();
    wrongTerminalController.clear();
    wrongTerminalController.clear();
    endwireController.clear();
    seamOpenController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
    bundlQtyController.clear();
    rejectedQtyController.clear();
  }

  Widget binScan() {
    // Future.delayed(
    //   const Duration(milliseconds: 10),
    //   () {
    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   },
    // );
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 600,
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 270,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => handleKey(event.data),
                child: TextField(
                    autofocus: true,
                    controller: _binController,
                    onSubmitted: (value) {
                      postScanBin();
                    },
                    onTap: () {
                      setState(() {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        binId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _binController.text.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _binController.clear();
                                  });
                                },
                                child: Icon(Icons.clear,
                                    size: 18, color: Colors.red))
                            : Container(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 2.0),
                        ),
                        labelText: 'Scan bin',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          // Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 210,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: Colors.red))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red.shade200;
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _binController.clear();
                        });
                        setState(() {
                          status = Status.rejection;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors
                                .red.shade400; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Scan Bin',
                        ),
                      ),
                      onPressed: () {
                        postScanBin();
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  postScanBin() {
    if (_binController.text.length > 0) {
      TransferBundleToBin bundleToBin = TransferBundleToBin(
          userId: widget.userId,
          binIdentification: binId ?? '',
          locationId: "",
          bundleId: _scanIdController.text);
      apiService.postTransferBundletoBin(
          transferBundleToBin: [bundleToBin]).then((value) {
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
            scannedBundle!.binId = int.parse(binId!);
            scannedBundle!.locationId = "";
            bundleList.add(scannedBundle!);
            Future.delayed(
              const Duration(milliseconds: 4000),
              () {
                updateLocationtoempty(_binController.text);
                _binController.clear();
              },
            );
          });
        } else {
          setState(() {
            _binController.clear();
          });
          Fluttertoast.showToast(
            msg: "Unable to transfer Bundle to Bin",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });

      setState(() {
        clear();
        _scanIdController.clear();
        // binId = '';
        bundlQtyController.clear();
        status = Status.scan;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Scan Bin to Transfer",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  updateLocationtoempty(String binID) {
    log("updateloc : $binID");
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      scheduleId: 0,
      binId: int.parse(binID),
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: 0,
      cablePartNumber: 0,
      orderId: "",
    );
    List<TransferBinToLocation> transferList = [];
    ApiService apiService = new ApiService();
    apiService
        .getBundlesInSchedule(
            postgetBundleMaster: postgetBundleMaste, scheduleID: '')
        .then((value) {
      if (value != null) {
        List<BundlesRetrieved> bundleList1 = value;
        log("message1 $bundleList1");
        if (bundleList1.length > 0) {
          apiService.postTransferBinToLocation(bundleList1
              .map((e) => TransferBinToLocation(
                  bundleId: e.bundleIdentification,
                  locationId: "",
                  binIdentification: binID,
                  userId: widget.userId))
              .toList());
        } else {}
      } else {
        Fluttertoast.showToast(
          msg: "Location clear failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }
}
