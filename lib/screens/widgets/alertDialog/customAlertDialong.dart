import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main.dart';
import '../../../utils/config.dart';

Future<void> showCustomBundleAlertCrimping(
    {required BuildContext context,
    required Function onDoNotRemindAgain,
    required String heading,
    required String heading2,
    required Function onSubmitted}) async {
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
          child: CustomBundleAlertCrimping(
        onDoNotRemindAgain: onDoNotRemindAgain,
        onSubmitted: onSubmitted,
        heading2: heading2,
        heading: heading,
      ));
    },
  );
}

class CustomBundleAlertCrimping extends StatefulWidget {
  @required
  Function onDoNotRemindAgain;
  @required
  Function onSubmitted;
  String heading;
  String heading2;
  CustomBundleAlertCrimping({Key? key, required this.onDoNotRemindAgain, required this.onSubmitted, required this.heading, required this.heading2})
      : super(key: key);

  @override
  _CustomBundleAlertCrimpingState createState() => _CustomBundleAlertCrimpingState();
}

class _CustomBundleAlertCrimpingState extends State<CustomBundleAlertCrimping> {
  bool checkbox = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        title: Stack(
          children: [
            body(),
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
        ));
  }

  Widget body() {
    return Container(
      height: 180,
      width: 350,
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.heading}",
            style: TextStyle(fontFamily: fonts.openSans, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 0,
          ),
          Text(
            "${widget.heading2}",
            style: TextStyle(fontFamily: fonts.openSans, fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 0,
          ),
          // Container(
          //   width: 340,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Checkbox(
          //           fillColor: MaterialStateProperty.resolveWith<Color>(
          //             (Set<MaterialState> states) {
          //               if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
          //               return Colors.green.shade400; // Use the component's default.
          //             },
          //           ),
          //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //           value: checkbox,
          //           onChanged: (value) {
          //             setState(() {
          //               checkbox = value!;
          //               widget.onDoNotRemindAgain(value);
          //             });
          //           }),
          //       // Text(
          //       //   "Do not show again",
          //       //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          //       // )
          //     ],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.transparent, // background
                    onPrimary: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '  Cancel  ',
                      style: TextStyle(fontSize: 16, fontFamily: fonts.openSans, fontWeight: FontWeight.bold),
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.green, // background
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.onSubmitted();
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Continue', style: TextStyle(fontSize: 16, fontFamily: fonts.openSans, fontWeight: FontWeight.bold)),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
