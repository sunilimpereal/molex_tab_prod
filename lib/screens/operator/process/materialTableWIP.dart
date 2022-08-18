import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../service/apiService.dart';

class MaterialtableWIP extends StatefulWidget {
  final MatTrkPostDetail matTrkPostDetail;
  final Function(String) getUom;
  final String? cablePartNumber;
  final List<MaterialDetail> materailList;
  const MaterialtableWIP(
      {Key? key,
      this.cablePartNumber = '',
      required this.materailList,
      required this.matTrkPostDetail,
      required this.getUom})
      : super(key: key);

  @override
  _MaterialtableWIPState createState() => _MaterialtableWIPState();
}

class _MaterialtableWIPState extends State<MaterialtableWIP> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return materialtable();
  }

  Widget materialtable() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: table1(),
    );
  }

  Widget table1() {
    return Material(
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.transparent)),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            tableHeading(),
            tableData(),
          ],
        ),
      ),
    );
  }

  Widget tableHeading() {
    Widget cell(String title, double width) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            // color: Colors.red.shade50,
          ),
          padding: EdgeInsets.all(2),
          child: Center(
              child: Text(
            "$title",
            style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), side: BorderSide(color: Colors.transparent)),
        child: Container(
          width: 320,
          decoration: BoxDecoration(
              color: Colors.red.shade500, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cell("Part No.", 0.1),
              cell("UOM", 0.04),
              cell("Required", 0.06),
              cell("Loaded", 0.06),
              cell("Available", 0.06)
            ],
          ),
        ),
      ),
    );
  }

  Widget tableData() {
    Widget row(
        {required String partNo,
        required String uom,
        required String require,
        required String loaded,
        required String available}) {
      Widget cell(String title, double width) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: MediaQuery.of(context).size.width * width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)), color: Colors.white),
            padding: EdgeInsets.all(5),
            child: Center(
                child: Text(
              "$title",
              style: TextStyle(fontSize: 11),
            )),
          ),
        );
      }

      return Container(
        height: 23,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cell(partNo, 0.1),
            cell(uom, 0.04),
            cell(require, 0.06),
            cell(loaded, 0.06),
            cell(available, 0.06),
          ],
        ),
      );
    }

    ApiService apiService = new ApiService();
    // return
    //  FutureBuilder(
    //     future: apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         List<MaterialDetail>? matList = snapshot.data as List<MaterialDetail>?;
    //         Future.delayed(Duration(seconds: 2)).then((value) {
    //           if (widget.cablePartNumber != ' ') {
    //             for (MaterialDetail matDet in matList ?? []) {
    //               if (widget.cablePartNumber == matDet.cablePartNo) {
    //                 widget.getUom(matDet.uom ?? "");
    //                 log(matDet.uom ?? "");
    //               }
    //             }
    //           }
    //         });
    if (widget.materailList!.length > 0) {
      return Container(
        width: 320,
        height: 68,
        child: ListView.builder(
            itemCount: widget.materailList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return row(
                partNo: "${widget.materailList[index].cablePartNo}",
                uom: "${widget.materailList[index].uom.toString()}",
                require: "${widget.materailList[index].requiredQty.toString()}",
                loaded: "${widget.materailList[index].loadedQty.toString()}",
                available: "${widget.materailList[index].availableQty.toString()}",
              );
            }),
      );
    } else {
      return Container(
          width: 320,
          height: 68,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "no stock found",
                style: TextStyle(color: Colors.black),
              )
            ],
          ));
    }
    // } else {
    //   return Container(
    //       width: 320,
    //       height: 68,
    //       child: Column(
    //         children: [
    //           SizedBox(height: 10),
    //           Text(
    //             "no stock found",
    //             style: TextStyle(color: Colors.black),
    //           )
    //         ],
    //       ));
    // }
    // });
  }
}
