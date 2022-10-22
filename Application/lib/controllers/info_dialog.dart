

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:get/get.dart';



class infoDialogController extends GetxController {

  static addInfo(id) async{
   await FirebaseFirestore.instance.collection('reports_inappropriate').add({
      'videoid' : id
   });
  Get.snackbar('動画報告申請',
  '対象の動画の報告申請が完了しました');
   print("報告完了");
  }
  

}
