import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  // Future型で書く
  Future signUp() async {
    this.email = emailController.text;
    this.password = passwordController.text;

    if(email != null && password != null) {
      // firebase authでユーザーを作成
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if(user != null) {
        final uid = user.uid;

        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection('user').doc(uid);

        await doc.set({
          'uid': uid,
          'email': email,
        });
      }
    }

  }
}