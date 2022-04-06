import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex/model_api/cableTerminalA_model.dart';
import 'package:molex/model_api/cableTerminalB_model.dart';
import 'package:molex/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex/screens/widgets/showBundles.dart';
import 'package:molex/service/apiService.dart';

import '../../../main.dart';

Future<void> showExtraCrimpingSchedule(
    {required BuildContext context,
    required List<CrimpingSchedule> crimpingSchedules,
    required CrimpingSchedule selectedSchedule}) async {
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
          child: ExtraCrimpingScheduls(
        crimpingSchedules: crimpingSchedules,
        selectedSchedule: selectedSchedule,
      ));
    },
  );
}

class ExtraCrimpingScheduls extends StatefulWidget {
  final List<CrimpingSchedule> crimpingSchedules;
  final CrimpingSchedule selectedSchedule;
  const ExtraCrimpingScheduls(
      {Key? key, required this.crimpingSchedules, required this.selectedSchedule})
      : super(key: key);

  @override
  _ExtraCrimpingSchedulsState createState() => _ExtraCrimpingSchedulsState();
}

class _ExtraCrimpingSchedulsState extends State<ExtraCrimpingScheduls> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        title: Stack(
          children: [
            showSchedules(),
            Positioned(
                top: -10,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))
          ],
        ));
  }

  Widget showSchedules() {
    TextStyle dataTextStyle =
        TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: fonts.openSans);
    TextStyle headingTextStyle =
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: fonts.openSans);
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              "Schedules",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ],
        ),
        CustomTable(
          height: MediaQuery.of(context).size.height * 0.7,
          colums: [
            CustomCell(width: 85, child: Text('Order Id', style: headingTextStyle)),
            CustomCell(width: 85, child: Text('FG Part', style: headingTextStyle)),
            CustomCell(width: 85, child: Text('Schedule ID', style: headingTextStyle)),
            CustomCell(width: 100, child: Text('Cable Part No.', style: headingTextStyle)),
            CustomCell(width: 110, child: Text('Process', style: headingTextStyle)),
            CustomCell(width: 100, child: Text('Termianl From', style: headingTextStyle)),
            CustomCell(width: 100, child: Text('Terminal To', style: headingTextStyle)),
            CustomCell(width: 70, child: Text('Crimp Color', style: headingTextStyle)),
            CustomCell(width: 70, child: Text('Wire Color', style: headingTextStyle)),
            CustomCell(width: 55, child: Text('AWG', style: headingTextStyle)),
          ],
          rows: widget.crimpingSchedules
              .where((element) => element.scheduleId == widget.selectedSchedule.scheduleId)
              .map((e) {
            return CustomRow(cells: [
              CustomCell(width: 85, child: Text('${e.purchaseOrder}', style: headingTextStyle)),
              CustomCell(width: 85, child: Text('${e.finishedGoods}', style: headingTextStyle)),
              CustomCell(width: 85, child: Text('${e.scheduleId}', style: headingTextStyle)),
              CustomCell(width: 100, child: Text('${e.cablePartNo}', style: headingTextStyle)),
              // CustomCell(width: 100, child: Text('${e.process}', style: headingTextStyle)),
              CustomCell(
                  width: 110,
                  child: FutureBuilder<CableTerminalA?>(
                    future: ApiService().getCableTerminalA(
                        cablepartno: e.cablePartNo.toString(),
                        fgpartNo: e.finishedGoods.toString(),
                        length: e.length.toString(),
                        color: e.wireColour,
                        isCrimping: true,
                        crimpFrom: e.crimpFrom,
                        crimpTo: e.crimpTo,
                        wireCuttingSortNum: e.wireCuttingSortingNumber.toString(),
                        awg: int.parse(e.awg)),
                    builder: (c, snapshotA) {
                      if (snapshotA.connectionState == ConnectionState.waiting) return Text("...");
                      if (!snapshotA.hasData && snapshotA.connectionState == ConnectionState.done)
                        return Text("error A");

                      return FutureBuilder<CableTerminalB?>(
                        future: ApiService().getCableTerminalB(
                            isCrimping: false,
                            cablepartno: e.cablePartNo.toString(),
                            fgpartNo: e.finishedGoods.toString(),
                            length: e.length.toString(),
                            color: e.wireColour,
                            awg: int.parse(e.awg)),
                        builder: (c, snapshotB) {
                          if (snapshotB.connectionState == ConnectionState.waiting)
                            return Text("...");
                          if (!snapshotB.hasData &&
                              snapshotB.connectionState == ConnectionState.done)
                            return Text("error B");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Crimp From : ${snapshotA.data!.processType}',
                                  style: headingTextStyle.copyWith(fontSize: 11.5)),
                              Text('Crimp To : ${snapshotB.data!.processType}',
                                  style: headingTextStyle.copyWith(fontSize: 11.5)),
                            ],
                          );
                        },
                      );
                    },
                  )),
              CustomCell(
                  width: 100,
                  child: FutureBuilder<CableTerminalA?>(
                    future: ApiService().getCableTerminalA(
                        cablepartno: e.cablePartNo.toString(),
                        fgpartNo: e.finishedGoods.toString(),
                        length: e.length.toString(),
                        color: e.wireColour,
                        isCrimping: true,
                        crimpFrom: e.crimpFrom,
                        crimpTo: e.crimpTo,
                        wireCuttingSortNum: e.wireCuttingSortingNumber.toString(),
                        awg: int.parse(e.awg)),
                    builder: (c, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return Text("...");
                      if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done)
                        return Text("error");

                      return Text('${snapshot.data!.terminalPart}', style: headingTextStyle);
                    },
                  )),
              CustomCell(
                  width: 100,
                  child: FutureBuilder<CableTerminalB?>(
                    future: ApiService().getCableTerminalB(
                        isCrimping: false,
                        cablepartno: e.cablePartNo.toString(),
                        fgpartNo: e.finishedGoods.toString(),
                        length: e.length.toString(),
                        color: e.wireColour,
                        awg: int.parse(e.awg)),
                    builder: (c, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return Text("...");
                      if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done)
                        return Text("error");

                      return Text('${snapshot.data!.terminalPart}', style: headingTextStyle);
                    },
                  )),
              CustomCell(width: 70, child: Text('${e.crimpColor}', style: headingTextStyle)),
              CustomCell(width: 70, child: Text('${e.wireColour}', style: headingTextStyle)),
              CustomCell(width: 55, child: Text('${e.awg}', style: headingTextStyle)),
            ]);
          }).toList(),
          width: MediaQuery.of(context).size.width * 0.95,
        ),
      ],
    ));
  }
}
