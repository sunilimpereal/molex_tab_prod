import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:molex/main.dart';
import 'package:molex/model_api/cableDetails_model.dart';
import 'package:molex/model_api/crimping/double_crimping/doubleCrimpingEjobDetail.dart';
import 'package:molex/screens/widgets/showBundles.dart';
import 'package:molex/service/apiService.dart';

showPreparationInfo({
  required BuildContext context,
  required String fgNumber,
  required String length,
  required String color,
  required int awg,
  required String cablePartNo,
  required int terminalFrom,
  required int terminalTo,
}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PreparationInfo(
        fgNumber: fgNumber,
        cablePartNo: cablePartNo,
        length: length,
        color: color,
        awg: awg,
        terminalFrom: terminalFrom,
        terminalTo: terminalTo,
      );
    },
  );
}

class PreparationInfo extends StatefulWidget {
  String fgNumber;
  String length;
  String color;
  int awg;
  String cablePartNo;
  int terminalFrom;
  int terminalTo;
  PreparationInfo(
      {Key? key,
      required this.awg,
      required this.color,
      required this.fgNumber,
      required this.length,
      required this.cablePartNo,
      required this.terminalFrom,
      required this.terminalTo})
      : super(key: key);
  @override
  _PreparationInfoState createState() => _PreparationInfoState();
}

class _PreparationInfoState extends State<PreparationInfo> {
  ApiService apiService = new ApiService();
  TextStyle dataTextStyle =
      TextStyle(fontSize: 11, fontWeight: FontWeight.normal, fontFamily: fonts.openSans);
  TextStyle headingTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: fonts.openSans);
  TextStyle subHeadingStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontFamily: fonts.openSans);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.96,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Cable Terminal Detail",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal, fontFamily: fonts.openSans),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 5),
                  child: Text(
                    "Fg : ${widget.fgNumber}    CablePart: ${widget.cablePartNo}",
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal, fontFamily: fonts.openSans),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.807,
                  width: MediaQuery.of(context).size.width * 0.96,
                  child: FutureBuilder<List<CableDetails>?>(
                      future: apiService.getPreparationCableDetails(
                          fgpartNo: widget.fgNumber,
                          cablepartno: widget.cablePartNo,
                          length: widget.length,
                          color: widget.color,
                          awg: widget.awg,
                          terminalPartNumberFrom: widget.terminalFrom,
                          terminalPartNumberTo: widget.terminalTo,
                          isCrimping: false),
                      builder: (context, snapshot) {
                        List<CableDetails>? cableDetail = snapshot.data;
                        log(snapshot.toString());
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          );

                        if (snapshot.data?.length == 0 || !snapshot.hasData)
                          return Center(
                            child: Text('No data found'),
                          );
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: CustomTable(
                            height: MediaQuery.of(context).size.height * 0.82,
                            colums: [
                              CustomCell(
                                  width: 170, child: Text('Description', style: headingTextStyle)),
                              CustomCell(
                                  width: 170,
                                  child: Text('Type',
                                      textAlign: TextAlign.center, style: headingTextStyle)),
                              CustomCell(
                                  width: 150,
                                  child: Text('Strip Length',
                                      textAlign: TextAlign.center, style: headingTextStyle)),
                              CustomCell(width: 110, child: Text('Info', style: headingTextStyle)),
                              CustomCell(width: 120, child: Text('Color', style: headingTextStyle)),
                              CustomCell(
                                  width: 120,
                                  child: Text('cable \nSequence', style: headingTextStyle)),
                            ],
                            rows: cableDetail!.map((e) {
                              return CustomRow(cells: [
                                CustomCell(
                                    width: 170,
                                    child: Column(
                                      children: [
                                        Text("${e.description}", style: subHeadingStyle),
                                      ],
                                    )),
                                CustomCell(
                                    width: 170,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimp From:", style: dataTextStyle),
                                            Text("${e.crimpFrom}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimp To:", style: dataTextStyle),
                                            Text("${e.crimpTo}", style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 150,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Strip Length From:", style: dataTextStyle),
                                            Text("${e.stripLengthFrom}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Strip Length To:", style: dataTextStyle),
                                            Text("${e.stripLengthTo}", style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 110,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text("AWG:", style: dataTextStyle),
                                        //     Text("${e.}", style: subHeadingStyle),
                                        //   ],
                                        // ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Cut Length:", style: dataTextStyle),
                                            Text("${e.cutLengthSpec}", style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimp:", style: dataTextStyle),
                                            Text("${e.crimpColor}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Wire Cutting:", style: dataTextStyle),
                                            Text("${e.wireCuttingSortingNumber}",
                                                style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Wire Cutting:", style: dataTextStyle),
                                            Text("${e.wireCuttingSortingNumber}",
                                                style: subHeadingStyle),
                                          ],
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text("Crimping:", style: dataTextStyle),
                                        //     Text("${e.}",
                                        //         style: subHeadingStyle),
                                        //   ],
                                        // ),
                                      ],
                                    )),
                              ]);
                            }).toList(),
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        );
                      }),
                ),
              ],
            ),
            Positioned(
                top: 0,
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
        ),
      ),
    );
  }
}
