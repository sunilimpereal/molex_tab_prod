import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model_api/kitting_plan/getKittingData_model.dart';
import '../../model_api/kitting_plan/save_kitting_model.dart';
import '../../model_api/login_model.dart';
import '../widgets/time.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/apiService.dart';
import 'package:google_fonts/google_fonts.dart';

class KittingDash extends StatefulWidget {
  Employee employee;
  KittingDash({this.employee});
  @override
  _KittingDashState createState() => _KittingDashState();
}

class _KittingDashState extends State<KittingDash> {
  String fgNumber;
  String orderId;
  String qty;
  ApiService apiService;
  List<KittingPost> kittingList = [];
  bool loading = false;
  bool loadingSave = false;

  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }
  //369100018
  //846883996

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
       
        
        title: const Text(
          'Kitting',
          style: TextStyle(color: Colors.red),
        ),
        elevation: 0,
       
        actions: [
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
                        color: Colors.grey[100],
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
                  ],
                )
              ],
            ),
          ),
          TimeDisplay(),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              search(),
              save(),
            ],
          ),
          dataTable()
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[100],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      //TODO
                      setState(() {
                        fgNumber = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "Fg Number",
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[100],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      //TODO
                      setState(() {
                        orderId = value;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: "Order ID",
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[100],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      qty = value;
                      //TODO
                    },
                    decoration: InputDecoration(
                        labelText: "Qty",
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(color: Colors.transparent))),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blue[200];
                    return Colors.blue[500]; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                setState(() {
                  loading = true;
                });
                FocusScope.of(context).unfocus();
                FocusNode focusNode = FocusNode();
                focusNode.unfocus();
                PostKittingData postKittingData = new PostKittingData(
                    orderNo: orderId,
                    fgNumber: int.parse(fgNumber),
                    quantity: int.parse(qty));
                apiService.getkittingDetail(postKittingData).then((value) {
                  //84671404
                  //369100004
                  if (value != null) {
                    setState(() {
                      List<KittingEJobDtoList> kitlis = value;
                      for (KittingEJobDtoList kit in kitlis) {
                        kittingList.add(KittingPost(
                            kittingEJobDtoList: kit,
                            selectedBundles: getList(kit.bundleMaster)));
                        log("${kit.bundleMaster.length}");
                      }
                      loading = false;
                    });
                  } else {
                    setState(() {
                      loading = false;
                    });
                    //TODO toast
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? Container(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 6),
                          Text(
                            "Search",
                            style: TextStyle(fontSize: 15),
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

  getList(List<BundleMaster> bundleList) {
    List<BundleMaster> temp = [];
    for (BundleMaster b in bundleList) {
      temp.add(b);
    }
    return temp;
  }

  Widget dataTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 450,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 15,
              columns: [
                DataColumn(
                  label: Text(
                    'FG',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Cablepart No.',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                )),
                DataColumn(
                  label: Text(
                    ' AWG',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cut Length',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Bundles',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                )),
                DataColumn(
                  label: Text(
                    'Color',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Order Qty',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Dispatched Qty',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Pending Qty',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ))
              ],
              rows: kittingList
                  .map(
                    (e) => DataRow(cells: <DataCell>[
                      DataCell(Text(
                        "${e.kittingEJobDtoList.fgNumber}",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        "${e.kittingEJobDtoList.cableNumber}",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        "${e.kittingEJobDtoList.wireGuage}" ?? "",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        "${e.kittingEJobDtoList.cutLength}" ?? "",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${e.kittingEJobDtoList.bundleMaster.length}" ??
                                  '-',
                              style: TextStyle(fontSize: 12),
                            ),
                            IconButton(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onPressed: () {
                                  showBundleDetail(
                                      context: context,
                                      bundles:
                                          e.kittingEJobDtoList.bundleMaster,
                                      selectedBundles: e.selectedBundles);
                                },
                                icon: Icon(
                                  Icons.launch,
                                  size: 16,
                                  color: Colors.red[500],
                                ))
                          ],
                        ),
                      )),
                      DataCell(Text(
                        e.kittingEJobDtoList.cableColor ?? "",
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text("$qty")),
                      // DataCell(Text("${e.selectedBundles.length}")),
                      // DataCell(Text(
                      //     "${e.kittingEJobDtoList.bundleMaster.length - e.selectedBundles.length}")),
                      DataCell(Text("${getBundleQty(e.selectedBundles)}")),
                      DataCell(Text(
                          "${getPendingQty(e.kittingEJobDtoList.bundleMaster, e.selectedBundles)}")),
                    ]),
                  )
                  .toList(),
            ),
          )),
    );
  }

  int getBundleQty(List<BundleMaster> bundles) {
    int sum =
        bundles.map((e) => e.bundleQuantity).toList().fold(0, (p, c) => p + c);
    return sum;
  }

  int getPendingQty(
    List<BundleMaster> bundlesmaster,
    List<BundleMaster> selectedBundle1,
  ) {
    int sum1 = bundlesmaster
        .map((e) => e.bundleQuantity)
        .toList()
        .fold(0, (p, c) => p + c);
    int sum2 = selectedBundle1
        .map((e) => e.bundleQuantity)
        .toList()
        .fold(0, (p, c) => p + c);
    return sum1 - sum2;
  }

  Future<void> showBundleDetail(
      {BuildContext context,
      List<BundleMaster> bundles,
      List<BundleMaster> selectedBundles}) async {
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
            child: ShowBundleList(
          bundleList: bundles,
          selectedBundleList: selectedBundles,
          reload: () {
            setState(() {});
          },
        ));
      },
    );
  }

  Widget save() {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(color: Colors.transparent))),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.green[200];
              return Colors.green[500]; // Use the component's default.
            },
          ),
        ),
        onPressed: () {
          setState(() {
            loadingSave = true;
          });
          List<SaveKitting> saveKitting = kittingList.map((e) {
            // for (KittingPost e in kittingList) {
            // SaveKitting saveKitting =
            return new SaveKitting(
              fgPartNumber: e.kittingEJobDtoList.fgNumber,
              orderId: orderId,
              cablePartNumber: e.kittingEJobDtoList.cableNumber.toString(),
              cableType: "",
              length: e.kittingEJobDtoList.cutLength,
              wireCuttingColor: e.kittingEJobDtoList.cableColor,
              average: 0,
              customerName: "",
              routeMaster: "",
              scheduledQty: 0,
              binId: "",
              binLocation: "",
              bundleQty: 0,
              bundleId:
                  e.selectedBundles.map((e) => e.bundleIdentification).toList(),
            );
          }).toList();
          apiService.postKittingData(saveKitting).then((value) {
            if (value) {
              setState(() {
                loadingSave = false;
              });
            } else {
              log("saved ${saveKitting}");
              setState(() {
                loadingSave = false;
              });
            }
          });
          // }).toList();

          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: loadingSave
              ? Container(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  'save',
                  style: TextStyle(fontSize: 16),
                ),
        ));
  }
}

