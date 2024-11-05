import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await FirebaseFirestore.instance.collection('myusers').doc(user.uid).set({
        'name': name,
        'email': email,
        'tasks': [],
        'uid': user.uid,
      });
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
