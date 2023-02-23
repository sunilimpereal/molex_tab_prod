import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../model_api/postReturnMaterial.dart';
import '../../../model_api/postrawmatList_model.dart';
import '../../../utils/config.dart';
import '../../utils/loadingButton.dart';
import '../../../service/apiService.dart';

import 'materialTableWIP.dart';

Future<void> showReturnMaterial(BuildContext context, MatTrkPostDetail matTrkPostDetail, MachineDetails machineDetails) async {
  Future.delayed(
    const Duration(milliseconds: 50),
    () {
      SystemChannels.textInput.invokeMethod(keyboardType);
    },
  );
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(
          child: ReturnRawmaterial(
        matTrkPostDetail: matTrkPostDetail,
        machineDetails: machineDetails,
      ));
    },
  );
}

class ReturnRawmaterial extends StatefulWidget {
  MatTrkPostDetail matTrkPostDetail;
  MachineDetails machineDetails;
  ReturnRawmaterial({Key? key, required this.matTrkPostDetail, required this.machineDetails}) : super(key: key);

  @override
  _ReturnRawmaterialState createState() => _ReturnRawmaterialState();
}

class _ReturnRawmaterialState extends State<ReturnRawmaterial> {
  ApiService? apiService;
  bool loading = false;
  List<MaterialDetail> materailList = [];
  getMaterial() {
    ApiService().getMaterialTrackingCableDetail(widget.matTrkPostDetail).then((value) {
      setState(() {
        materailList = (value as List<MaterialDetail>?)!;
      });
    });
  }

  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        title: Stack(
          children: [
            Container(
              height: 200,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialtableWIP(
                    matTrkPostDetail: widget.matTrkPostDetail,
                    getUom: (uom) {},
                    materailList: materailList,
                  ),
                  returnMaterialButtons(),
                ],
              ),
            ),
            Positioned(
                top: -15,
                right: -10,
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

  Widget returnMaterialButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: apiService!.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MaterialDetail>? matList = snapshot.data as List<MaterialDetail>?;
              PostReturnMaterial postReturnMaterial = PostReturnMaterial(
                  machineIdentification: widget.machineDetails.machineNumber,
                  partNumberList: matList!.map((e) {
                    return Part(
                      partNumbers: int.parse(e.cablePartNo!),
                      usedQuantity: int.parse(e.availableQty!),
                      traceabilityNumber: getTraceabilityNumber(e.cablePartNo!),
                    );
                  })?.toList());
              log("message ${postReturnMaterialToJson(postReturnMaterial)} ");

              if (matList!.length > 0) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LoadingButton(
                          loading: loading,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                          ),
                          loadingChild: Container(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          child: Text("Return Material"),
                          onPressed: () {
                            apiService!.postreturnRawMaterial(postReturnMaterial);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }

  String getTraceabilityNumber(String partNumber) {
    for (PostRawMaterial material in widget.matTrkPostDetail.selectedRawMaterial!) {
      if (material.cablePartNumber.toString() == partNumber) {
        return material.traceabilityNumber!;
      }
    }
    return "";
  }
}
