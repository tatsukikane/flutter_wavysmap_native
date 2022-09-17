import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {


  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();





  //値が入るまではnullだから、? でnullを許容する形にしてあげる
  String? email;
  String? password;
  String? name;
  String? description;


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

  void setName(String name){
    this.name = name;
    notifyListeners();
  }
  void setDescription(String description){
    this.description = description;
    notifyListeners();
  }


  //firebaseの変更をリッスンしている
  Future singup() async {
    this.email = titleController.text;
    this.password = subtitleController.text;
    this.name = nameController.text;



    //firebase authでユーザー登録




  //メール認証 登録
  // Future<void> createUserFromEmail() async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //     email: 'test@test.com',
  //     password: 'testtest'
  //   );
  //   print('Emailからユーザー作成完了');
  // }

    if(email != null && password != null){
      //認証登録
      final UserCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = UserCredential.user;

      if (user != null && name!= null) {
        //認証登録後にuid取得
        final uid = user.uid;


        //firestoreのデータを変更
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid':uid,
          'email':email,
          'name':name,
          'description':description,
        });
      }
    }

  }
}