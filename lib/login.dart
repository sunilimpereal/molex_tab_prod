import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:lottie/lottie.dart';
import 'model_api/login_model.dart';
// import 'package:lottie/lottie.dart';
import 'package:molex/Machine_Id.dart';
import 'package:molex/screens/utils/changeIp.dart';
import 'package:molex/screens/utils/customKeyboard.dart';
import 'package:molex/screens/utils/updateApp.dart';
import 'package:molex/service/apiService.dart';
import 'package:motion_toast/motion_toast.dart';

class LoginScan extends StatefulWidget {
  @override
  _LoginScanState createState() => _LoginScanState();
}

class _LoginScanState extends State<LoginScan> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  late String userId ="";
  late ApiService apiService;

  late bool loading;

  @override
  void initState() {
    loading = false;
    apiService = new ApiService();
  
    _textNode.requestFocus();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _textNode.dispose();
    super.dispose();
  }

  handleKey(RawKeyEventData key) {
    // setState(() {
    //   SystemChannels.textInput.invokeMethod('TextInput.hide');
    // });
  }
  TextEditingController scanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      backgroundColor: Color(0xffE2BDA6),
      body: Center(
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [],
                  ),
                ),
                SizedBox(height: 0),
                Material(
                  elevation: 10,
                  shadowColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: []),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.bold,

                              ),
                            ),
                          ),
                          loading
                              ? Container(
                                  height: 3,
                                  width: 280,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey.shade50,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                )
                              : Container(
                                  width: 280,
                                ),
                          Lottie.asset('assets/lottie/scan-barcode.json',
                              width: 280, fit: BoxFit.cover),
                          Text(
                            'Scan Id Card to Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),

                          ),
                          userId != ''
                              ? Text(
                                  userId,
                                  style:  TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),

                                )
                              : Container(
                                  width: 10,
                                ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: 200,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shadowColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.white;
                                      return Colors
                                          .white; // Use the component's default.
                                    },
                                  ),
                                  elevation:
                                      MaterialStateProperty.resolveWith<double>(
                                          (Set<MaterialState> states) {
                                    return 10;
                                  }),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors
                                          .red; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  loginScan(context);
                                  // setState(() {
                                  //   loading = true;
                                  // });
                                  // print('pressed');
                                  // apiService.empIdlogin(userId).then((value) {
                                  //   if (value != null) {
                                  //     MotionToast.success(
                                  //       title: "Logged In",
                                  //       titleStyle: TextStyle(
                                  //           fontWeight: FontWeight.bold),
                                  //       description: "$userId",
                                  //        descriptionStyle:
                                  //           TextStyle(fontSize: 12),
                                  //       width: 300,
                                  //     ).show(context);

                                  //     print("userId:$userId");
                                  //     Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => MachineId(
                                  //                 employee: value,
                                  //               )),
                                  //     );
                                  //   } else {
                                  //     setState(() {
                                  //       loading = false;
                                  //     });
                                  //     Fluttertoast.showToast(
                                  //       msg: "login Failed",
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.BOTTOM,
                                  //       timeInSecForIosWeb: 1,
                                  //       backgroundColor: Colors.red,
                                  //       textColor: Colors.white,
                                  //       fontSize: 16.0,
                                  //     );
                                  //     setState(() {
                                  //       userId = null;
                                  //       _textController.clear();
                                  //       scanController.clear();
                                  //     });
                                  //   }
                                  // });
                                },
                                child: Text(
                                  'Login',
                                  style:  TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  
                                )),
                          ),
                          SizedBox(height: 10),
                          // Container(
                          //   height: 0,
                          //   width: 0,
                          //   child: TextFieldWithNoKeyboard(
                          //     controller: scanController,
                          //     autofocus: true,
                          //     cursorColor: Colors.green,
                          //     style: TextStyle(color: Colors.black),
                          //     onValueUpdated: (value) {
                          //       print(value);
                          //       setState(() {
                          //         userId = value;
                          //       });
                          //     },
                          //   ),
                          // ),

                          Container(
                              alignment: Alignment.center,
                              width: 0,
                              height: 0,
                              child: RawKeyboardListener(
                                focusNode: FocusNode(),
                                onKey: (event) async {
                                  print(userId);
                                  if (event
                                      .isKeyPressed(LogicalKeyboardKey.tab)) {
                                    Fluttertoast.showToast(
                                        msg: "Got tab at the end",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    setState(() {
                                      userId = "";
                                    });
                                  }
                                  handleKey(event.data);
                                },
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) async {
                                    loginScan(context);
                                  },
                                  onTap: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  },
                                  controller: _textController,
                                  autofocus: true,
                                  focusNode: _textNode,
                                  onChanged: (value) {
                                    setState(() {
                                      userId = value;
                                    });
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 70,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/appiconbg.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 10,
                        shadowColor: Colors.white,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeIp()),
                            );
                          },
                          splashRadius: 60,
                          tooltip: "Change IP of the app",
                          color: Colors.white,
                          focusColor: Colors.white,
                          splashColor: Colors.red,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          elevation: 10,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          shadowColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateApp()),
                              );
                            },
                            splashRadius: 60,
                            tooltip: "Upate App",
                            color: Colors.white,
                            focusColor: Colors.white,
                            splashColor: Colors.red,
                            icon: Icon(
                              Icons.system_update,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //     top: 0,
                      //     right: 0,
                      //     child: Container(
                      //       padding: EdgeInsets.all(3),
                      //       decoration: BoxDecoration(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(50)),
                      //         color: Colors.red,
                      //       ),
                      //       child: Text(' 1 '),
                      //     ))
                    ])
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("v 1.0.0+20"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void loginScan(BuildContext context) {
    setState(() {
      loading = true;
    });
    print('pressed');
    apiService.empIdlogin(userId).then((value) {
      if (value != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MachineId(
                    employee: value,
                  )),
        );
      } else {
        setState(() {
          _textNode.requestFocus();
          loading = false;
        });
        Fluttertoast.showToast(
          msg: "login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          userId = "";
          _textController.clear();
          scanController.clear();
        });
      }
    });
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    return barcodeScanRes;
  }
}
