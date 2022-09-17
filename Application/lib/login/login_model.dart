import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginModel extends ChangeNotifier {


  final titleController = TextEditingController();
  final subtitleController = TextEditingController();



  //値が入るまではnullだから、? でnullを許容する形にしてあげる
  String? email;
  String? password;

    bool isLoading = false;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }





  void setEmail(String email){
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password){
    this.password = password;
    notifyListeners();
  }


  //firebaseの変更をリッスンしている
  Future login() async {
    this.email = titleController.text;
    this.password = subtitleController.text;

    if (email != null && password != null){
      //ログイン
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      // final currentUser = FirebaseAuth.instance.currentUser;
      // final uid = currentUser!.uid;
    }

  }
}