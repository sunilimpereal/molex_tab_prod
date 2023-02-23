import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model_api/login_model.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/schedular_model.dart';
import '../../operator%202/Home_0p2.dart';
import '../../widgets/showBundleDetail.dart';

import '../Homepage.dart';

class DrawerWidgetWIP extends StatefulWidget {
  Employee employee;
  MachineDetails machineDetails;

  Function reloadmaterial;
  Function homeReload;
  Function transfer;
  Function returnmaterial;

  DrawerWidgetWIP(
      {required this.employee,
      required this.machineDetails,
      required this.homeReload,
      required this.reloadmaterial,
      required this.transfer,
      required this.returnmaterial});
  @override
  _DrawerWidgetWIPState createState() => _DrawerWidgetWIPState();
}

class _DrawerWidgetWIPState extends State<DrawerWidgetWIP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.30,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            Column(
              children: [profileView()],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("v 1.0.0+90",
                    style: TextStyle(
                      color: Colors.red,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.all(Radius.circular(500))),
                  child: Center(
                    child: Text(
                        "${widget.employee.employeeName.substring(0, 2).toUpperCase()}", // TODO
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 170,
                          child: Text("${widget.employee.employeeName}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 170,
                          child: Text("${widget.employee.empId}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          ListTile(
            onTap: () {
              widget.transfer();
            },
            title: Text('Location & Bin Map'),
            trailing: Icon(
              Icons.transfer_within_a_station_outlined,
              color: Colors.red.shade300,
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.pop(context);
              widget.reloadmaterial();
            },
            title: Text('Realod Material'),
            trailing: Icon(
              Icons.add_box,
              color: Colors.red.shade300,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              widget.returnmaterial();
            },
            title: Text('Return Material'),
            trailing: Icon(
              Icons.repeat_rounded,
              color: Colors.red.shade300,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              showBundleDetail(context);
            },
            title: Text('Bundle Detail'),
            trailing: Icon(
              Icons.book_online_rounded,
              color: Colors.red.shade300,
            ),
          ),
          ListTile(
            focusColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);

              switch (widget.machineDetails.category) {
                case "Manual Crimping":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageOp2(
                              employee: widget.employee,
                              machine: widget.machineDetails,
                            )),
                  );
                  break;
                case "Manual Cutting":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Homepage(
                              employee: widget.employee,
                              machine: widget.machineDetails,
                            )),
                  );
                  break;
                case "Automatic Cut & Crimp":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Homepage(
                              employee: widget.employee,
                              machine: widget.machineDetails,
                            )),
                  );
                  break;
                case "Semi Automatic Strip and Crimp machine":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageOp2(
                              employee: widget.employee,
                              machine: widget.machineDetails,
                            )),
                  );
                  break;
                case "Automatic Cutting":
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Homepage(
                              employee: widget.employee,
                              machine: widget.machineDetails,
                            )),
                  );
                  break;
                default:
                  Fluttertoast.showToast(
                      msg: "Machine not Found",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
              }
            },
            title: Text('Return'),
            trailing: Icon(
              Icons.exit_to_app,
              color: Colors.red.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
