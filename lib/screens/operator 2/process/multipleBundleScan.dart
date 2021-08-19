import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex/screens/widgets/keypad.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../model_api/Transfer/bundleToBin_model.dart';
import '../../../model_api/cableTerminalA_model.dart';
import '../../../model_api/cableTerminalB_model.dart';
import '../../../model_api/crimping/bundleDetail.dart';
import '../../../model_api/crimping/getCrimpingSchedule.dart';
import '../../../model_api/crimping/postCrimprejectedDetail.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../service/apiService.dart';

enum Status {
  scan,
  rejection,
  showbundle,
  scanBin,
  bundleDetail,
}

class MultipleBundleScan extends StatefulWidget {
  int length;
  String userId;
  String machineId;
  String method;
  @required
  CrimpingSchedule schedule;
  MultipleBundleScan(
      {this.length, this.machineId, this.method, this.userId, this.schedule});

  @override
  _MultipleBundleScanState createState() => _MultipleBundleScanState();
}

class _MultipleBundleScanState extends State<MultipleBundleScan> {
  TextEditingController mainController = new TextEditingController();
  TextEditingController endTerminalController = new TextEditingController();
  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController =
      new TextEditingController();
  TextEditingController bellMouthLessController = new TextEditingController();
  TextEditingController bellMouthMoreController = new TextEditingController();
  TextEditingController cutoffBurrController = new TextEditingController();
  TextEditingController exposureStrands = new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessController = new TextEditingController();
  TextEditingController brushLengthMoreController1 =
      new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();
  TextEditingController setUpRejectionController = new TextEditingController();
  TextEditingController lockingTabOpenController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();
  TextEditingController copperMarkController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();
  //Quantity
  TextEditingController rejectedQtyController = new TextEditingController();
  TextEditingController bundlQtyController = new TextEditingController();
  FocusNode _scanfocus = new FocusNode();
  TextEditingController _scanIdController = new TextEditingController();
  bool next = false;
  bool showTable = true;
  List<BundleData> scannedBundles = [];
  Status status = Status.scan;

  String _output = '';

  TextEditingController _binController = new TextEditingController();

  bool hasBin;

  String binId;
  //to store the bundle Quantity fetched from api after scanning bundle Id
  String bundleQty = '';
  ApiService apiService = new ApiService();
  CableTerminalA terminalA;
  CableTerminalB terminalB;

  bool terminalfromcheck = false;

