import 'package:flutter/material.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../service/apiService.dart';

class MaterialtableWIP extends StatefulWidget {
  MatTrkPostDetail matTrkPostDetail;
  MaterialtableWIP({Key key, this.matTrkPostDetail}) : super(key: key);

  @override
  _MaterialtableWIPState createState() => _MaterialtableWIPState();
}

class _MaterialtableWIPState extends State<MaterialtableWIP> {
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

  Widget table() {
    ApiService apiService = new ApiService();
    return FutureBuilder(
        future:
            apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MaterialDetail> matList = snapshot.data;
            if (matList.length > 0) {
              return Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: Column(children: [
                        row('Part No.', 'UOM', 'REQUIRED', 'LOADED',
                            'AVAILABLE', Colors.blue[100]),
                        Container(
                          height: 63,
                          child: ListView.builder(
                              itemCount: matList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return row(
                                    "${matList[index].cablePartNo}",
                                    "${matList[index].uom.toString()}",
                                    "${matList[index].requiredQty.toString()}",
                                    "${matList[index].loadedQty.toString()}",
                                    "${matList[index].availableQty.toString()}",
                                    Colors.grey[100]);
                              }),
                        ),
                      ])),
                ],
              );
            } else {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: Column(
                    children: [
                      row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                          Colors.blue[100]),
                      SizedBox(height: 10),
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
                        Colors.blue[100]),
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
                    border: Border.all(width: 0.5, color: Colors.grey[100])),
                height: 20,
                width: MediaQuery.of(context).size.width * 0.1,
                child: Center(
                    child: Text(partno, style: TextStyle(fontSize: 12)))),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey[100])),
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
                  border: Border.all(width: 0.5, color: Colors.grey[100])),
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
                  border: Border.all(width: 0.5, color: Colors.grey[100])),
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
                  border: Border.all(width: 0.5, color: Colors.grey[100])),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  available,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget table1() {
    return Material(
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.transparent)),
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
            // color: Colors.red[50],
          ),
          padding: EdgeInsets.all(2),
          child: Center(
              child: Text(
            "$title",
            style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.bold),
          )),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: Colors.transparent)),
        child: Container(
          width: 320,
          decoration: BoxDecoration(
              color: Colors.red[500],
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cell("Part No.", 0.07),
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
        {String partNo,
        String uom,
        String require,
        String loaded,
        String available}) {
      Widget cell(String title, double width) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: MediaQuery.of(context).size.width * width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Colors.white),
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
            cell(partNo, 0.07),
            cell(uom, 0.04),
            cell(require, 0.06),
            cell(loaded, 0.06),
            cell(available, 0.06),
          ],
        ),
      );
    }

    ApiService apiService = new ApiService();
    return FutureBuilder(
        future:
            apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MaterialDetail> matList = snapshot.data;

            if (matList.length > 0) {
              return Container(
                width: 320,
                height: 68,
                child: ListView.builder(
                    itemCount: matList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return row(
                        partNo: "${matList[index].cablePartNo}",
                        uom: "${matList[index].uom.toString()}",
                        require: "${matList[index].requiredQty.toString()}",
                        loaded: "${matList[index].loadedQty.toString()}",
                        available: "${matList[index].availableQty.toString()}",
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
        });
  }
}
