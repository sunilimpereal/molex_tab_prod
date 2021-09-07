import 'package:flutter/material.dart';
import '../../model_api/schedular_model.dart';

class SchduleRowP1 extends StatefulWidget {
  Schedule schedule;
  SchduleRowP1({Key? key, required this.schedule}) : super(key: key);

  @override
  _SchduleRowP1State createState() => _SchduleRowP1State();
}

class _SchduleRowP1State extends State<SchduleRowP1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        child: Row(
          children: [cell(text: "${widget.schedule.orderId}",width: 0.1)],
        ),
      ),
    );
  }

  Widget cell({required String text, required double width}) {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width*width,
      child: Text("$text"));
  }
}
