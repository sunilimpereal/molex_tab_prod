import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class DateRangePickerDash extends StatefulWidget {
  @required Function onChanged;

  DateRangePickerDash({required this.onChanged});

  @override
  _DateRangePickerDashState createState() => _DateRangePickerDashState();
}

class _DateRangePickerDashState extends State<DateRangePickerDash> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
    color: Colors.deepOrangeAccent,
    onPressed: () async {
      final List<DateTime> picked = await DateRangePicker.showDatePicker(
          context: context,
          initialFirstDate: new DateTime.now(),
          initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
          firstDate: new DateTime(2015),
          lastDate: new DateTime(DateTime.now().year + 2)
      );
      if (picked != null && picked.length == 2) {
          print(picked);
      }
    },
    child: new Text("Pick date range")
);
  }
}
