import 'package:flutter/material.dart';

import '../login.dart';
import '../model_api/machinedetails_model.dart';
import '../model_api/schedular_model.dart';
import 'Preparation/preparationDash.dart';
import 'operator%202/Home_0p2.dart';
import 'print.dart';
import 'utils/changeIp.dart';
import 'visual%20Inspector/Home_visual_inspector.dart';
import '../service/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavPage extends StatefulWidget {
  final String userId;
  final MachineDetails machine;
  final Schedule schedule;
  NavPage({required this.machine, required this.userId, required this.schedule});
  @override
  _NavPageState createState() => _NavPageState(); 
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Change IP'),
            onTap: () {
              ApiService apiService = new ApiService();
              apiService.getmachinedetails(widget.machine.machineNumber??'').then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeIp(

                          )),
                );
              });
            },
          ),
          // ListTile(
          //   title: Text('Preparation'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => PreprationDash(
                         
          //                 userId: widget.userId,
          //               )),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: Text("Visual Inspector"),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => HomeVisualInspector(
          //                 machineId: widget.machine.machineNumber,
          //                 employee: widget.e,
          //               )),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: Text("Material Coordinator"),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => HomeMaterialCoordinator(
          //                 machineId: widget.machineId,
          //                 userId: widget.userId,
          //               )),
          //     );
          //   },
          // ),
          ListTile(
            title: Text("Print Test"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintTest()),
              );
            },
          ),
          ListTile(
            title: Text("Log Out"),
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove('login');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScan()),
              );
            },
          )
        ],
      ),
    );
  }
}
