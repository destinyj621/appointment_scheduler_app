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
            _callButton(),
            _websiteButton(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _websiteButton(){
    return ElevatedButton(
      onPressed: () async {
        await EasyLauncher.url(
            url: "https://www.familysmilecenter.net/",
            mode: Mode.platformDefault);
      },
      child: const Text("Open Website"),
    );
  }

  Widget _signOutButton(){
    return ElevatedButton(
        onPressed: signOut,
        child: const Text('Sign Out'),
    );
  }

  Widget _callButton(){
    return ElevatedButton(
      onPressed: () async {
        await EasyLauncher.call(number: "6786229815");
      },
      child: const Text("Call Office"),
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