import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';
import '../../../utils/config.dart';

Future<void> showBundleAlertVi(
    {required BuildContext context,
    required Function onDoNotRemindAgain,
    required String bundleStaus,
    required String crimpfrom,
    required String crimpto,
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
          child: BundleViAlert(
        onDoNotRemindAgain: onDoNotRemindAgain,
        crimpto: crimpto,
        crimpfrom: crimpfrom,
        onSubmitted: onSubmitted,
        bundleStatus: bundleStaus,
      ));
    },
  );
}

class BundleViAlert extends StatefulWidget {
  @required
  Function onDoNotRemindAgain;
  @required
  String bundleStatus;
  @required
  String crimpfrom;
  @required
  String crimpto;
  @required
  Function onSubmitted;
  BundleViAlert(
      {Key? key,
      required this.onSubmitted,
      required this.bundleStatus,
      required this.onDoNotRemindAgain,
      required this.crimpto,
      required this.crimpfrom})
      : super(key: key);

  @override
  _BundleAlertViState createState() => _BundleAlertViState();
}

class _BundleAlertViState extends State<BundleViAlert> {
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
      height: 220,
      width: 400,
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Incomplete Crimping in Bundle",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${getText()}",
            style: TextStyle(fontFamily: fonts.openSans, fontSize: 16, fontWeight: FontWeight.normal),
          ),
          widget.bundleStatus != "dropped"
              ? Text(
                  "Bundle Movement is not done! Do you what to process?",
                  style: TextStyle(fontFamily: fonts.openSans, fontSize: 16, fontWeight: FontWeight.w600),
                )
              : Container(),
          Container(
            width: 340,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: checkbox,
                    onChanged: (value) {
                      setState(() {
                        checkbox = value!;
                        widget.onDoNotRemindAgain(value);
                      });
                    }),
                Text(
                  "Do not show again",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
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
                    child: Text('  Add  ', style: TextStyle(fontSize: 16, fontFamily: fonts.openSans, fontWeight: FontWeight.bold)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  String getText() {
    String output = '';
    if (widget.crimpfrom.length < 1 && widget.crimpto.length < 1) {
      output = output + 'Crimp From, Crimp To';
    } else {
      if (widget.crimpfrom.length < 1) {
        output = output + 'Crimp From';
      }
      if (widget.crimpto.length < 1) {
        output = output + 'Crimp To';
      }
    }
    output = output + " is not completed.";
    return output;
  }
}

//2018074
//2017836
//2017835
