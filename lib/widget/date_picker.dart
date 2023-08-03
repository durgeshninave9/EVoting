import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class DatePicker extends StatefulWidget {
  final String title;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  const DatePicker(
      {required this.title,
      required this.hint,
      required this.icon,
      required this.controller,
      super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
        child: DateTimePicker(
          controller: widget.controller,
          calendarTitle: widget.title,
          firstDate: DateTime(1980),
          lastDate: DateTime(2100),
          decoration: InputDecoration(
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.blueGrey,
              ),
              hintText: widget.hint),
        ));
  }
}
