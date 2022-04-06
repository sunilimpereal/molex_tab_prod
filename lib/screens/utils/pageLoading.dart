import 'package:flutter/material.dart';

class Pageloading extends StatefulWidget {
  bool loading;
  Widget child;
  Pageloading({Key? key, required this.child, required this.loading}) : super(key: key);

  @override
  _PageloadingState createState() => _PageloadingState();
}

class _PageloadingState extends State<Pageloading> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.loading
            ? Container(
                height: MediaQuery.of(context).size.height, child: CircularProgressIndicator())
            : Container(),
        widget.child,
      ],
    );
  }
}
