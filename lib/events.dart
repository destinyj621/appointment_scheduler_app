//This page manages appointment scheduling

//TODO: add functionality, send confirmation email

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:appointmentsetter/auth.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();

}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final Auth _auth = Auth();

  //initialize text field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createAppointment() async {

    //require all text fields
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      try {
        await _firestore.collection('events').add({
          'Patient First Name': _firstNameController.text,
          'Patient Last Name': _lastNameController.text,
          'description': _descriptionController.text,
          'date': _dateController.text,
          'time': _timeController.text,
        });

        sendEmail(_auth.currentUser as String); //send email logged in user

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment added successfully!')),
        );
        _firstNameController.clear();
        _lastNameController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _timeController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add appointment: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule an Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Patient First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Patient Last Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Reason for Appointment'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              readOnly: true,
              onTap: () {
                _selectDate();
              },
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
              readOnly: true,
              onTap: () {
                _selectTime();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAppointment,
              child: const Text('Create Appointment'), //sends confirmation email
            ),
          ],
        ),
      ),
    );
  }

  //date format for text controller
  //resource: https://api.flutter.dev/flutter/material/showDatePicker.html
  Future<void> _selectDate() async{
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime val) => val.weekday == 6 || val.weekday == 7 ? false : true, //disallow weekend scheduling
    );

    if (_pickedDate != null){
      setState(() {
        _dateController.text = _pickedDate.toString().split(" ")[0];
      });
      }
    }

  //time format for text controller
  //resource: https://api.flutter.dev/flutter/material/showTimePicker.html
  Future<void> _selectTime() async{
    TimeOfDay? _pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (_pickedTime != null){
      setState(() {
        _timeController.text = _pickedTime.format(context).toString();
      });
      //disallow scheduling outside of 8AM and 5PM
      if (_pickedTime.hour > 17 || _pickedTime.hour < 8){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please choose another time. Appointment outside of office hours!')),
        );
      }

    }
  }

  //send confirmation email
  //resource: https://pub.dev/packages/flutter_mailer
  Future<void> sendEmail(String recipientEmail) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String description = _descriptionController.text;
    String date = _dateController.text;
    String time = _timeController.text;

    final MailOptions mailOptions = MailOptions(
      subject: 'Appointment Confirmation',
      body: '''
        <p>We are pleased to confirm your appointment with [Dentist's Name] at [Dental Office Name] on [$date] at [$time].</p>
        <p><strong>Appointment Details:</strong></p>
        <ul>
          <li><strong>Patient:</strong> $firstName $lastName</li>
          <li><strong>Date:</strong> $date</li>
          <li><strong>Time:</strong> $time</li>
          <li><strong>Reason for Appointment:</strong> $description</li>
          <li><strong>Location:</strong> [Dental Office Address]</li>
          <li><strong>Phone:</strong> [Dental Office Phone Number]</li>
        </ul>
        <p>If you have any questions or need to reschedule, please contact us at [Dental Office Phone Number] or reply to this email.</p>
        <p>We look forward to seeing you!</p>
        ''',
      recipients: [recipientEmail],
      isHTML: true,
    );

    try {
      await FlutterMailer.send(mailOptions);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirmation email sent!')), //send was successful
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send confirmation email: $e')), //send was unsuccessful
      );
    }
  }
}
