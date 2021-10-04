import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';
import '../../../model_api/cableDetails_model.dart';
import '../../../model_api/cableTerminalA_model.dart';
import '../../../model_api/cableTerminalB_model.dart';
import '../../../model_api/crimping/getCrimpingSchedule.dart';
import '../../../model_api/login_model.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../models/bundle_scan.dart';
import '../../operator%202/materialPick2.dart';
import '../../operator%202/process/FullyCompleteP2.dart';
import 'double crimp/multipleBundleScan.dart';
import '../../operator%202/process/partialCompletion.dart';
import 'crimping.dart';
import '../../operator/location.dart';
import '../../operator/materialPick.dart';
import '../../operator/process/drawerWIp.dart';
import '../../operator/process/materialTableWIP.dart';
import '../../widgets/showBundleDetail.dart';

import '../../widgets/P2CrimpingScheduledetail.dart';
import '../../widgets/time.dart';
import '../../widgets/timer.dart';
import '../../../service/apiService.dart';


class ProcessPage2 extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  CrimpingSchedule schedule;
  MatTrkPostDetail matTrkPostDetail;
  ProcessPage2(
      {required this.schedule, required this.machine, required this.employee, required this.matTrkPostDetail});
  @override
  _ProcessPage2State createState() => _ProcessPage2State();
}

class _ProcessPage2State extends State<ProcessPage2> {
  String ?_chosenValue;
  String ?value;
  bool scanTap = false;
  FocusNode scanBundleFocus = new FocusNode();
  List<BundleScan> bundleScan = [];
  String ?scanId;
  TextEditingController _scanIdController = new TextEditingController();
  bool orderDetailExpanded = true;
  String ?rightside;
  String output = '';
  String _output = '';
  String? mainb;
  ApiService? apiService;
  String method = '';
  String bundltype = 'single';
  List<String>? items;
  int totalQuanity = 0;
  bool processStarted = false;
  @override
  void initState() {
    apiService = new ApiService();
    mainb = "scanBundle";

    super.initState();
    items = <String>[
      'Crimp From',
      'Crimp To',
      'Crimp From & To',
      'Double Crimp From'
      'Double Crimp To',
      'Double Crimping'
    ];

    _chosenValue = items!.contains(widget.schedule.process)
        ? widget.schedule.process
        : 'Crimp From & To';



    getMethod(_chosenValue!);
    totalQuanity = widget.schedule.actualQuantity;
  }

  void continueProcess(String name) {
    setState(() {
      mainb = name;
    });
  }

  void reload() {
    setState(() {});
  }

