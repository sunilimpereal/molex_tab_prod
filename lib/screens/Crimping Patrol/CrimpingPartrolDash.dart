// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../model_api/machinedetails_model.dart';
// import '../navigation.dart';
// import '../widgets/CrimpPatrolHeader.dart';
// import '../widgets/CrimpPatrolTable.dart';
// import '../widgets/time.dart';
// import '../../service/apiService.dart';
// class CrimpingPatrolDash extends StatefulWidget {
//     String userId;
//   String machineId;
//   CrimpingPatrolDash({this.machineId,this.userId});
//   @override
//   _CrimpingPatrolDashState createState() => _CrimpingPatrolDashState();
// }

// class _CrimpingPatrolDashState extends State<CrimpingPatrolDash> {
//     ApiService apiService;
//     @override
//   void initState() {
//     apiService = new ApiService();
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar:  AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(
//           color: Colors.red,
//         ),
       
      
//         title: const Text(
//           'Crimping Patrol',
//           style: TextStyle(color: Colors.red),
//         ),
//         elevation: 0,
//         actions: [
      
         

        
//           //machine Id
//           Container(
//             padding: EdgeInsets.all(1),
//             // width: 130,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.all(Radius.circular(100)),
//                       ),
//                       child: Center(
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Icon(
//                               Icons.person,
//                               size: 18,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                           Text(
//                             widget.userId,
//                             style:TextStyle(
//                                     fontSize: 13, color: Colors.black)),
                          
//                         ],
//                       )),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.all(Radius.circular(100)),
//                       ),
//                       child: Center(
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Icon(
//                               Icons.settings,
//                               size: 18,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                           Text(
//                             widget.machineId ?? "",
//                             style:
//                                   TextStyle(fontSize: 13, color: Colors.black),
                            
//                           ),
//                         ],
//                       )),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),

//           TimeDisplay(),
       
//         ],
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//                   child: Column(
//             children: [
//               CrimpPatrolHeader(),
//               CrimpPatrolTable()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }