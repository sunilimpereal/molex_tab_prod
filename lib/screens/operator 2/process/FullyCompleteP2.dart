import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex/screens/operator/process/process.dart';
import '../../../main.dart';
import '../../../model_api/crimping/getCrimpingSchedule.dart';
import '../../../model_api/login_model.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/process1/100Complete_model.dart';

import '../../../model_api/startProcess_model.dart';

import '../../../utils/config.dart';
import '../../operator/location.dart';
import '../../widgets/keypad.dart';
import '../../../service/apiService.dart';

class FullCompleteP2 extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  CrimpingSchedule schedule;
  Function continueProcess;
  FullCompleteP2({required this.employee, required this.machine, required this.schedule, required this.continueProcess});
  @override
  _FullCompleteP2State createState() => _FullCompleteP2State();
}

class _FullCompleteP2State extends State<FullCompleteP2> {
  PostStartProcessP1? postStartprocess;
  TextEditingController mainController = new TextEditingController();
  TextEditingController noRawmaterialController = new TextEditingController();
  TextEditingController machineBreakdownController = new TextEditingController();
  TextEditingController applicatorBreakdownController = new TextEditingController();
  TextEditingController toolingTechnicianNotAvailableController = new TextEditingController();
  TextEditingController noFeedController = new TextEditingController();

  // TextEditingController firsrPeicelastPieceController =
  //     new TextEditingController();
  // TextEditingController crimpheightAdjController = new TextEditingController();
  // TextEditingController airPressureLowController = new TextEditingController();
  // TextEditingController noRawMaterialController = new TextEditingController();
  // TextEditingController applicatorChangeOverController =
  //     new TextEditingController();
  // TextEditingController terminalChangeOverController =
  //     new TextEditingController();
  // TextEditingController technichianNotAvailableController =
  //     new TextEditingController();
  // TextEditingController powerFailureController = new TextEditingController();
  // TextEditingController machineCleaningController = new TextEditingController();
  // TextEditingController noOperatorController = new TextEditingController();
  // TextEditingController sensorNotWorkingController =
  //     new TextEditingController();
  // TextEditingController meetingController = new TextEditingController();
  // TextEditingController maintainanceMinorStopageController =
  //     new TextEditingController();
  // TextEditingController minorToolingAjjustmentsController =
  //     new TextEditingController();

  String _output = '';
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod(keyboardType);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 5,
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.transparent)),
        child: Container(
          height: 345,
          child: Row(
            children: [
              rejectioncase(),
              KeyPad(
                  controller: mainController,
                  buttonPressed: (buttonText) {
                    if (buttonText == 'X') {
                      _output = '';
                    } else {
                      _output = _output + buttonText;
                    }

                    print(_output);
                    setState(() {
                      mainController.text = _output;
                      // output = int.parse(_output).toStringAsFixed(2);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget rejectioncase() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Crimping Production Report',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: fonts.openSans,
                        fontSize: 16,
                      ))
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
                            name: "No Raw Material",
                            quantity: 10,
                            textEditingController: noRawmaterialController,
                          ),
                          quantitycell(
                            name: "Machine Breakdown",
                            quantity: 10,
                            textEditingController: machineBreakdownController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Applicator BreakDown",
                            quantity: 10,
                            textEditingController: applicatorBreakdownController,
                          ),
                          quantitycell(
                            name: "Tooling Technician not available ",
                            quantity: 10,
                            textEditingController: toolingTechnicianNotAvailableController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "No feed	",
                            quantity: 10,
                            textEditingController: noFeedController,
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
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Center(
                      child: Container(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.green))),
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.white;
                                  return Colors.white; // Use the component's default.
                                },
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.keyboard_arrow_left, color: Colors.green),
                                Text(
                                  "Back",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            onPressed: () {
                              widget.continueProcess("scanBundle");
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    child: Center(
                      child: Container(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Colors.transparent))),
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                  return Colors.green.shade500; // Use the component's default.
                                },
                              ),
                            ),
                            child: Text("Save & Complete Process"),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                //    postStartprocess = new PostStartProcessP1(
                                //   cablePartNumber:
                                //       widget.schedule.cablePartNo ?? "0",
                                //   color: widget.schedule.wireColour,
                                //   finishedGoodsNumber:
                                //       widget.schedule.finishedGoods ?? "0",
                                //   lengthSpecificationInmm:
                                //       widget.schedule.length ?? "0",
                                //   machineIdentification: widget.machine.machineNumber,
                                //   orderIdentification: widget.schedule.purchaseOrder ?? "0",
                                //   scheduledIdentification:
                                //       widget.schedule.scheduleId ?? "0",
                                //   scheduledQuantity:
                                //       widget.schedule.bundleQuantityTotal ?? "0",
                                //   scheduleStatus: "complete",
                                // );
                                FullyCompleteModel fullyComplete = FullyCompleteModel(
                                    finishedGoodsNumber: widget.schedule.finishedGoods,
                                    orderId: widget.schedule.purchaseOrder,
                                    purchaseOrder: widget.schedule.purchaseOrder,
                                    cablePartNumber: widget.schedule.cablePartNo,
                                    length: widget.schedule.length,
                                    color: widget.schedule.wireColour,
                                    scheduledStatus: "Complete",
                                    scheduledId: widget.schedule.scheduleId,
                                    scheduledQuantity: widget.schedule.bundleQuantityTotal,
                                    machineIdentification: widget.machine.machineNumber ?? '',
                                    //TODO bundle ID
                                    firstPieceAndPatrol: 0,
                                    applicatorChangeover: 0,
                                    bundleIdentification: '');
                                apiService.post100Complete(fullyComplete).then((value) {
                                  if (value) {
                                    postCompleteTransfer(
                                      context: context,
                                      employee: widget.employee,
                                      machine: widget.machine,
                                    );
                                    // Navigator.push(

                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => Location(
                                    //             type: "process",
                                    //             employee: widget.employee,
                                    //             machine: widget.machine, locationType: LocationType.finaTtransfer,
                                    //           )),
                                    // );
                                  } else {}
                                });
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Location(
                              //             userId: widget.userId,
                              //             machine: widget.machine,
                              //           )),
                              // );
                            }),
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

  Widget quantitycell({
    required String name,
    required int quantity,
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
                  showCursor: false,
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

  Widget quantity(String title, int quantity, TextEditingController textEditingController) {
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
                onTap: () {
                  setState(() {
                    _output = '';
                    mainController = textEditingController;
                  });
                },
                style: TextStyle(fontSize: 12),
                controller: textEditingController,
                keyboardType: TextInputType.number,
                showCursor: false,
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
}