class ShowBundleList extends StatefulWidget {
  List<BundleMaster> bundleList;
  List<BundleMaster> selectedBundleList;
  Function reload;

  ShowBundleList({this.reload, this.bundleList, this.selectedBundleList});
  @override
  _ShowBundleListState createState() => _ShowBundleListState();
}

class _ShowBundleListState extends State<ShowBundleList> {
  List<BundleMaster> selBundles = [];

  @override
  void initState() {
    for (BundleMaster b in widget.bundleList) {
      selBundles.add(b);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("selected ${widget.selectedBundleList.length}");
    log("bundle: ${widget.bundleList.length}");

    return AlertDialog(
      title: Container(
        width: 700,
        height: 500,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  field(
                      title: "Fg No.",
                      data: "${widget.bundleList[0].finishedGoodsPart}",
                      width: 120),
                  field(
                      title: "Cable Part No.",
                      data: "${widget.bundleList[0].cablePartNumber}",
                      width: 120),
                  field(
                      title: "AWG",
                      data: "${widget.bundleList[0].awg}",
                      width: 80),
                  field(
                      title: "Total Qty",
                      data: "${widget.bundleList.length}",
                      width: 100),
                  field(
                      title: "Dispatch Bundles",
                      data: "${widget.selectedBundleList.length}",
                      width: 140),
                  field(
                      title: "Pending Bundles",
                      data:
                          "${widget.bundleList.length - widget.selectedBundleList.length}",
                      width: 140)
                ],
              ),
            ),
            Container(
              width: 700,
              height: 400,
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: true,
                  columnSpacing: 40,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Bundle Id',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      'Bin Id',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    )),
                    DataColumn(
                      label: Text(
                        'location ',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Color',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Qty',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                  rows: widget.bundleList
                      .map((e) => DataRow(
                              selected: widget.selectedBundleList.contains(e),
                              onSelectChanged: (value) {
                                setState(() {
                                  if (value)
                                    widget.selectedBundleList.add(e);
                                  else {
                                    widget.selectedBundleList.remove(e);
                                  }
                                });
                              },
                              cells: <DataCell>[
                                DataCell(Text(
                                  "${e.bundleIdentification}",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.binId}",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.locationId}" ?? '-',
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  e.color ?? "",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.bundleQuantity}" ?? "",
                                  style: TextStyle(fontSize: 12),
                                )),
                              ]))
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.transparent))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green[200];
                        return Colors
                            .green[500]; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    widget.reload();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Save"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget field({String title, String data, double width}) {
    return Container(
      width: width,
      height: 50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 12)),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(data,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 13),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class KittingPost {
  KittingEJobDtoList kittingEJobDtoList;
  List<BundleMaster> selectedBundles;
  KittingPost({this.kittingEJobDtoList, this.selectedBundles});
}
