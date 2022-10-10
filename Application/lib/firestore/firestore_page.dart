import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import '../video_editor/video_editor.dart';

//動画trimスタート時刻
final StartTrimStateProvider = StateProvider<double>((ref) => 0.0);
//動画trim終了時刻
final EndTrimStateProvider = StateProvider<double>((ref) => 0.0);


class FirestorePage extends ConsumerStatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  FirestorePageState createState() => FirestorePageState();
}

class FirestorePageState extends ConsumerState<FirestorePage>{
  @override
  void initState() {
    super.initState();

    ///Firestoreからデータを取得する場合
    listen(ref);
  }


  //Firestoreのデータベース定義
  final db = FirebaseFirestore.instance;

  //userIDの定義 (null合体演算子: 左がnullの場合は右)
  final userID = FirebaseAuth.instance.currentUser?.uid ?? 'test';


  //Functionsからのfirestoregeへのデータの追加を監視
  void listen(WidgetRef ref){
      final docRef = db.collection("messages");
      docRef.snapshots().listen(
        (event) => get(ref),
        onError: (error) => print("Listen failed: $error"),
      );
  }

  //Firestore上の解析結果データID
  var firestoreDataId = null;

  //firestore上の解析結果を削除
  void delete() async {
    try {
      db.collection("messages").doc(firestoreDataId).delete().then((doc) => null);
    } catch (e) {
      print('Error: $e');
    }
  }



  //データ取得
  void get(WidgetRef ref) async {
    try{
      Map<String, dynamic> result = {};

      await db.collection("messages").get().then((event) {
        for (var doc in event.docs) {
          result = doc.data();
          firestoreDataId = doc.id;
        }
        
      //firestore上の解析結果削除
      delete();

      //valueのみを抽出
      var value = result['original'];
      //valueをMAPとして使えるようデコード
      var valueMap = jsonDecode(value);
      //対象のデータを取得できることを確認


      //該当データを入れる変数
      var targetdata;

      //解析データの中から該当データを探す
      //初回検索【bmx bike】
      for(var i = 0; i < valueMap['shotLabelAnnotations'].length; i++){
        if(valueMap['shotLabelAnnotations'][i]['entity']['description'] == 'bmx bike'){
          targetdata = valueMap['shotLabelAnnotations'][i];
          // print(targetdata);
        } 
      }
      //2回目検索 1回目の検索でヒットしなかった場合【bicycle】に条件を変更し検索
      if(targetdata == null){
        for(var i = 0; i < valueMap['shotLabelAnnotations'].length; i++){
          if(valueMap['shotLabelAnnotations'][i]['entity']['description'] == 'bicycle'){
            targetdata = valueMap['shotLabelAnnotations'][i];
          } 
        }
      }
      //3回目 解析結果に検索条件が無かった場合は、メインページへ戻す  TODO:ダイアログ(失敗)を表示させてから、遷移
      if(targetdata == null){
        //TODO: チート、デモ動画用
        // targetdata = {"entity":{"entityId":"/m/06w7n5d","description":"bmx bike","languageCode":"en-US"},"categoryEntities":[{"entityId":"/m/0199g","description":"bicycle","languageCode":"en-US"}],"segments":[{"segment":{"startTimeOffset":{"seconds":"11","nanos":0},"endTimeOffset":{"seconds":"13","nanos":0}},"confidence":0.7252429127693176}]};
        //TODO: 下記標準
        //解析不能時Snackbar
        Get.snackbar(
          '動画自動解析',
          '解析不能。動画投稿ページから投稿してください。Sorry...😢',
          icon:const Text(
            "😢",
            style: TextStyle(
              fontSize: 40
            ),
            ),
          duration: const Duration(seconds: 4),
        );
        Navigator.push(
          context,
          //TODO: ボトムバーが消えないようにして、add_video_screenに飛ばす
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
      
      //Start時刻定義(double型)
      final startSeconds = double.parse(targetdata['segments'][0]['segment']['startTimeOffset']['seconds']);
      final startNanos = targetdata['segments'][0]['segment']['startTimeOffset']['nanos'] * 0.000000001;
      // final startTime = startSeconds + startNanos;
      final startTime = startSeconds + startNanos;
      print(startTime);
      // × 0.000000001
      //End時刻定義(double型)
      final endSeconds = double.parse(targetdata['segments'][0]['segment']['endTimeOffset']['seconds']);
      final endNanos = targetdata['segments'][0]['segment']['endTimeOffset']['nanos'] * 0.000000001;
      final endTime = endSeconds + endNanos;
      print(endTime);

      //プロバイダーにstartTimeとendTimeを渡す
      ref.watch(StartTrimStateProvider.state).state = startTime;
      ref.watch(EndTrimStateProvider.state).state = endTime;
      if(endTime !=0.0){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoEditor_app(),
          ),
        );
      }
    });
    } catch (e){
      print('Error : $e');
    }
  }
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
            'assets/alien-space.json',
          ),
            // child: LoadingAnimationWidget.inkDrop(  //この部分
            //   color: Colors.white,
            //   size: 100,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('動画解析中....'),
                  ],
                    // isRepeatingAnimation: true,
                    repeatForever: true
                ),
              )
            ),
          )
        ],
      ));
    }
}