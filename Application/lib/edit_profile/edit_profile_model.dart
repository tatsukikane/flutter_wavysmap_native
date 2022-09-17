import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.name, this.description){
    nameController.text = name!;
    descriptionController.text = description!;
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final picker = ImagePicker();
  bool isLoading = false;
  void startLoading(){
    isLoading = true;
    notifyListeners();
  }
  void endLoading(){
    isLoading = false;
    notifyListeners();
  }



  //値が入るまではnullだから、? でnullを許容する形にしてあげる
  String? name;
  String? description;
  File? imageFile;


  void setname(String name){
    this.name = name;
    notifyListeners();
  }

  void setdescription(String description){
    this.description = description;
    notifyListeners();
  }

  bool isUpdated(){
    return name != null || description != null;
  }


  //firebaseの変更をリッスンしている
  Future update() async {
    this.name = nameController.text;
    this.description = descriptionController.text;

    //firestoreのデータを変更
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? imgurl;
    if (imageFile != null){
      // storageにアップロード
      final storage = FirebaseStorage.instanceFor(bucket: "gs://user-prof-img").ref().child('${uid}');
      final task = await storage.putFile(imageFile!);
      imgurl = await task.ref.getDownloadURL();
    }



    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name':name,
      'description':description,
      'profurl':imgurl,
    });
  }

  // pickImage() {}
    Future pickImage() async {
  //カメラから直どりだけにしたから後でここは変える
  //final pickedFile = await picker.pickImage(source: ImageSource.camera); //ギャラリー
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);  //カメラ

  if (pickedFile != null) {
    imageFile = File(pickedFile.path);
    notifyListeners();
  }
}

}