import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:molex/main.dart';
import 'package:molex/model_api/crimping/double_crimping/doubleCrimpingEjobDetail.dart';
import 'package:molex/screens/widgets/showBundles.dart';
import 'package:molex/service/apiService.dart';

showDoubleCrimpInfo(
    {required BuildContext context,
    required String fg,
    required String cablepart,
    required String processType,
    bool? crimping,
    List<EJobTicketMasterDetails> Function(List<EJobTicketMasterDetails>)? filter}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DoubleCrimpInfo(
        fg: fg,
        cablepart: cablepart,
        processType: processType,
        isCrimping: crimping,
        filter: filter,
      );
    },
  );
}

class DoubleCrimpInfo extends StatefulWidget {
  final String fg;
  final String processType;
  final String cablepart;
  final bool? isCrimping;
  List<EJobTicketMasterDetails> Function(List<EJobTicketMasterDetails>)? filter;
  DoubleCrimpInfo(
      {Key? key,
      required this.processType,
      required this.cablepart,
      required this.fg,
      this.isCrimping,
      this.filter})
      : super(key: key);
  @override
  _DoubleCrimpInfoState createState() => _DoubleCrimpInfoState();
}

class _DoubleCrimpInfoState extends State<DoubleCrimpInfo> {
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
        height: MediaQuery.of(context).size.height * 0.88,
        width: MediaQuery.of(context).size.width * 0.96,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Crimping Detail",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal, fontFamily: fonts.openSans),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  width: MediaQuery.of(context).size.width * 0.96,
                  child: FutureBuilder<List<EJobTicketMasterDetails>?>(
                      future: apiService.getDoubleCrimpDetail(
                          cablepart: widget.cablepart,
                          fgNo: widget.fg,
                          crimpType: widget.processType),
                      builder: (context, snapshot) {
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
                        List<EJobTicketMasterDetails>? details = snapshot.data;
                        if (widget.isCrimping == null ? false : widget.isCrimping!) {
                          details = widget.filter!(details ?? []);
                        }
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: CustomTable(
                            height: MediaQuery.of(context).size.height * 0.82,
                            colums: [
                              CustomCell(width: 90, child: Text('Fg', style: headingTextStyle)),
                              CustomCell(
                                  width: 80, child: Text('Part No.', style: headingTextStyle)),
                              CustomCell(
                                  width: 120, child: Text('Terminal', style: headingTextStyle)),
                              CustomCell(
                                  width: 180,
                                  child: Text('Type',
                                      textAlign: TextAlign.center, style: headingTextStyle)),
                              CustomCell(width: 120, child: Text('info', style: headingTextStyle)),
                              CustomCell(width: 130, child: Text('Color', style: headingTextStyle)),
                              CustomCell(
                                  width: 120,
                                  child: Text('cable \nSequence', style: headingTextStyle)),
                            ],
                            rows: details!.map((e) {
                              return CustomRow(cells: [
                                CustomCell(
                                    width: 90,
                                    child: Text("${e.fgPartNumber}", style: subHeadingStyle)),
                                CustomCell(
                                    width: 80,
                                    child: Text("${e.cablePartNumber}", style: subHeadingStyle)),
                                CustomCell(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("From:", style: dataTextStyle),
                                            Text("${e.terminalPartNumberFrom}",
                                                style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("To:", style: dataTextStyle),
                                            Text("${e.terminalPartNumberTo}",
                                                style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimp From:", style: dataTextStyle),
                                            Text("${e.typeOfCrimpFrom}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimp To:", style: dataTextStyle),
                                            Text("${e.typeOfCrimpTo}", style: subHeadingStyle),
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
                                            Text("AWG:", style: dataTextStyle),
                                            Text("${e.awg}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Cut Length:", style: dataTextStyle),
                                            Text("${e.length}", style: subHeadingStyle),
                                          ],
                                        ),
                                      ],
                                    )),
                                CustomCell(
                                    width: 130,
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
                                            Text("${e.wireCuttingColor}", style: subHeadingStyle),
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimping:", style: dataTextStyle),
                                            Text("${e.crimpingSortingNumber}",
                                                style: subHeadingStyle),
                                          ],
                                        ),
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
