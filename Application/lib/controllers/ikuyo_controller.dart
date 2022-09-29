import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/models/board_model.dart';
import 'package:flutter_wavysmap_native/models/user.dart';
import 'package:flutter_wavysmap_native/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

//掲示板
//コメントの処理
class IkuyoController extends GetxController {
  final Rx<List<User>> _ikuyoStamp = Rx<List<User>>([]);
  List<User> get ikuyoStamp => _ikuyoStamp.value;
  // final Rx<List<Board>> _ikuyoStamp = Rx<List<Board>>([]);
  // List<Board> get ikuyoStamp => _ikuyoStamp.value;

  //ボードにikuyoスタンプを押した人を管理する配列
  var stampList;

  var _targetBoardId = "";

  updatePostId(String targetBoardId) async{
    _targetBoardId = targetBoardId;
    print(authController.user.uid);
    ikuyo(_targetBoardId);
  }

  //targetbardに行くよスタンプを押したユーザー配列を取得
  getStampList(String targetBoardId) async {
    final docRef = firestore.collection("board").doc(targetBoardId);
    var doc =  await docRef.get();
    final data = doc.data()as Map<String, dynamic>;
    //配列
    final profilePhotoUrl = data['likes'];
    stampList = profilePhotoUrl;
    print(stampList);
    return stampList;
  }




  
  //取得
  //スタンプ用プロフ画像取得
  getPlofImage(uid) async{
    final docRef = firestore.collection("users").doc(uid);
    var doc =  await docRef.get();
    final data = doc.data()as Map<String, dynamic>;
    final profilePhotoUrl = data['profilePhoto'];
    print(profilePhotoUrl);
    return profilePhotoUrl;



    // final data = doc.data() as Map<String, dynamic>;
    // final profilePhotoUrl = data['profilePhoto'];
    // // print(profilePhotoUrl);
    // return profilePhotoUrl;
    // await docRef.get().then(
    //   (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     final profilePhotoUrl = data['profilePhoto'];
    //     // print(profilePhotoUrl);
    //     return profilePhotoUrl;
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
  }

  //   getPlofImage(id) async {
  //     print("1");
  //     // print(id)
  //   _ikuyoStamp.bindStream(
  //     firestore
  //         .collection('users')
  //         .doc(id)
  //         .collection('likes')
  //         .snapshots()
  //         .map(
  //       (QuerySnapshot query) {
  //         List<Board> retValue = [];
  //         for (var element in query.docs) {
  //           retValue.add(Board.fromSnap(element));
  //           print(retValue);
  //         }
  //         return retValue;
  //       },
  //     ),
  //   );
  // }

  //   receive(Controller,widget) async{
  //     if(widget.bordDeta.likes.length > 0) {
  //     final resurt = await Controller.getPlofImage(widget.bordDeta.likes[0]);
  //     print("/////////");
  //     print(resurt);
  //     return resurt;
  //   }
  // }

  
  //投稿
  // postComment(context, String commentText, filepath, selectedLatlng, scheduledDate) async {
  //   try {
  //     if (commentText.isNotEmpty) {
  //       DocumentSnapshot userDoc = await firestore
  //           .collection('users')
  //           .doc(authController.user.uid)
  //           .get();
  //       var allDocs = await firestore
  //           .collection('board')
  //           .get();
  //       int len = allDocs.docs.length;

  //       final downloadUrl = await _uploadToStorage(filepath,len);

  //       Board board = Board(
  //         username: (userDoc.data()! as dynamic)['name'],
  //         comment: commentText.trim(),
  //         datePublished: DateTime.now(),
  //         likes: [],
  //         profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
  //         uid: authController.user.uid, TODO:
  //         id: 'Comment $len',
  //         boardPicture: downloadUrl, 
  //         latlng: selectedLatlng.toString(),
  //         scheduledDate: scheduledDate
  //       );
  //       //データの追加
  //       await firestore
  //           .collection('board')
  //           .doc('Board $len')
  //           .set(
  //             board.toJson(),
  //           );
  //       //処理終了後に画面遷移
  //       Get.snackbar('掲示板',
  //         '投稿完了！');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => HomeScreen(),
  //         ),
  //       );
  //       // DocumentSnapshot doc =
  //       //     await firestore.collection('board').doc(_postId).get();
  //       // await firestore.collection('board').doc(_postId).update({
  //       //   'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
  //       // });
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error While Commenting',
  //       e.toString(),
  //     );
  //   }
  // }

  //ikuyoスタンプ機能
  ikuyo(String id) async {
    print(id);
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore
        .collection('board')
        .doc(id)
        .get();
        // print(doc.data());

    if ((doc.data() as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('board')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
        Get.snackbar(
        '掲示板',
        '参加取り消し...',
      );
    } else {
      await firestore
          .collection('board')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
      Get.snackbar(
        '掲示板',
        '参加完了!',
      );
    }
  }

  // pickImage() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     Get.snackbar('Profile Picture',
  //         'You have successfully selected your profile picture!');
  //   }
  //   _pickedImage = Rx<File?>(File(pickedImage!.path));
  //   return File(pickedImage.path);
  // }

  //ローディング
  // void showProgressDialog(context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     transitionDuration: Duration.zero, // これを入れると遅延を入れなくて
  //     barrierColor: Colors.black.withOpacity(0.8),
  //     pageBuilder: (BuildContext context, Animation animation,
  //         Animation secondaryAnimation) {
  //       return  Center(
  //         child: Lottie.asset(
  //           'assets/alien-space.json',
  //         ),
  //       );
  //     },
  //   );
  // }
}
