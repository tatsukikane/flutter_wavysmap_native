import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:flutter_wavysmap_native/map/helpers/directions_handler.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';
import 'package:flutter_wavysmap_native/models/pin.dart';
import 'package:flutter_wavysmap_native/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/models/video.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  //ストレージへ投稿動画保存
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instanceFor(bucket: "gs://functions-test-post").ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  //サムネ保存
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instanceFor(bucket: "gs://functions-test-post").ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath, controller) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
        latitude: sharedPreferences.getDouble('latitude')!,
        longitude: sharedPreferences.getDouble('longitude')!
      );

      //FirestoreへのPin情報の登録
      Pin pin = Pin(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Pin $len",
        videoId: "Video $len",
        spotName: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        latitude: sharedPreferences.getDouble('latitude')!,
        longitude: sharedPreferences.getDouble('longitude')!
      );

      //Firestoreへのvideo登録
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      //FirestoreへのPin登録
      await firestore.collection('pins').doc('pin $len').set(
        pin.toJson(),
          );
      //下記に行Map上のpinを更新
      await get();
      await pinsUpdate();
      //動画のStop
      await controller.pause();

      Get.to(HomeScreen());
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }


  //-------------------------動画投稿時のPin更新用------------------------------------------
  Future get() async{
    var collection = await FirebaseFirestore.instance.collection('pins').get();
    products = collection.docs.map((doc) => PinModel(
            doc['username'],
            doc['uid'],
            doc['id'],
            doc['videoId'],
            doc['spotName'],
            doc['caption'],
            doc['videoUrl'],
            doc['thumbnail'],
            doc['latitude'],
            doc['longitude'],
        )).toList();
        print("ここやで");
        // print(products[0].);
  }
  Future pinsUpdate() async {
    // ユーザーの現在地を取得する
    LatLng currentLatLng =
        LatLng(sharedPreferences.getDouble('latitude')!,sharedPreferences.getDouble('longitude')!);
    for (int i = 0; i < products.length; i++) {
      //リスト内要素をAPIに渡す
      Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }
  }
  //-------------------------動画投稿時のPin更新用------------------------------------------
}
