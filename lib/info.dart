//This page is the info page. It includes user info and the sign out button.
import 'package:flutter/material.dart';
import 'package:appointmentsetter/auth.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';


class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _sendEmailButton(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton(){
    return ElevatedButton(
        onPressed: signOut,
        child: const Text('Sign Out'),
    );
  }

  Widget _sendEmailButton(){
    return ElevatedButton(
      onPressed: () async {
        await EasyLauncher.email(
            email: "destinyj621@gmail.com",
            subject: "Dental Office",
            body: "Write a message...");
      },
      child: const Text("Send an Email"),
    );
  }
}