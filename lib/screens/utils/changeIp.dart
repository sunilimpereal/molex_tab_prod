import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeIp extends StatefulWidget {
  @override
  _ChangeIpState createState() => _ChangeIpState();
}

class _ChangeIpState extends State<ChangeIp> {
  SharedPreferences preferences;
  String baseip;
    List<String> ipList = [
    "http://10.221.46.8:8080/wipts/",//client
    "http://192.168.1.252:8080/wipts/",//just
  ];
  // List<String> ipList = [
  //   "http://justerp.in:8080/wipts/",
  //   "http://10.221.46.8:8080/wipts/",//client
  //   "http://192.168.1.252:8080/wipts/",//just
  //   "http://mlxbngvwqwip01.molex.com:8080/wipts/",
  //   "http://mlxbngvwqwip01.molex.com:8080/wiptst/",
  //   "http://10.221.46.8:8080/wiptst/",
  // ];
  String newIp;
  List<String> ipList1 = [];

  getSharedPref() async {
    SharedPreferences preferenc = await SharedPreferences.getInstance();
    setState(() {
      preferences = preferenc;
      baseip = preferences.getString('baseIp');
      try {
        ipList1 = preferences.getStringList('ipList');
         
        if (ipList1 == null) {
          preferences.setStringList('ipList', ipList);
          ipList = preferences.getStringList('ipList');
        } else {
          ipList = preferences.getStringList('ipList');
        }
      } catch (e) {
        preferences.setStringList('ipList', ipList);
      }
    });
  }

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  bool delOption = false;

  @override
  Widget build(BuildContext context) {
   
    print(baseip);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Ip "),
       
      ),
      body: Container(
        child: Container(
          child: ListView.builder(
              itemCount: ipList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ListTile(
                      tileColor: baseip == ipList[index]
                          ? Colors.red[200]
                          : Colors.white,
                      title: Text(" ${ipList[index]}"),
                      onLongPress: () {
                        setState(() {
                          delOption = !delOption;
                        });
                      },
                      onTap: () {
                        setState(() {
                          preferences.setString('baseIp', "${ipList[index]}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScan()),
                          );
                        });
                      },
                      trailing: delOption
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showAlertDialog(context, ipList[index]);
                              },
                            )
                          : Container(
                              height: 8,
                              width: 9,
                            ),
                    ),
                  ],
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showaddip();
        },
        icon: Icon(Icons.add),
        label: Text("Add IP"),
      ),
    );
  }

  showAlertDialog(BuildContext context, String ip) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(color: Colors.red),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
       style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.transparent))),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.red[200];
              return Colors.red[500]; // Use the component's default.
            },
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text("   Delete   ",style: TextStyle(color: Colors.white),),
      ),
      onPressed: () {
        setState(() {
          ipList.remove(ip);
          try {
            ipList1 = preferences.getStringList('ipList');

            preferences.setStringList('ipList', ipList);
          } catch (e) {
            preferences.setStringList('ipList', ipList);
          }
        });
          Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm delete"),
      content: Text("Are you sure you want to delete ip: $ip ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> showaddip() async {
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
        return Center(child: addIp(context));
      },
    );
  }

  Widget addIp(BuildContext context) {
    return AlertDialog(
        title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('Add URL '),
              ],
            ),
            Container(
              height: 50,
              width: 400,
              child: TextFormField(
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  setState(() {
                    newIp = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    if (newIp != null) {
                      setState(() {
                        ipList.add(newIp);
                        preferences.setStringList('ipList', ipList);
                      });
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: "url is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text("Save Ip")),
            ),
          ],
        ),
      ),
    ));
  }
}

// ListTile(
//   tileColor: baseip == "http://justerp.in:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://justerp.in:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://justerp.in:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://10.221.46.8:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://10.221.46.8:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://10.221.46.8:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://192.168.1.252:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://192.168.1.252:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://192.168.1.252:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://mlxbngvwqwip01.molex.com:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://mlxbngvwqwip01.molex.com:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://mlxbngvwqwip01.molex.com:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// )
