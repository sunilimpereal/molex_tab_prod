import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  List<Widget> colums;
  List<CustomRow> rows;
  double width;
  double height;
  CustomTable({Key key, this.height, this.colums, this.rows, this.width})
      : super(key: key);

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      color: Colors.white,
      child: Column(
        children: [
          Material(
            // elevation: 2,
            shadowColor: Colors.white,
            color: Colors.white,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.red[100],
                  width: 1,
                )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.colums,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              cacheExtent: 10000,
              itemCount: widget.rows.length,
              itemBuilder: (context, index) {
                return widget.rows[index];
              },
            ),
          )
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  List<Widget> cells;
  bool completed = false;

  CustomRow({Key key, this.cells, this.completed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: completed??false ? Colors.green[50] : Colors.white,
        border: Border(
            bottom: BorderSide(
          color: Colors.grey[100],
          width: 1,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cells,
      ),
    );
  }
}

class CustomCell extends StatelessWidget {
  Widget child;
  double width;
  Color color;

  CustomCell({Key key, this.child, this.color, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: child),
      ),
    );
  }
}
