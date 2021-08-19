import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../login.dart';
import '../../model_api/login_model.dart';
import '../../model_api/machinedetails_model.dart';
import '../../model_api/transferLocation_model.dart';
import '../operator/location.dart';
import '../print.dart';

class DrawerWidget extends StatefulWidget {
  Employee employee;
  MachineDetails machineDetails;
  String type;
  DrawerWidget({this.employee, this.machineDetails, this.type});
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Text(
                  "v 1.0.0+12",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.red,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ))
        ],
      ),
    );
  }

  Widget profileView() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.all(Radius.circular(500))),
                  child: Center(
                    child: Text(
                      "${widget.employee.employeeName.substring(0, 2).toUpperCase()}", // TODO
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500)),
                    ),
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
                          width: 200,
                          child: Text(
                            "${widget.employee.employeeName}",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          child: Text(
                            "${widget.employee.empId}",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Location(
                          employee: widget.employee,
                          machine: widget.machineDetails,
                          type: widget.type,
                          locationType: LocationType.partialTransfer,
                        )),
              );
            },
            title: Text('Location & Bin Map'),
            trailing: Icon(
              Icons.transfer_within_a_station_outlined,
              color: Colors.red[300],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintTest()),
              );
            },
            title: Text('Print test'),
            trailing: Icon(
              Icons.print,
              color: Colors.red[300],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScan()),
              );
            },
            title: Text('Logout'),
            trailing: Icon(
              Icons.logout,
              color: Colors.red[300],
            ),
          )
        ],
      ),
    );
  }
}