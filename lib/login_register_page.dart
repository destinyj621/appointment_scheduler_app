//This is the log in and register page
//resource: https://firebase.google.com/docs/auth
//resource: https://www.youtube.com/watch?v=rWamixHIKmQ&list=LL&index=2&t=351s

//TODO: fix logo, include dental office name

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointmentsetter/auth.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  String? errorMessage = '';
  bool isLogin = true;

  //text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //sign in with email and password
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text,
          password: _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  //create account with email and password
  Future<void> createUserInWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _title() {
    return const Text('Dental Office');
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      )
    );
  }
  
  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  //submit credentials
  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserInWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Create an Account'),
    );
  }

  //set state for logging in or creating an account
  Widget _loginOrRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Create an Account' : 'Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _title()
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _emailController), //email text field
            _entryField('password', _passwordController), //password text field
            _errorMessage(), //error message
            _submitButton(), //submit button
            _loginOrRegisterButton(), //login or register
          ],
        ),
      ),
    );
  }
}

