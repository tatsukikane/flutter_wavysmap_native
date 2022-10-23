

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/main.dart';



class userBlockDialogController extends GetxController {

  static addBlockList(id) async{
   //TODO: 本来はこっちで、アプリ内で、ブロック済みユーザーのデータのフィルタリングをかける
  //  await FirebaseFirestore.instance
  //  .collection('users')
  //  .doc(authController.user.uid)
  //  .collection('blocklist')
  //  .add({
  //     'videoid' : id
  //  });

  //ブロックしたユーザーのUIDを、ユーザーデフォルトに保存
  await sharedPreferences.setString('blockedUser', id);
  Get.snackbar('ユーザーブロック',
    '対象のユーザーのブロックが完了しました');
   //審査用
  //   await FirebaseFirestore.instance
  //  .collection('blocklist')
  //  .doc('block')
  //  .set({
  //     'userid' : id
  //  });
  //  Get.snackbar('ユーザーブロック',
  //   '対象のユーザーのブロックが完了しました');
  //   print("ブロック完了");
    //splashスクリーンに戻せばいいのでは？
  }

  //ブロック解除 ユーザーデフォルトの削除
  // static unblock() async{
  //   final success = await sharedPreferences.remove('blockedUser');
  //   Get.snackbar('ユーザーブロック解除',
  //     '対象のユーザーのブロック解除が完了しました');
  // }

}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_wavysmap_native/models/video.dart';
// import 'package:get/get.dart';
// import 'package:flutter_wavysmap_native/constants.dart';

// class ProfileController extends GetxController {
//   final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
//   Map<String, dynamic> get user => _user.value;

//   Rx<String> _uid = "".obs;

//   updateUserId(String uid) {
//     _uid.value = uid;
//     getUserData();
//   }

//   getUserData() async {
//     List<String> thumbnails = [];
//     var myVideos = await firestore
//         .collection('videos')
//         .where('uid', isEqualTo: _uid.value)
//         .get();

//     for (int i = 0; i < myVideos.docs.length; i++) {
//       thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
//     }

//     DocumentSnapshot userDoc =
//         await firestore.collection('users').doc(_uid.value).get();
//     final userData = userDoc.data()! as dynamic;
//     String name = userData['name'];
//     String profilePhoto = userData['profilePhoto'];
//     int likes = 0;
//     int followers = 0;
//     int following = 0;
//     bool isFollowing = false;

//     for (var item in myVideos.docs) {
//       likes += (item.data()['likes'] as List).length;
//     }
//     var followerDoc = await firestore
//         .collection('users')
//         .doc(_uid.value)
//         .collection('followers')
//         .get();
//     var followingDoc = await firestore
//         .collection('users')
//         .doc(_uid.value)
//         .collection('following')
//         .get();
//     followers = followerDoc.docs.length;
//     following = followingDoc.docs.length;

//     firestore
//         .collection('users')
//         .doc(_uid.value)
//         .collection('followers')
//         .doc(authController.user.uid)
//         .get()
//         .then((value) {
//       if (value.exists) {
//         isFollowing = true;
//       } else {
//         isFollowing = false;
//       }
//     });

//     _user.value = {
//       'followers': followers.toString(),
//       'following': following.toString(),
//       'isFollowing': isFollowing,
//       'likes': likes.toString(),
//       'profilePhoto': profilePhoto,
//       'name': name,
//       'thumbnails': thumbnails,
//     };
//     update();
//   }

//   followUser() async {
//     var doc = await firestore
//         .collection('users')
//         .doc(_uid.value)
//         .collection('followers')
//         .doc(authController.user.uid)
//         .get();

//     if (!doc.exists) {
//       await firestore
//           .collection('users')
//           .doc(_uid.value)
//           .collection('followers')
//           .doc(authController.user.uid)
//           .set({});
//       await firestore
//           .collection('users')
//           .doc(authController.user.uid)
//           .collection('following')
//           .doc(_uid.value)
//           .set({});
//       _user.value.update(
//         'followers',
//         (value) => (int.parse(value) + 1).toString(),
//       );
//     } else {
//       await firestore
//           .collection('users')
//           .doc(_uid.value)
//           .collection('followers')
//           .doc(authController.user.uid)
//           .delete();
//       await firestore
//           .collection('users')
//           .doc(authController.user.uid)
//           .collection('following')
//           .doc(_uid.value)
//           .delete();
//       _user.value.update(
//         'followers',
//         (value) => (int.parse(value) - 1).toString(),
//       );
//     }
//     _user.value.update('isFollowing', (value) => !value);
//     update();
//   }

//   //サムネイルから、動画のコレクションを取得
//   getVideo(profImgPath) async{
//     var videoCollection;
//     final citiesRef = await firestore.collection("videos");
//     final _query = await citiesRef.where("thumbnail", isEqualTo: profImgPath);
//     final _data = await _query.get();
//     final queryDocSnapshot = await _data.docs;
//     for (final snapshot in queryDocSnapshot) {
//       final data = await snapshot.data();
//       videoCollection = await data;
//       // print("ここ$data");
//     }
//     return videoCollection;
//   }
// }
