import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex/model_api/Transfer/postgetBundleMaster.dart';
import 'package:molex/model_api/cableTerminalA_model.dart';
import 'package:molex/model_api/cableTerminalB_model.dart';
import 'package:molex/model_api/generateLabel_model.dart';
import 'package:molex/model_api/login_model.dart';
import 'package:molex/model_api/machinedetails_model.dart';
import 'package:molex/model_api/process1/getBundleListGl.dart';
import 'package:molex/model_api/schedular_model.dart';
import 'package:molex/screens/widgets/showBundleDetail.dart';
import 'package:molex/screens/widgets/showBundles.dart';
import 'package:molex/service/apiService.dart';

import '../../../main.dart';
import '../process/generateLabel.dart';

class ShowBundleListWIP extends StatefulWidget {
  Schedule schedule;
  PostgetBundleMaster postgetBundleMaste;
  CableTerminalA terminalA;
  CableTerminalB terminalB;
  MachineDetails machine;
  Employee employee;

  ShowBundleListWIP(
      {@required this.schedule,
      @required this.employee,
      @required this.terminalA,
      @required this.terminalB,
      @required this.machine,
      @required this.postgetBundleMaste})
      : super();

  @override
  _ShowBundleListWIPState createState() => _ShowBundleListWIPState();
}

class _ShowBundleListWIPState extends State<ShowBundleListWIP> {
  ApiService apiService;

  String _printerStatus = "";
  bool printing = false;
  String printingId = "";
  @override
  void initState() {
    apiService = new ApiService();

    super.initState();
  }