  getMethod(String value) {
    setState(() {
      if (value == "Crimp From") {
        method = 'a';
        bundltype = "single";
      }
      if (value == "Crimp To") {
        method = 'b';
        bundltype = "single";
      }
      if (value == "Crimp From & To") {
        method = 'a-b';
        bundltype = "single";
      }
      if (value == "Cutlength & both side stripping") {
        method = 'c';
        bundltype = "single";
      }
      if (value == "Double Crimping") {
        bundltype = "multiple";
        method = 'a-b';
      }
       if (value == "Double Crimp From") {
        bundltype = "multiple";
        method = 'a';
      }
       if (value == "Double Crimp To") {
        bundltype = "multiple";
        method = 'b';
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
       onWillPop: () async {
          showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do not use back button to exit'),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          );
          return false;
        },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: startProcess(),

          //  Text(
          //   'Crimping',
          //   style: TextStyle(
          //     color: Colors.red,
          //   ),
          // ),
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
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
        drawer: DrawerWidgetWIP(
          employee: widget.employee,
          machineDetails: widget.machine,
          transfer: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Location(
                        locationType: LocationType.partialTransfer,
                        type: "process",
                        employee: widget.employee,
                        machine: widget.machine,
                      )),
            );
          },
          reloadmaterial: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MaterialPickOp2(
                  schedule: widget.schedule,
                  employee: widget.employee,
                  reload: reload,
                  machine: widget.machine,
                  materialPickType: MaterialPickType.reload,
                ),
              ),
            );
          }, homeReload: (){}, returnmaterial: (){}, 
        ),
        body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Column(children: [
              P2ScheduleDetailWIP(
                schedule: widget.schedule,
              ),
              // tableHeading(),
              // buildDataRow(schedule: widget.schedule),
              // fgDetails(),
            ]),
            Column(children: [
              terminal(),
              mainBox(mainb!),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget mainBox(String main) {
  
    if (main == "scanBundle") {
      return bundltype == "single"
          ? ScanBundle(
              machineId: widget.machine.machineNumber??'',
              userId: widget.employee.empId,
              schedule: widget.schedule,
              method: method,
              totalQuantity: totalQuanity,
              matTrkPostDetail: widget.matTrkPostDetail,
              processName: _chosenValue??'',
              processStarted: processStarted,

              reload: reload,
              transfer: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Location(
                            locationType: LocationType.partialTransfer,
                            type: "process",
                            employee: widget.employee,
                            machine: widget.machine,
                          )),
                );
              },
              updateQty: (value) {
                log("QTYY : $value");
                setState(() {
                  totalQuanity = value;
                });
              },
              startProcess: () {
                setState(() {
                  processStarted = true;
                });
              },
              fullyComplete: () {
                setState(() {
                  mainb = "100";
                });
              },
              partiallyComplete: () {
                setState(() {
                  mainb = "partial";
                });
              }, 
            )
          : MultipleBundleScan(
            machineId: widget.machine.machineNumber??'',
              userId: widget.employee.empId,
              schedule: widget.schedule,
              method: method,
              totalQuantity: totalQuanity,
              matTrkPostDetail: widget.matTrkPostDetail,
              processName: _chosenValue??'',
              processStarted: processStarted,
               updateQty: (value) {
                log("QTYY : $value");
                setState(() {
                  totalQuanity = value;
                });
              },
              startProcess: () {
                setState(() {
                  processStarted = true;
                });
              },
              fullyComplete: () {
                setState(() {
                  mainb = "100";
                });
              },
              partiallyComplete: () {
                setState(() {
                  mainb = "partial";
                });
              }, 
              process: _chosenValue??'Double Crimping',
              reload: reload,
              transfer: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Location(
                            locationType: LocationType.partialTransfer,
                            type: "process",
                            employee: widget.employee,
                            machine: widget.machine,
                          )),
                );
              },
            );
    }
    if (main == "100") {
      return FullCompleteP2(
          employee: widget.employee,
          machine: widget.machine,
          schedule: widget.schedule,
          continueProcess: (value) {
            setState(() {
              mainb = value;
            });
          });
    }
    if (main == "partial") {
      return PartialCompletionP2(
          machine: widget.machine,
          employee: widget.employee,
          schedule: widget.schedule,
          continueProcess: (value) {
            setState(() {
              mainb = value;
            });
          });
    } else {
      return Container();
    }
  }

  Widget terminal() {

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.18,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: widget.machine.category == "Automatic Cutting"
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceEvenly,
          children: [
            // terminal A
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: FutureBuilder(
                    future: apiService!.getCableTerminalA(
                        fgpartNo: "${widget.schedule.finishedGoods}",
                        cablepartno:
                            "${widget.schedule.cablePartNo.toString()}",
                        length: "${widget.schedule.length}",
                        color: widget.schedule.wireColour,
                        awg: int.parse(widget.schedule.awg ?? '0')),
                    builder: (context, snapshot) {
                      CableTerminalA? terminalA = snapshot.data as CableTerminalA?;
                      if (snapshot.hasData) {
                        return process(
                            'From Process',
                            '',
                            // 'From Strip Length Spec(mm) - ${terminalA.fronStripLengthSpec}',
                            'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(${terminalA!.processType})(${terminalA.stripLength})(${terminalA.terminalPart})(${terminalA.specCrimpLength})(${terminalA.pullforce})(${terminalA.comment})',
                            '',
                            0.35,
                            method.contains('a') ? true : false);
                      } else {
                        return process(
                            'From Process',
                            '',
                            'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(-)()(-)(-)(-)',
                            '',
                            0.325,
                            method.contains('a') ? true : false);
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder(
                  future: apiService!.getCableDetails(
                      fgpartNo: "${widget.schedule.finishedGoods}",
                      cablepartno: "${widget.schedule.cablePartNo}",
                      length: "${widget.schedule.length}",
                      color: widget.schedule.wireColour,
                      awg: int.parse(widget.schedule.awg ?? '0')),
                  builder: (context, snapshot) {
                    CableDetails? cableDetail = snapshot.data as CableDetails?;
                    if (snapshot.hasData) {
                      return cable(
                          cableDetails: cableDetail,
                          width: 0.28,
                          color: method.contains('c') ? true : false);
                      // process(
                      //     'Cable',
                      //     'Cut Length Spec(mm) -${cableDetail.cutLengthSpec}',
                      //     'Cable Part Number(Description)',
                      //     '${cableDetail.cablePartNumber}(${cableDetail.description})',
                      //     'From Strip Length Spec(mm) : ${cableDetail.stripLengthFrom} \n To Strip Length Spec(mm) : ${cableDetail.stripLengthTo}',
                      //     0.28);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: FutureBuilder(
                    future: apiService!.getCableTerminalB(
                        fgpartNo: "${widget.schedule.finishedGoods}",
                        cablepartno: "${widget.schedule.cablePartNo}" ??
                            "${widget.schedule.finishedGoods}",
                        length: "${widget.schedule.length}",
                        color: widget.schedule.wireColour,
                        awg: int.parse(widget.schedule.awg ?? '0')),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        CableTerminalB? cableTerminalB = snapshot.data as CableTerminalB?;
                        return process(
                            'To Process',
                            '',
                            'Process(Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(${cableTerminalB!.processType})(${cableTerminalB.stripLength})(${cableTerminalB.terminalPart})(${cableTerminalB.specCrimpLength})(${cableTerminalB.pullforce})(${cableTerminalB.comment})',
                            '',
                            0.35,
                            method.contains('b') ? true : false);
                      } else {
                        return process(
                            'To Process',
                            'From Strip Length Spec(mm) - 40}',
                            'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(-)()(-)(-)(-)',
                            '',
                            0.35,
                            method.contains('b') ? true : false);
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget process(String p1, String p2, String p3, String p4, String p5,
      double width, bool color) {
    return Material(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.transparent)),
      shadowColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        // height: 91,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color ? Colors.red.shade50 : Colors.white,
          border: Border.all(
              width: 1.5, color: color ? Colors.red.shade500 : Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          p1,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: ''),
                        ),
                        SizedBox(width: 20),
                        Text(
                          p2,
                          style: TextStyle(fontSize: 11, fontFamily: ''),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      p3,
                      style: TextStyle(fontSize: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * width,
                      child: Text(p4,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontFamily: fonts.openSans,
                              fontWeight: FontWeight.bold,
                            
                          )),
                    ),
                    SizedBox(height: 4),
                    Text(
                      p5,
                      style: TextStyle(fontSize: 11, fontFamily: ''),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cable({CableDetails? cableDetails, double? width, bool? color}) {
    return Material(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.transparent)),
      shadowColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        // // height: 91,
        // width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color??false ? Colors.red.shade50 : Colors.white,
          border: Border.all(
              width: 1.5, color: color??false ? Colors.red.shade500 : Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Cable",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: ''),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Cut Length Spec(mm) -${cableDetails!.cutLengthSpec}",
                          style: TextStyle(fontSize: 11, fontFamily: ''),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Cable Part Number(Description)",
                      style: TextStyle(fontSize: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * width!,
                      child: Text(
                          "${cableDetails.cablePartNumber}(${cableDetails.description})",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontFamily: fonts.openSans,
                              fontWeight: FontWeight.bold,
                            
                          )),
                    ),
                    SizedBox(height: 1),
                    Container(
                      width: MediaQuery.of(context).size.width * width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "From Strip Length Spec(mm) :",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: fonts.openSans),
                              ),
                              Text(
                                "${cableDetails.stripLengthFrom} ",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: fonts.openSans,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "To Strip Length Spec(mm) :  ",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: fonts.openSans),
                              ),
                              Text(
                                "${cableDetails.stripLengthTo}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: fonts.openSans,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget startProcess() {


    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            _chosenValue == null || !items!.contains(widget.schedule.process)
                ? DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    //elevation: 5,
                    underline: Container(),
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.red,

                    items: items!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: fonts.openSans,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  height: 30,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/image/$value.png"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'Select Process',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String? value) {
                      _chosenValue = value;
                      value = value;
                      setState(() {
                        _chosenValue = value;
                        if (value == "Crimp From") {
                          method = 'a';
                          bundltype = "single";
                        }
                        if (value == "Crimp To") {
                          method = 'b';
                          bundltype = "single";
                        }
                        if (value == "Crimp From & To") {
                          method = 'a-b';
                          bundltype = "single";
                        }
                        if (value == "Cutlength & both side stripping") {
                          method = 'c';
                          bundltype = "single";
                        }
                        if (value == "Double Crimping") {
                          bundltype = "multiple";
                          method = 'a-b';
                        }
                      });
                    },
                  )
                : Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _chosenValue!,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 30,
                            width: 130,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/image/$_chosenValue.png"))),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget materialtable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Process $_chosenValue",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Row(
          children: [
            table(),
          ],
        ),
      ],
    );
  }

  Widget table() {
    ApiService apiService = new ApiService();
    return FutureBuilder(
        future:
            apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MaterialDetail>? matList = snapshot.data as List<MaterialDetail>?;
            if (matList!.length > 0) {
              return Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: Column(children: [
                        row('Part No.', 'UOM', 'REQUIRED', 'LOADED',
                            'AVAILABLE', Colors.blue.shade100),
                        Container(
                          height: 63,
                          child: ListView.builder(
                              itemCount: matList!.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return row(
                                    "${matList[index].cablePartNo}",
                                    "${matList[index].uom.toString()}",
                                    "${matList[index].requiredQty.toString()}",
                                    "${matList[index].loadedQty.toString()}",
                                    "${matList[index].availableQty.toString()}",
                                    Colors.grey.shade100);
                              }),
                        ),
                      ])),
                  Container(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ElevatedButton(
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
                                      return Colors.blue.shade200;
                                    return Colors.blue.shade500
                                        ; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.blue;
                                    return Colors.blue
                                        ; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {},
                              child: Text("Return")),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: Column(
                    children: [
                      row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                          Colors.blue.shade100),
                      Text(
                        "no stock found",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ));
            }
          } else {
            return Container(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                        Colors.blue.shade100),
                    Text(
                      "no stock found",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ));
          }
        });
  }

  Widget row(String partno, String uom, String require, String loaded,
      String available, Color color) {
    return Container(
      color: color,
      child: Row(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey.shade100)),
                height: 20,
                width: MediaQuery.of(context).size.width * 0.1,
                child: Center(
                    child: Text(partno, style: TextStyle(fontSize: 12)))),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  uom,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  require,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.08,
              child: Center(
                child: Text(
                  loaded,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  available,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 0.5, color: Colors.grey.shade100)),
            //   height: 20,
            //   width: MediaQuery.of(context).size.width * 0.08,
            //   child: Center(
            //     child: Text(
            //       pending,
            //       style: TextStyle(fontSize: 10),
            //     ),
            //   ),
            // ),
          ],
        )
      ]),
    );
  }
}
