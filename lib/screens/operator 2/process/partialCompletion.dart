import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';
import '../../../model_api/crimping/getCrimpingSchedule.dart';
import '../../../model_api/login_model.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/partiallyComplete_model.dart';
import '../../../model_api/transferLocation_model.dart';
import '../../operator/location.dart';
import '../../operator/process/partiallyComplete.dart';
import '../../widgets/keypad.dart';
import '../../../service/apiService.dart';

class PartialCompletionP2 extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Function continueProcess;
  CrimpingSchedule schedule;
  PartialCompletionP2(
      {required this.machine, required this.employee, required this.continueProcess, required this.schedule});
  @override
  _PartialCompletionP2State createState() => _PartialCompletionP2State();
}

class _PartialCompletionP2State extends State<PartialCompletionP2> {
  TextEditingController firstPatrolController = new TextEditingController();
  TextEditingController spareChangeoverController = new TextEditingController();
  TextEditingController crimpHeightSettingController =
      new TextEditingController();
  TextEditingController resettingCFMProgramController =
      new TextEditingController();
  TextEditingController newProgramSettingCVMCFMController =
      new TextEditingController();
  TextEditingController airPressureLowController = new TextEditingController();
  TextEditingController machineTakenforRemovingCVMController =
      new TextEditingController();
  TextEditingController noMaterialController = new TextEditingController();
  TextEditingController applicatorChangeoverController =
      new TextEditingController();
  TextEditingController sinkHeightAdjustmentController =
      new TextEditingController();
  TextEditingController feedingAdjustmentController =
      new TextEditingController();
  TextEditingController applicatorPositionSettingController =
      new TextEditingController();
  TextEditingController validationController = new TextEditingController();
  TextEditingController cFACrimpingFaultController =
      new TextEditingController();
  TextEditingController cableEntangleController = new TextEditingController();
  TextEditingController jobTicketIssueController = new TextEditingController();
  TextEditingController lengthChangeoverController =
      new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController cutOffBurrIssueController = new TextEditingController();
  TextEditingController cVMErrorCorrectionController =
      new TextEditingController();
  TextEditingController cableFeedingFrontUnitProblemController =
      new TextEditingController();
  TextEditingController driftLimitReachedController =
      new TextEditingController();
  TextEditingController machineSlowController = new TextEditingController();
  TextEditingController noPlanforMachineController =
      new TextEditingController();
  TextEditingController terminalChangeoverController =
      new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController extrusionBurrIssueController =
      new TextEditingController();
  TextEditingController cFMErrorController = new TextEditingController();
  TextEditingController supplierTakenforMaintenanceController =
      new TextEditingController();
  TextEditingController rollerChangeoverController =
      new TextEditingController();
  TextEditingController gripenUnitProblemController =
      new TextEditingController();
  TextEditingController technicianNotAvailableController =
      new TextEditingController();
  TextEditingController coilChangeoverController = new TextEditingController();
  TextEditingController bellmouthAdjustmentController =
      new TextEditingController();
  TextEditingController cameraSettingController = new TextEditingController();
  TextEditingController cVMErrorController = new TextEditingController();
  TextEditingController lengthVariationsController =
      new TextEditingController();
  TextEditingController powerFailureController = new TextEditingController();
  TextEditingController machineCleaningController = new TextEditingController();
  TextEditingController noOperatorController = new TextEditingController();
  TextEditingController lastPieceController = new TextEditingController();
  TextEditingController curlingAdjustmentController =
      new TextEditingController();
  TextEditingController wireFeedingAdjustmentController =
      new TextEditingController();
  TextEditingController cVMProgramReloadingController =
      new TextEditingController();
  TextEditingController sensorNotWorkingController =
      new TextEditingController();
  TextEditingController preventiveMaintenanceController =
      new TextEditingController();
  TextEditingController meetingController = new TextEditingController();
  TextEditingController systemFaultController = new TextEditingController();
  TextEditingController maincontroller = new TextEditingController();
  String _output = '';
  ApiService apiService = new ApiService();
  List<String> selectedreasons = [];
  @override
  void initState() {
    apiService = new ApiService();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        showReasons();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 5,
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.transparent)),
        child: Container(
          height: 345,
          child: Row(
            children: [
              partialCompletion(),
              KeyPad(
                  controller: maincontroller,
                  buttonPressed: (buttonText) {
                    if (buttonText == 'X') {
                      _output = '';
                    } else {
                      _output = _output + buttonText;
                    }

                    print(_output);
                    setState(() {
                      maincontroller.text = _output;
                      // output = int.parse(_output).toStringAsFixed(2);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget partialCompletion() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 260,
                              child: Row(
                                children: [
                                  Text('Partial Completion Reason',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: fonts.openSans,
                                      )),
                                ],
                              ),
                            ),
                            Text('Note: Update Reason in terms of minutes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: fonts.openSans,
                                )),
                          ],
                        )
                      ]),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showReasons();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            'reason',
                            style: TextStyle(
                                    color: Colors.blue, fontSize: 14)),
                          
                          Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
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
                            name: "First Piece & Patrol",
                            quantity: 10,
                            textEditingController: firstPatrolController,
                          ),
                          quantitycell(
                            name: "Spare Changeover",
                            quantity: 10,
                            textEditingController: spareChangeoverController,
                          ),
                          quantitycell(
                            name: "Crimp Height Setting",
                            quantity: 10,
                            textEditingController: crimpHeightSettingController,
                          ),
                          quantitycell(
                            name: "Resetting CFM Program",
                            quantity: 10,
                            textEditingController:
                                resettingCFMProgramController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "New Program Setting CVM/CFM	",
                            quantity: 10,
                            textEditingController:
                                newProgramSettingCVMCFMController,
                          ),
                          quantitycell(
                            name: "Air Pressure Low",
                            quantity: 10,
                            textEditingController: airPressureLowController,
                          ),
                          quantitycell(
                            name: "Machine Taken for Removing CVM	",
                            quantity: 10,
                            textEditingController: machineCleaningController,
                          ),
                          quantitycell(
                            name: "No Material",
                            quantity: 10,
                            textEditingController: noMaterialController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Applicator Changeover	",
                            quantity: 10,
                            textEditingController:
                                applicatorChangeoverController,
                          ),
                          quantitycell(
                            name: "Sink Height Adjustment",
                            quantity: 10,
                            textEditingController:
                                sinkHeightAdjustmentController,
                          ),
                          quantitycell(
                            name: "Feeding Adjustment	",
                            quantity: 10,
                            textEditingController: feedingAdjustmentController,
                          ),
                          quantitycell(
                            name: "Applicator Position Setting		",
                            quantity: 10,
                            textEditingController:
                                applicatorPositionSettingController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Validation",
                            quantity: 10,
                            textEditingController: validationController,
                          ),
                          quantitycell(
                            name: "CFA Crimping Fault",
                            quantity: 10,
                            textEditingController: cFACrimpingFaultController,
                          ),
                          quantitycell(
                            name: "Cable Entangle",
                            quantity: 10,
                            textEditingController: cableEntangleController,
                          ),
                          quantitycell(
                            name: "Job Ticket Issue	",
                            quantity: 10,
                            textEditingController: jobTicketIssueController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Length Changeover",
                            quantity: 10,
                            textEditingController: lengthChangeoverController,
                          ),
                          quantitycell(
                            name: "Terminal Bend",
                            quantity: 10,
                            textEditingController: terminalBendController,
                          ),
                          quantitycell(
                            name: "Cut Off Burr Issue",
                            quantity: 10,
                            textEditingController: cutOffBurrIssueController,
                          ),
                          quantitycell(
                            name: "CVM Error Correction",
                            quantity: 10,
                            textEditingController: cVMErrorController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Cable Feeding Front Unit Problem",
                            quantity: 10,
                            textEditingController:
                                cableFeedingFrontUnitProblemController,
                          ),
                          quantitycell(
                            name: "Drift Limit Reached	",
                            quantity: 10,
                            textEditingController: driftLimitReachedController,
                          ),
                          quantitycell(
                            name: "Machine Slow	",
                            quantity: 10,
                            textEditingController: machineSlowController,
                          ),
                          quantitycell(
                            name: "No Plan for Machine	",
                            quantity: 10,
                            textEditingController: noPlanforMachineController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Terminal Changeover",
                            quantity: 10,
                            textEditingController: terminalChangeoverController,
                          ),
                          quantitycell(
                            name: "Terminal Twist",
                            quantity: 10,
                            textEditingController: terminalTwistController,
                          ),
                          quantitycell(
                            name: "Extrusion Burr Issue",
                            quantity: 10,
                            textEditingController: extrusionBurrIssueController,
                          ),
                          quantitycell(
                            name: "CFM Error",
                            quantity: 10,
                            textEditingController: cFMErrorController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Supplier Taken for Maintenance	",
                            quantity: 10,
                            textEditingController:
                                supplierTakenforMaintenanceController,
                          ),
                          quantitycell(
                            name: "Roller Changeover",
                            quantity: 10,
                            textEditingController: rollerChangeoverController,
                          ),
                          quantitycell(
                            name: "Gripen Unit Problem",
                            quantity: 10,
                            textEditingController: gripenUnitProblemController,
                          ),
                          quantitycell(
                            name: "Technician Not Available	",
                            quantity: 10,
                            textEditingController:
                                technicianNotAvailableController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Coil Changeover	",
                            quantity: 10,
                            textEditingController: coilChangeoverController,
                          ),
                          quantitycell(
                            name: "Bellmouth Adjustment",
                            quantity: 10,
                            textEditingController:
                                bellmouthAdjustmentController,
                          ),
                          quantitycell(
                            name: "Camera Setting	",
                            quantity: 10,
                            textEditingController: cameraSettingController,
                          ),
                          quantitycell(
                            name: "CVM Error",
                            quantity: 10,
                            textEditingController: cVMErrorController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Length Variations	",
                            quantity: 10,
                            textEditingController: lengthVariationsController,
                          ),
                          quantitycell(
                            name: "Power Failure",
                            quantity: 10,
                            textEditingController: powerFailureController,
                          ),
                          quantitycell(
                            name: "Machine Cleaning",
                            quantity: 10,
                            textEditingController: machineCleaningController,
                          ),
                          quantitycell(
                            name: "No Operator",
                            quantity: 10,
                            textEditingController: noOperatorController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Last Piece	",
                            quantity: 10,
                            textEditingController: lastPieceController,
                          ),
                          quantitycell(
                            name: "Curling Adjustment",
                            quantity: 10,
                            textEditingController: curlingAdjustmentController,
                          ),
                          quantitycell(
                            name: "Wire Feeding Adjustment",
                            quantity: 10,
                            textEditingController:
                                wireFeedingAdjustmentController,
                          ),
                          quantitycell(
                            name: "CVM Program Reloading",
                            quantity: 10,
                            textEditingController: cVMErrorController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Sensor Not Working",
                            quantity: 10,
                            textEditingController: sensorNotWorkingController,
                          ),
                          quantitycell(
                            name: "Preventive Maintenance	",
                            quantity: 10,
                            textEditingController:
                                preventiveMaintenanceController,
                          ),
                          quantitycell(
                            name: "Meeting	",
                            quantity: 10,
                            textEditingController: meetingController,
                          ),
                          quantitycell(
                            name: "System Fault	",
                            quantity: 10,
                            textEditingController: systemFaultController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 250,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      side: BorderSide(color: Colors.green))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green.shade200;
                                  return Colors
                                      .white; // Use the component's default.
                                },
                              ),
                            ),
                            child: Text(
                              "Accept and Continue Process",
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: fonts.openSans,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              PostpartiallyComplete postpartiallyComplete =
                                  new PostpartiallyComplete(
                                finishedGoods: widget.schedule.finishedGoods,
                                purchaseOrder:
                                    widget.schedule.purchaseOrder.toString(),
                                orderIdentification: "",
                                cablePartNumber:
                                    "${widget.schedule.cablePartNo}",
                                cutLength: "${widget.schedule.length}",
                                color: widget.schedule.wireColour,
                                scheduleIdentification:
                                    widget.schedule.scheduleId,
                              );
                              apiService
                                  .postpartialComplete(postpartiallyComplete,
                                      int.parse(widget.schedule.awg))
                                  .then((value) {
                                if (value) {
                                  widget.continueProcess("scanBundle");
                                } else {}
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 250,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      side: BorderSide(color: Colors.green))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green.shade200;
                                  return Colors.green.shade500
                                      ; // Use the component's default.
                                },
                              ),
                            ),
                            child: Text(
                              "Save & End Process",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: fonts.openSans,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              PostpartiallyComplete postpartiallyComplete =
                                  new PostpartiallyComplete(
                                finishedGoods: widget.schedule.finishedGoods,
                                purchaseOrder:
                                    widget.schedule.purchaseOrder.toString(),
                                orderIdentification: "",
                                cablePartNumber:
                                    "${widget.schedule.cablePartNo}",
                                cutLength: "${widget.schedule.length}",
                                color: widget.schedule.wireColour,
                                scheduleIdentification:
                                    widget.schedule.scheduleId,
                              );
                              apiService
                                  .postpartialComplete(postpartiallyComplete,
                                      int.parse(widget.schedule.awg))
                                  .then((value) {
                                if (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Location(
                                              type: "process",
                                              employee: widget.employee,
                                              machine: widget.machine, locationType: LocationType.finaTtransfer,
                                            )),
                                  );
                                }
                              });
                            }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell(
      {required String name,
      required int quantity,
      required TextEditingController textEditingController,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 35,
                width: 140,
                child: TextField(
                  showCursor: false,
                  controller: textEditingController,
                  
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      _output = '';
                      maincontroller = textEditingController;
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

  Future<void> showReasons() async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
            child: ReasonSelection(
          selectedList: selectedreasons,
          onChanged: (value) {
            setState(() {
              selectedreasons = value;
            });
          },
        ));
      },
    );
  }
}
