//resource: https://firebase.google.com/docs/auth
//This page manages user authentication
import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //sign in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //create an account
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


}