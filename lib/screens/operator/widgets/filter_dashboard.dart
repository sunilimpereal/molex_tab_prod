import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:jiffy/jiffy.dart';

enum FilterSelected {
  dateRange,
  machine,
}

Future<void> showFilterDashBoard({
  required BuildContext context,
  required Function onchangedDateRange,
  required DateTime startDate,
  required DateTime endDate,
  required List<String> machineIds,
  required List<String> selectedMachine,
  required Function onChangedMachine,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(
          child: DateRangePickerDash(
        startDate: startDate,
        endDate: endDate,
        machineIds: machineIds,
        selectedMachine: selectedMachine,
        onChangedDateRange: onchangedDateRange,
        onChangedSelectedMachine: onChangedMachine,
      ));
    },
  );
}

class DateRangePickerDash extends StatefulWidget {
  DateTime startDate;
  DateTime endDate;
  Function onChangedDateRange;
  List<String> machineIds;
  List<String> selectedMachine;
  Function onChangedSelectedMachine;

  DateRangePickerDash(
      {required this.onChangedDateRange,
      required this.endDate,
      required this.startDate,
      required this.onChangedSelectedMachine,
      required this.machineIds,
      required this.selectedMachine});

  @override
  _DateRangePickerDashState createState() => _DateRangePickerDashState();
}

class _DateRangePickerDashState extends State<DateRangePickerDash> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TextEditingController searchController = new TextEditingController();
  late DateTime startDate = DateTime.now().subtract(const Duration(days: 4));
  late DateTime endDate = DateTime.now().add(const Duration(days: 3));
  FilterSelected selected = FilterSelected.dateRange;
  @override
  void initState() {
    endDate = widget.endDate ?? endDate;
    startDate = widget.startDate ?? startDate;

    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = args.value.startDate;
        endDate = args.value.endDate;
        widget.onChangedDateRange(startDate, endDate);
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        title: Column(
          children: [
            // Padding(              padding: const EdgeInsets.all(4.0),
            //   child: Row(
            //     children: [
            //       Icon(Icons.sort,color:Colors.red),
            //       SizedBox(
            //         width:10
            //       ),
            //       Text("Filter",style:TextStyle(
            //         color:Colors.red
            //       ))
            //     ],
            //   ),
            // ),
            Container(
              width: 600,
              height: 400,
              child: Stack(
                children: [
                  Row(
                    children: [selector(), showSelected()],
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red.shade400,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Positioned(bottom: 0, right: 0, child: saveButton())
                ],
              ),
            ),
          ],
        ));
  }

  Widget showSelected() {
    switch (selected) {
      case FilterSelected.dateRange:
        return calendar();
      case FilterSelected.machine:
        return machine();
      default:
        return calendar();
    }
  }

  Widget selector() {
    return Container(
      width: 130,
      decoration: BoxDecoration(),
      child: Column(children: [
        FilterMenuTile(
            icon: Icons.date_range,
            type: FilterSelected.dateRange,
            onTap: () {
              setState(() {
                selected = FilterSelected.dateRange;
              });
            },
            title: "Date Range",
            selected: selected),
        FilterMenuTile(
            icon: Icons.settings,
            type: FilterSelected.machine,
            onTap: () {
              setState(() {
                selected = FilterSelected.machine;
              });
            },
            title: "Machine",
            selected: selected),
      ]),
    );
  }

  Widget calendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Text("${Jiffy(startDate).yMMMMd}",
                    style: TextStyle(fontSize: 12)),
                Text("  -  "),
                Text("${Jiffy(endDate).yMMMMd}",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 350,
            child: SfDateRangePicker(
              todayHighlightColor: Colors.red,
              rangeSelectionColor: Colors.redAccent.withOpacity(0.1),
              selectionColor: Colors.red,
              endRangeSelectionColor: Colors.red,
              startRangeSelectionColor: Colors.red,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(startDate, endDate),
            ),
          ),
        ],
      ),
    );
  }

  Widget machine() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 10),
      child: Column(
        children: [
          Container(
            height: 30,
            width: 200,
            child: TextField(
              controller: searchController,
              onChanged: (value){
                setState(() {
                  
                });
              },
              decoration: InputDecoration(
                  hintText: "Search", suffixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(height: 5),
          Container(
              width: 420,
              height: 345,
              child: SingleChildScrollView(
                child: Wrap(
                    clipBehavior: Clip.hardEdge,
                    children: widget.machineIds
                        .where((element) =>
                            element.toLowerCase().contains(searchController.text.toLowerCase()))
                        .map((e) => MachineNameTile(
                            name: e,
                            selected: widget.selectedMachine.contains(e),
                            onTap: () {
                              setState(() {
                                widget.selectedMachine.contains(e)
                                    ? widget.selectedMachine.remove(e)
                                    : widget.selectedMachine.add(e);
                                    widget.onChangedSelectedMachine(widget.selectedMachine);
                              });
                            }))
                        .toList()),
              )),
        ],
      ),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Apply"),
        ));
  }
}

class MachineNameTile extends StatelessWidget {
  String name;
  bool selected;
  Function onTap;
  MachineNameTile(
      {Key? key,
      required this.name,
      required this.selected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            width: 130,
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            decoration: BoxDecoration(
              color: selected ? Colors.red : Colors.grey[50],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  width: 1,
                  color: selected ? Colors.white : Colors.red.shade500),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selected
                    ? Icon(Icons.check,
                        size: 15, color: selected ? Colors.white : Colors.black)
                    : Container(),
                Text(
                  "$name",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: selected ? Colors.white : Colors.black),
                )
              ],
            )),
      ),
    );
  }
}

class FilterMenuTile extends StatelessWidget {
  Function onTap;
  IconData icon;
  String title;
  FilterSelected selected;
  FilterSelected type;

  FilterMenuTile(
      {Key? key,
      required this.icon,
      required this.type,
      required this.onTap,
      required this.title,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(0),
        trailing: selected == type
            ? Container(
                width: 3,
                color: Colors.red,
              )
            : null,
        title: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected == type ? Colors.red : Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "$title",
              style: TextStyle(
                fontSize: 14,
                color: selected == type ? Colors.red[800] : Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () {
          onTap();
        });
  }
}
