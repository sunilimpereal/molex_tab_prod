import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/utils/Colors.dart';
import 'screens/utils/Fonts.dart';
import 'screens/utils/SharePref.dart';
import 'screens/utils/changeIp.dart';

SharedPref sharedPref = new SharedPref();
Fonts fonts = new Fonts();
AppColors colors = new AppColors();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final String? logged;
  MyApp({this.logged});
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    sharedPref.setStartandEndDate(
        startDate: DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 5))),
        endDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 5))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Molex',
        theme: ThemeData(
          // fontFamily: 'OpenSans',
          primarySwatch: Colors.blue,
        ),
        home: ChangeIp());
  }
}