  static const platform = const MethodChannel('com.impereal.dev/tsc');
  Future<bool> _print({
    String ipaddress,
    String bq,
    String qr,
    String routenumber1,
    String date,
    String orderId,
    String fgPartNumber,
    String cutlength,
    String cablepart,
    String wireGauge,
    String terminalfrom,
    String terminalto,
    String userid,
    String shift,
    String machine,
  }) async {
    String printerStatus;

    try {
      final String result = await platform.invokeMethod('Print', {
        "ipaddress": ipaddress,
        "bundleQty": bq,
        "qr": qr,
        "routenumber1": routenumber1,
        "date": date,
        "orderId": orderId,
        "fgPartNumber": fgPartNumber,
        "cutlength": cutlength,
        "cutpart": cablepart,
        "wireGauge": wireGauge,
        "terminalfrom": terminalfrom,
        "terminalto": terminalto,
        "userid": userid,
        "shift": shift,
        "machine": machine,
      });
      printerStatus = 'Printer status : $result % .';
      showPrintalert(context, "Printer status : $result % .");
      Fluttertoast.showToast(
          msg: "$printerStatus",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return true;
    } on PlatformException catch (e) {
      printerStatus = "Failed to get printer: '${e.message}'.";
      showPrintalert(context, "${e.message}");
      Fluttertoast.showToast(
          msg: "$printerStatus",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        _printerStatus = printerStatus;
      });
      return false;
    } catch (e) {
      log("message ${e.toString()}");
      showPrintalert(context, "${e.toString()}");
      Fluttertoast.showToast(
          msg: "${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(0),
      title: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.white,
        child: Stack(
          children: [
            // Container(
            //   child: Center(
            //     child: Container(
            //       padding: EdgeInsets.all(16),
            //       child: Row(
            //         children: [CircularProgressIndicator(), Text("Printing")],
            //       ),
            //     ),
            //   ),
            // ),
            FutureBuilder(
                future: apiService.getBundlesInSchedule(
                    postgetBundleMaster: widget.postgetBundleMaste,
                    scheduleID: widget.schedule.scheduledId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<BundlesRetrieved> bundles = snapshot.data;
                    List<GeneratedBundle> genbundles = bundles.map((bundle) {
                      return GeneratedBundle(
                          bundleDetail: bundle,
                          bundleQty: bundle.bundleQuantity.toString(),
                          transferBundleToBin: TransferBundleToBin(
                              binIdentification: bundle.binId.toString(),
                              locationId: bundle.locationId.toString()),
                          label: GeneratedLabel(
                            finishedGoods: bundle.finishedGoodsPart,
                            cablePartNumber: bundle.cablePartNumber,
                            cutLength: bundle.cutLengthSpecificationInmm,
                            wireGauge: bundle.awg,
                            bundleId: bundle.bundleIdentification,
                            routeNo: "${widget.schedule.route}",
                            status: 0,
                            bundleQuantity: bundle.bundleQuantity,
                            terminalFrom: widget.terminalA.terminalPart,
                            terminalTo: widget.terminalB.terminalPart,
                            //  terminalFrom: bundle.t
                            //todo terminal from,terminal to
                            //todo route no
                            //
                          ));
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
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
                                'Reprint',
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
                          rows: genbundles
                              .map((e) => CustomRow(cells: [
                                    CustomCell(
                                      width: 100,
                                      child: Text(
                                        e.label.bundleId.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    CustomCell(
                                      width: 100,
                                      color: e.bundleDetail.binId == null
                                          ? Colors.red.shade100
                                          : Colors.transparent,
                                      child: Text(
                                        "${e.bundleDetail.binId ?? "-"}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    CustomCell(
                                      width: 100,
                                      color: e.bundleDetail.locationId == null
                                          ? Colors.red.shade100
                                          : Colors.transparent,
                                      child: Text(
                                        e.bundleDetail.locationId ?? "-",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    CustomCell(
                                      width: 100,
                                      child: Text(
                                        "${e.bundleQty}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    CustomCell(
                                      width: 100,
                                      child: ReprintButton(
                                        onPressed: () async {
                                          DateTime now = DateTime.now();
                                          //TODO
                                          bool a = await _print(
                                            ipaddress:
                                                "${widget.machine.printerIp}",
                                            // ipaddress: "172.26.59.14",
                                            bq: e.bundleQty,
                                            qr: "${e.label.bundleId}",
                                            routenumber1: "${e.label.routeNo}",
                                            date: now.day.toString() +
                                                "-" +
                                                now.month.toString() +
                                                "-" +
                                                now.year.toString(),
                                            orderId:
                                                "${widget.schedule.orderId}",
                                            fgPartNumber:
                                                "${widget.schedule.finishedGoodsNumber}",
                                            cutlength:
                                                "${widget.schedule.length}",
                                            cablepart:
                                                "${widget.schedule.cablePartNumber}",
                                            wireGauge: "${e.label.wireGauge}",
                                            terminalfrom:
                                                "${e.label.terminalFrom}",
                                            terminalto: "${e.label.terminalTo}",

                                            userid: "${widget.employee.empId}",
                                            shift:
                                                "${widget.schedule.shiftNumber}",
                                            machine:
                                                "${widget.machine.machineNumber}",
                                          );
                                          return a;
                                          // return false;
                                        },
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
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    focusColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, size: 20, color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Future<void> showBundleDetail(GeneratedBundle generatedBundle) async {
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
                                      data: generatedBundle.label.bundleId),
                                  field(
                                      title: "Bundle Qty",
                                      data:
                                          generatedBundle.bundleQty.toString()),
                                  field(
                                      title: "Bundle Status",
                                      data: "${generatedBundle.label.status}"),
                                  field(
                                      title: "Cut Length",
                                      data:
                                          "${generatedBundle.label.cutLength}"),
                                  field(
                                      title: "Color",
                                      data:
                                          "${generatedBundle.bundleDetail.color}"),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                      title: "Cable Part Number",
                                      data: generatedBundle
                                          .bundleDetail.cablePartNumber
                                          .toString()),
                                  field(
                                    title: "Cable part Description",
                                    data: generatedBundle
                                        .bundleDetail.cablePartDescription,
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle
                                        .bundleDetail.finishedGoodsPart
                                        .toString(),
                                  ),
                                  field(
                                    title: "Order Id",
                                    data: generatedBundle.bundleDetail.orderId,
                                  ),
                                  field(
                                    title: "Update From",
                                    data: generatedBundle
                                        .bundleDetail.updateFromProcess,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                    title: "Machine Id",
                                    data: generatedBundle
                                        .bundleDetail.machineIdentification,
                                  ),
                                  field(
                                    title: "Schedule ID",
                                    data: generatedBundle
                                        .bundleDetail.scheduledId
                                        .toString(),
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle
                                        .bundleDetail.finishedGoodsPart
                                        .toString(),
                                  ),
                                  field(
                                    title: "Bin Id",
                                    data: generatedBundle.bundleDetail.binId
                                        .toString(),
                                  ),
                                  field(
                                    title: "Location Id",
                                    data:
                                        generatedBundle.bundleDetail.locationId,
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

  Widget field({String title, String data}) {
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
}

class ReprintButton extends StatefulWidget {
  Function onPressed;
  ReprintButton({this.onPressed}) : super();

  @override
  _ReprintButtonState createState() => _ReprintButtonState();
}

class _ReprintButtonState extends State<ReprintButton> {
  bool loading;
  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((states) => Colors.green),
      ),
      onPressed: loading
          ? () {}
          : () async {
              setState(() {
                loading = true;
              });
              bool a = await widget.onPressed();
              if (a) {
                setState(() {
                  loading = false;
                });
              }
              Future.delayed(Duration(seconds: 6)).then((value) {
                setState(() {
                  loading = false;
                });
              });
            },
      child: loading
          ? Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              ' Reprint',
              style: TextStyle(fontSize: 12),
            ),
    );
  }
}

Future<void> showPrintalert(BuildContext context, String title) {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context2) {
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context2);
          },
        );
        return AlertDialog(
          title: Text(title),
          actions: [
            okButton,
          ],
        );
      });
}
