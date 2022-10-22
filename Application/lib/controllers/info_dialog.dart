

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:get/get.dart';



class infoDialogController extends GetxController {

  static addInfo(id) {
   FirebaseFirestore.instance.collection('reports_inappropriate').add({
      'videoid' : id
   });
   print("報告完了");
  }
  

}
