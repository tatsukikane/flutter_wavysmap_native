import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
//掲示板
class Board {
  String username;
  String comment;
  final datePublished; //時間
  List likes;
  String profilePhoto;
  String uid;
  String id;
  String boardPicture;  //写真の添付もできるようにする
  String? latlng;
  String scheduledDate;


  Board({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
    required this.boardPicture,
    this.latlng,
    required this.scheduledDate
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
        'boardPicture': boardPicture,
        'latlng': latlng,
        'scheduledDate': scheduledDate

      };

  static Board fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Board(
      username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      boardPicture: snapshot['boardPicture'],
      latlng: snapshot['latlng'],
      scheduledDate: snapshot['scheduledDate']
    );
  }
}
