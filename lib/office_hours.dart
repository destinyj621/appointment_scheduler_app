//this page displays the office hours

import 'package:flutter/material.dart';

class OfficeHours extends StatefulWidget {
  @override
  _OfficeHoursState createState() => _OfficeHoursState();
}

class _OfficeHoursState extends State<OfficeHours> {

  final List<String> officeHours = [
    "Sunday: Closed",
    "Monday: 9:00 AM - 5:00 PM",
    "Tuesday: 9:00 AM - 5:00 PM",
    "Wednesday: 9:00 AM - 5:00 PM",
    "Thursday: 9:00 AM - 5:00 PM",
    "Friday: Closed",
    "Saturday: Closed",
    "Lunch: 12:00 PM - 1:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Office Hours"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: officeHours.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
            officeHours[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              ),
            ),
          );
        },
      ),
    ),
    );
  }

}