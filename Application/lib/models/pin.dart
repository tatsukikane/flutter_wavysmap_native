//Pinをfirestoreに登録用
import 'package:cloud_firestore/cloud_firestore.dart';

class Pin {
  String username;
  String uid;
  String id;
  String caption;
  String videoUrl;
  String thumbnail;

  Pin({
    required this.username,
    required this.uid,
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "id": id,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  static Pin fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Pin(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}
