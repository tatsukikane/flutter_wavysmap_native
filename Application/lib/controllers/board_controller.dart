import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/models/board_model.dart';
import 'package:flutter_wavysmap_native/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

//掲示板
//コメントの処理
class BoardController extends GetxController {
  final Rx<List<Board>> _comments = Rx<List<Board>>([]);
  List<Board> get comments => _comments.value;
  late Rx<File?> _pickedImage;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }
  
  //取得
  getComment() async {
    _comments.bindStream(
      firestore
          .collection('board')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Board> retValue = [];
          for (var element in query.docs) {
            retValue.add(Board.fromSnap(element));
            print(retValue);
          }
          return retValue;
        },
      ),
    );
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image, len) async {
    Reference ref = FirebaseStorage.instanceFor(bucket: "gs://board-image")
        .ref()
        .child('Board $len');

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
  
  //投稿
  postComment(context, String commentText, filepath, selectedLatlng, scheduledDate) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore
            .collection('board')
            .get();
        int len = allDocs.docs.length;

        final downloadUrl = await _uploadToStorage(filepath,len);

        Board board = Board(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',
          boardPicture: downloadUrl, 
          latlng: selectedLatlng.toString(),
          scheduledDate: scheduledDate
        );
        //データの追加
        await firestore
            .collection('board')
            .doc('Board $len')
            .set(
              board.toJson(),
            );
        //処理終了後に画面遷移
        Get.snackbar('掲示板',
          '投稿完了！');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
        // DocumentSnapshot doc =
        //     await firestore.collection('board').doc(_postId).get();
        // await firestore.collection('board').doc(_postId).update({
        //   'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        // });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  //??  ここをスタンプ機能に変換すればよさそう
  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore
        .collection('board')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('board')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore
          .collection('board')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
    return File(pickedImage.path);
  }

  //ローディング
  void showProgressDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration.zero, // これを入れると遅延を入れなくて
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return  Center(
          child: Lottie.asset(
            'assets/alien-space.json',
          ),
        );
      },
    );
  }
}
