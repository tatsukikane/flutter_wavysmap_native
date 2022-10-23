import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/models/video.dart';

//ここでfirebseのデータをストリームで持ってくる処理
//リアルタイムで更新されていく
class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  //TODO: ユーザーブロック機能 ユーザーデフォルト
  final String? blockedUser = sharedPreferences.getString('blockedUser');

  @override
  void onInit() {
    super.onInit();
    //TODO: ユーザーブロック機能 動画フィルタリング
    if(blockedUser != null){
      _videoList.bindStream(
        firestore.collection('videos').where('uid', isNotEqualTo: blockedUser).snapshots().map((QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Video.fromSnap(element),
            );
          }
          return retVal;
        })
      );
    } else{
      _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Video.fromSnap(element),
            );
          }
          return retVal;
        })
      );
    }
    // _videoList.bindStream(
    //   firestore.collection('videos').snapshots().map((QuerySnapshot query) {
    //     List<Video> retVal = [];
    //     for (var element in query.docs) {
    //       retVal.add(
    //         Video.fromSnap(element),
    //       );
    //     }
    //     return retVal;
    //   })
    // );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
