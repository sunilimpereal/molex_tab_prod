import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../../model_api/fgDetail_model.dart';
import '../../model_api/schedular_model.dart';
import '../../service/apiService.dart';

class P1ScheduleDetailWIP extends StatefulWidget {
  Schedule schedule;

  P1ScheduleDetailWIP({required this.schedule});
  @override
  _P1ScheduleDetailWIPState createState() => _P1ScheduleDetailWIPState();
}

class _P1ScheduleDetailWIPState extends State<P1ScheduleDetailWIP> {
  late ApiService apiService;
  @override
  void initState() {
    apiService = ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        clipBehavior: Clip.antiAlias, // Add This
        shadowColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          height: 78,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                scheduleDetail(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 0,
                ),
                Container(child: fGTable()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget feild({required String heading, required String value, required double width}) {
    width = MediaQuery.of(context).size.width * width;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        // color: Colors.red.shade100,
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  heading,
                  style:  TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.normal,
                  )),
                
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                children: [
                  Text(
                    value ?? '',
                    style: 
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget scheduleDetail() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            feild(
                heading: "Order Id",
                value: widget.schedule.orderId,
                width: 0.1),
            feild(
                heading: "FG Part",
                value: "${widget.schedule.finishedGoodsNumber}",
                width: 0.1),
            feild(
                heading: "Schedule ID",
                value: "${widget.schedule.scheduledId}",
                width: 0.1),
            feild(
                heading: "Cable Part No.",
                value: "${widget.schedule.cablePartNumber}",
                width: 0.08),
            // feild(
            //     heading: "Process",
            //     value: "${widget.schedule.process}",
            //     width: 0.12),
            feild(
                heading: "cable#",
                value: "${widget.schedule.cableNumber}",
                width: 0.05),
            feild(
                heading: "Cut Length",
                value: "${widget.schedule.length}",
                width: 0.08),
            feild(heading: "AWG", value: "${widget.schedule.awg}", width: 0.05),
            feild(
                heading: "Color",
                value: "${widget.schedule.color}",
                width: 0.07),
            feild(
                heading: "Schedule Qty",
                value:
                    "${widget.schedule.scheduledQuantity}",
                width: 0.09),
            feild(
                heading: "Date",
                value: widget.schedule.currentDate == null
                    ? ""
                    : DateFormat("dd-MM-yyyy")
                        .format(widget.schedule.currentDate),
                width: 0.08)
          ],
        ));
  }

  Widget fGTable() {

    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder(
            future:
                apiService.getFgDetails(widget.schedule.finishedGoodsNumber),
            builder: (context, snapshot) {
              print('fg number ${widget.schedule.finishedGoodsNumber}');
              FgDetails? fgDetail = snapshot.data as FgDetails?;
              if (snapshot.hasData) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    // color: Colors.grey.shade200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          feild(
                              heading: "FG Description",
                              value: "${fgDetail!.fgDescription}",
                              width: 0.30),
                          feild(
                              heading: "Customer",
                              value: "${fgDetail.customer}",
                              width: 0.2),
                          feild(
                              heading: "Drg Rev",
                              value: "${fgDetail.drgRev}",
                              width: 0.05),
                          feild(
                              heading: "Cable#",
                              value: fgDetail.cableSerialNo.toString(),
                              width: 0.09),
                          feild(
                              heading: 'Shift No. ',
                              value: '  ${widget.schedule.shiftNumber}',
                              width: 0.1),
                          feild(
                              heading: 'Shift Type ',                                                                                                                 
                              value: '${widget.schedule.shiftType}',
                              width: 0.1),
                          feild(
                              heading: 'Tolerance ',
                              value: '${widget.schedule.lengthTolerance}',
                              width: 0.07),
                        ]));
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
