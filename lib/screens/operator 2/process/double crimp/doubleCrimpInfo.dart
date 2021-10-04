import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:molex/main.dart';
import 'package:molex/model_api/crimping/double_crimping/doubleCrimpingEjobDetail.dart';
import 'package:molex/screens/widgets/showBundles.dart';
import 'package:molex/service/apiService.dart';

showDoubleCrimpInfo({required BuildContext context, required String fg, required String processType}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DoubleCrimpInfo(
        fg: fg,
        processType: processType,
      );
    },
  );
}

class DoubleCrimpInfo extends StatefulWidget {
  final String fg;
  final String processType;
  const DoubleCrimpInfo({Key? key, required this.processType, required this.fg}) : super(key: key);
  @override
  _DoubleCrimpInfoState createState() => _DoubleCrimpInfoState();
}

class _DoubleCrimpInfoState extends State<DoubleCrimpInfo> {
  ApiService apiService = new ApiService();
  TextStyle dataTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: fonts.openSans);
  TextStyle headingTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: fonts.openSans);
  TextStyle subHeadingStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: fonts.openSans);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        width: MediaQuery.of(context).size.width * 0.82,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Crimping Detail",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily: fonts.openSans),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: FutureBuilder<List<EJobTicketMasterDetails>?>(
                      future: apiService.getDoubleCrimpDetail(fgNo: widget.fg, crimpType: widget.processType),
                      builder: (context, snapshot) {
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

                        return Container(
                          padding: EdgeInsets.all(16),
                          child: CustomTable(
                            height: MediaQuery.of(context).size.height * 0.82,
                            colums: [
                              CustomCell(width: 85, child: Text('Fg', style: headingTextStyle)),
                              CustomCell(width: 85, child: Text('Part No.', style: headingTextStyle)),
                              CustomCell(width: 200, child: Text('Type', textAlign: TextAlign.center, style: headingTextStyle)),
                              CustomCell(width: 120, child: Text('info', style: headingTextStyle)),
                              CustomCell(width: 140, child: Text('Color', style: headingTextStyle)),
                              CustomCell(width: 120, child: Text('cable \nSequence', style: headingTextStyle)),
                            ],
                            rows: details!.map((e) {
                              return CustomRow(cells: [
                                CustomCell(width: 85, child: Text("${e.fgPartNumber}", style: subHeadingStyle)),
                                CustomCell(width: 85, child: Text("${e.cablePartNumber}", style: subHeadingStyle)),
                                CustomCell(
                                    width: 200,
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
                                            Text("${e.wireCuttingSortingNumber}", style: subHeadingStyle),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Crimping:", style: dataTextStyle),
                                            Text("${e.crimpingSortingNumber}", style: subHeadingStyle),
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
