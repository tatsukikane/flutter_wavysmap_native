import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wavysmap_native/models/board_model.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';

//掲示板
//コメントの処理
class BoardController extends GetxController {
  final Rx<List<Board>> _comments = Rx<List<Board>>([]);
  List<Board> get comments => _comments.value;

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
  
  //投稿
  postComment(String commentText) async {
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

        Board board = Board(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',
          boardPicture: "imagepickerから取ったURL入れる null許容", 
        );
        //データの追加
        await firestore
            .collection('board')
            .doc('Board $len')
            .set(
              board.toJson(),
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
}