  bool terminaltocheck = false;
  bool visibility = true;
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: "${widget.schedule.finishedGoods}",
            cablepartno: widget.schedule.cablePartNo.toString(),
            length: "${widget.schedule.length}",
            color: widget.schedule.wireColour,
            awg: int.parse(widget.schedule.awg ?? '0'))
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: "${widget.schedule.finishedGoods}",
              cablepartno: widget.schedule.cablePartNo.toString() ??
                  widget.schedule.finishedGoods,
              length: "${widget.schedule.length}",
              color: widget.schedule.wireColour,
              awg: int.parse(widget.schedule.awg ?? ''))
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Material(
      elevation: 5,
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.transparent)),
      child: Container(
        height: 350,
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
                }),
          ],
        ),
      ),
    );
  }

  Widget main(Status status) {
   visibility? Future.delayed(
      const Duration(milliseconds: 10),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    ):(){};
   
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


  Widget scanedTable() {
   
    if (showTable) {
      return Container(
        height: 220,
        child: SingleChildScrollView(
          child: DataTable(
              columnSpacing: 30,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'S No.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Bundle Id',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Bundle Qty',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Remove',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
              rows: scannedBundles
                  .map((e) => DataRow(cells: <DataCell>[
                        DataCell(Text("${scannedBundles.indexOf(e) + 1}")),
                        DataCell(Text(
                          "${e.bundleIdentification}",
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          "${e.bundleQuantity.toString()}",
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              scannedBundles.remove(e);
                            });
                          },
                        )),
                      ]))
                  .toList()),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget scanBundlePop() {
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 200,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        controller: _scanIdController,
                        onChanged: (value) {
                          setState(() {});
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
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 130,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.redAccent),
                                ),
                                onPressed: () {
                                  if (_scanIdController.text.length > 0) {
                                    apiService
                                        .getBundleDetail(_scanIdController.text)
                                        .then((value) {
                                      BundleData bundleDetail = value;
                                      if (value != null) {
                                        // if ("${bundleDetail.finishedGoodsPart}" ==
                                        //         "${widget.schedule.finishedGoods}") {
                                        if (true) {
                                          setState(() {
                                            if (!scannedBundles
                                                .map((e) =>
                                                    e.bundleIdentification)
                                                .toList()
                                                .contains(bundleDetail
                                                    .bundleIdentification)) {
                                              scannedBundles.add(value);
                                              _scanIdController.clear();
                                            } else {
                                              _scanIdController.clear();
                                              Fluttertoast.showToast(
                                                  msg: "Bundle already Present",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }

                                            clear();
                                            // bundleQty =
                                            //     "${bundleDetail.bundleQuantity}";
                                            // bundlQtyController.text =
                                            //     "${bundleDetail.bundleQuantity}";
                                            // next = !next;
                                            // status = Status.rejection;
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Bundle does not match FG Detials",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Bundle Not Found",
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
                                        msg: "Scan Bundle to proceed",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Text('Scan Bundles  ')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.green),
                              ),
                              onPressed: () {
                                setState(() {
                                  showTable = !showTable;
                                });
                              },
                              child: Text("${scannedBundles.length}")),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clear();

                          next = !next;
                          status = Status.rejection;
                        });
                      },
                      child: Text("Start"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: [
                            new Checkbox(
                                value: terminalfromcheck,
                                activeColor: Colors.green,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    terminalfromcheck = newValue;
                                  });
                                }),
                            Text("Terminal From")
                          ],
                        ),
                        Row(
                          children: [
                            new Checkbox(
                                value: terminaltocheck,
                                activeColor: Colors.green,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    terminaltocheck = newValue;
                                  });
                                }),
                            Text("Terminal To")
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
          scanedTable(),
        ],
      ),
    );
  }

  handleKey(RawKeyEventDataAndroid key) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget rejectioncase() {

    return Container(
      width: MediaQuery.of(context).size.width * 0.74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
                          quantitycell(
                            name: "End Termianl	",
                            textEditingController: endTerminalController,
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
                            name: "Bellmouth less",
                            textEditingController: bellMouthLessController,
                          ),
                          quantitycell(
                            name: "Bellmouth More",
                            textEditingController: bellMouthMoreController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Cutt oFf Burr",
                            textEditingController: cutoffBurrController,
                          ),
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
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Brush Length Less",
                            textEditingController: brushLengthLessController,
                          ),
                          quantitycell(
                            name: "Brush Length More",
                            textEditingController: brushLengthMoreController1,
                          ),
                          quantitycell(
                              name: "Cable Damage",
                              textEditingController: cableDamageController),
                          quantitycell(
                            name: "Half Curling	",
                            textEditingController: halfCurlingController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Setup Rejections	",
                            textEditingController: setUpRejectionController,
                          ),
                          quantitycell(
                            name: "Locking Tab Open/Close	",
                            textEditingController: lockingTabOpenController,
                          ),
                          quantitycell(
                            name: "Wrong Terminal	",
                            textEditingController: wrongTerminalController,
                          ),
                          quantitycell(
                            name: "Copper Mark	",
                            textEditingController: copperMarkController,
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
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text("Bundles"),
                          SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(110)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${scannedBundles.length}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green[200];
                                      return Colors.green[
                                          500]; // Use the component's default.
                                    },
                                  ),
                                ),
                                child: Text("Save & Scan Next"),
                                onPressed: () {
                                  Future.delayed(
                                    const Duration(milliseconds: 50),
                                    () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    },
                                  );
                                  for (BundleData e in scannedBundles) {
                                    log("${scannedBundles.indexOf(e)}");
                                    PostCrimpingRejectedDetail
                                        postCrimpingRejectedDetail =
                                        PostCrimpingRejectedDetail(
                                      bundleIdentification:
                                          e.bundleIdentification,
                                      finishedGoods:
                                          widget.schedule.finishedGoods,
                                      cutLength: widget.schedule.length,
                                      color: widget.schedule.wireColour,
                                      cablePartNumber:
                                          widget.schedule.cablePartNo,
                                      processType: widget.schedule.process,
                                      method: scannedBundles.indexOf(e) ==
                                              (scannedBundles.length - 1)
                                          ? getterminalmethod()
                                          : '',
                                      status: "",
                                      machineIdentification: widget.machineId,
                                      binId: "",
                                      bundleQuantity: e.bundleQuantity,
                                      passedQuantity:
                                          e.bundleQuantity - total(),
                                      rejectedQuantity: total(),
                                      crimpInslation: int.parse(
                                          crimpOnInsulationController
                                                      .text.length >
                                                  0
                                              ? crimpOnInsulationController.text
                                              : "0"),
                                      burrOrCutOff: int.parse(
                                          cutoffBurrController.text.length > 0
                                              ? cutoffBurrController.text
                                              : '0'),
                                      terminalBendOrClosedOrDamage: int.parse(
                                          terminalBendController.text.length > 0
                                              ? terminalBendController.text
                                              : '0'),
                                      missCrimp: int.parse(
                                          missCrimpController.text.length > 0
                                              ? missCrimpController.text
                                              : '0'),
                                      terminalTwist: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      insulationSlug: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'), //TODO check if both are same
                                      windowGap: int.parse(
                                          windowGapController.text.length > 0
                                              ? windowGapController.text
                                              : '0'),
                                      exposedStrands: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      nickMarkOrStrandsCut: int.parse(
                                          "0"), //TODO check nick mark in Qty
                                      brushLength: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      seamOpen: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),

                                      frontBellMouth: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      backBellMouth: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      extrusionOnBurr: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),
                                      cableDamage: int.parse(
                                          terminalTwistController.text.length >
                                                  0
                                              ? terminalTwistController.text
                                              : '0'),

                                      orderId: widget.schedule.purchaseOrder,
                                      fgPart: widget.schedule.finishedGoods,
                                      scheduleId: widget.schedule.scheduleId,
                                      awg: widget.schedule.awg != null
                                          ? widget.schedule.awg.toString()
                                          : null,
                                      terminalFrom: int.parse(
                                          '${terminalA.terminalPart}'),
                                      terminalTo: int.parse(
                                          '${terminalB.terminalPart}'),
                                    );
                                    apiService
                                        .postCrimpRejectedQty(
                                            postCrimpingRejectedDetail)
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          Future.delayed(
                                              const Duration(milliseconds: 10),
                                              () {
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
                                        Future.delayed(Duration(seconds: 5))
                                            .then((value) =>
                                                Fluttertoast.showToast(
                                                  msg:
                                                      " Save Crimping Reject detail failed ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                ));
                                      }
                                    });
                                  }
                                  setState(() {
                                    clear();
                                    // scannedBundles.clear();
                                  });
                                })
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

  String getterminalmethod() {
    if (terminalfromcheck && terminaltocheck) {
      return "a-b";
    } else if (terminalfromcheck) {
      return "a";
    } else if (terminaltocheck) {
      return "b";
    } else {
      return "b";
    }
  }

  int total() {
    log("brush :${brushLengthMoreController1.text}");
    int total = int.parse(endTerminalController.text.length > 0 ? endTerminalController.text : '0') +
        int.parse(terminalDamageController.text.length > 0
            ? terminalDamageController.text
            : '0') +
        int.parse(terminalBendController.text.length > 0
            ? windowGapController.text
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
        int.parse(bellMouthLessController.text.length > 0
            ? bellMouthLessController.text
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
        int.parse(brushLengthLessController.text.length > 0
            ? brushLengthLessController.text
            : '0') +
        int.parse(
            brushLengthMoreController1.text.length > 0 ? brushLengthMoreController1.text : '0') +
        int.parse(cableDamageController.text.length > 0 ? cableDamageController.text : '0') +
        int.parse(wrongTerminalController.text.length > 0 ? wrongTerminalController.text : '0') +
        int.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int.parse(setUpRejectionController.text.length > 0 ? setUpRejectionController.text : '0') +
        int.parse(lockingTabOpenController.text.length > 0 ? lockingTabOpenController.text : '0') +
        int.parse(copperMarkController.text.length > 0 ? copperMarkController.text : '0') +
        int.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    //TODO nickMark
    return total;
  }

  Widget quantitycell(
      {String name,
      TextEditingController textEditingController,
      FocusNode focusNode}) {
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
                  focusNode: focusNode,
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
    endTerminalController.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMouthLessController.clear();
    bellMouthMoreController.clear();
    cutoffBurrController.clear();
    exposureStrands.clear();
    nickMarkController.clear();
    strandsCutController.clear();
    brushLengthLessController.clear();
    brushLengthMoreController1.clear();
    cableDamageController.clear();
    halfCurlingController.clear();
    setUpRejectionController.clear();
    lockingTabOpenController.clear();
    wrongTerminalController.clear();
    wrongTerminalController.clear();
    copperMarkController.clear();
    seamOpenController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
    bundlQtyController.clear();
    rejectedQtyController.clear();
  }

  Widget binScan() {
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(0.0),
      child: Column(
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
                      hasBin = true;

                      // _bundleFocus.requestFocus();
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                      );
                    },
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                          borderSide:
                              BorderSide(color: Colors.grey[400], width: 2.0),
                        ),
                        labelText: '    Scan bin    ',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          // Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 280,
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
                              return Colors.red[200];
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '  Back   ',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onPressed: () {
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
                                .red[400]; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Scan Bin',
                        ),
                      ),
                      onPressed: () {
                        Future.delayed(
                          const Duration(milliseconds: 10),
                          () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                        );
                        List<TransferBundleToBin> listTransfer = [];
                        log("${scannedBundles}");
                        for (BundleData bundle in scannedBundles) {
                          listTransfer.add(TransferBundleToBin(
                              userId: widget.userId,
                              binIdentification: binId,
                              bundleId: bundle.bundleIdentification));
                        }

                        apiService
                            .postTransferBundletoBin(
                                transferBundleToBin: listTransfer)
                            .then((value) {
                          if (value != null) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            BundleTransferToBin bundleTransferToBinTracking =
                                value[0];
                            Fluttertoast.showToast(
                                msg:
                                    "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            scannedBundles.clear();
                            setState(() {
                              Future.delayed(
                                const Duration(milliseconds: 10),
                                () {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                },
                              );
                              clear();
                              _scanIdController.clear();
                              binId = '';
                              _binController.clear();
                              bundlQtyController.clear();
                              status = Status.scan;
                            });
                          } else {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            Fluttertoast.showToast(
                              msg: "Unable to transfer Bundle to Bin",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            setState(() {
                              _binController.clear();
                            });
                          }
                        });
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
