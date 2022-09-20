import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/views/screens/home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../main.dart';
import '../video_editor/video_editor.dart';

//動画trimスタート時刻
final StartTrimStateProvider = StateProvider<double>((ref) => 0.0);
//動画trim終了時刻
final EndTrimStateProvider = StateProvider<double>((ref) => 0.0);

//作業中 上記二つのプロバイダーを別ファイルに渡したい
final myProvider = Provider((ref) {
  return 14.097416;
});

//     final resultListenProvider = Provider((ref) {
//   ref.listen<double>(EndTrimStateProvider, (double? previousCount, double? newCount) {
//     print('The counter changed $previousCount $newCount');
//   });
// });

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
    // FirestoreService().get(ref);
    listen(ref);
  }


  //Firestoreのデータベース定義
  final db = FirebaseFirestore.instance;

  //userIDの定義 (null合体演算子: 左がnullの場合は右)
  final userID = FirebaseAuth.instance.currentUser?.uid ?? 'test';

  //データの追加 (使う際はmap名と、collection系に値を入れて使う)
  // void add(WidgetRef ref) {
  //   //Map<String, dynamic>に変換
  //   final Map<String, dynamic> counterMap = {
  //     'count': ref.read(counterProvider),
  //   };

  //   //Firestoreへデータ追加
  //   try{
  //     db.collection().doc().set(counterMap);
  //   } catch(e){
  //     print('Error : $e');
  //   }
  // }

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
      //TODO: doc内の値を動的に入れる
      // await db.collection("messages").doc("LnejSZiJx86FaYQEQwMk").get().then((event) {
      Map<String, dynamic> result = {};

      await db.collection("messages").get().then((event) {
        for (var doc in event.docs) {
          result = doc.data();
          firestoreDataId = doc.id;
          // print("${doc.id} => ${doc.data()}");
        }
        
      //firestore上の解析結果削除
      delete();

      //firestoreのkey:value型のデータ
      // var result = event.data();
      //valueのみを抽出
      var value = result['original'];
      //valueをMAPとして使えるようデコード
      var valueMap = jsonDecode(value);
      //対象のデータを取得できることを確認
      // print(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['endTimeOffset']['seconds']);
      // print(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['startTimeOffset']['seconds']);


      //該当データを入れる変数
      var targetdata;

      //解析データの中から該当データを探す
      //初回検索【bmx bike】
      for(var i = 0; i < valueMap['shotLabelAnnotations'].length; i++){
        if(valueMap['shotLabelAnnotations'][i]['entity']['description'] == 'bmx bike'){
          targetdata = valueMap['shotLabelAnnotations'][i];
        } 
        // print(valueMap['shotLabelAnnotations'][i]['entity']['description']);
      }
      //2回目検索 1回目の検索でヒットしなかった場合【bicycle】に条件を変更し検索
      if(targetdata == null){
        for(var i = 0; i < valueMap['shotLabelAnnotations'].length; i++){
          if(valueMap['shotLabelAnnotations'][i]['entity']['description'] == 'bicycle'){
            targetdata = valueMap['shotLabelAnnotations'][i];
          } 
        }
      }
      if(targetdata == null){
        //解析結果に検索条件が無かった場合は、メインページへ戻す  TODO:ダイアログ(失敗)を表示させてから、遷移
        Navigator.push(
          context,
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
      // final endTime = endSeconds + endNanos;
      final endTime = endSeconds + endNanos;
      print(endTime);

      //プロバイダーにstartTimeとendTimeを渡す
      // var parsedouble = double.parse(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['endTimeOffset']['seconds']);
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
    //リスナー
      // ref.listen<double>(EndTrimStateProvider, (double? previousCount, double? newCount) {
      //   print('The counter changed $previousCount $newCount');
      // });


    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.inkDrop(  //この部分
              color: Colors.white,
              size: 100,
            ),
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




    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Firestore'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           '解析データ',
    //         ),
    //         Text(
    //           'start:${ref.watch(StartTrimStateProvider)} end:${ref.watch(EndTrimStateProvider)}',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //         // TextButton(
    //         //   onPressed: (){
    //         //     ref.watch(StartTrimStateProvider.state).state = 0.0;
    //         //     ref.watch(EndTrimStateProvider.state).state = 0.0;
    //         //     FirestoreService.delete();
    //         //   }, 
    //         //   child: const Text('Reset'));
    //       ],
    //     ),
    //   ),
    // );
  // }
}


// class FirestoreService extends ConsumerState<FirestorePage>{
//     @override
//   void initState() {
//     super.initState();

//     ///Firestoreからデータを取得する場合
//     // FirestoreService().get(ref);
//     listen(ref);
//   }
  

//   @override
//   Widget build(BuildContext context){
//     //リスナー
//       // ref.listen<double>(EndTrimStateProvider, (double? previousCount, double? newCount) {
//       //   print('The counter changed $previousCount $newCount');
//       // });
//     return Scaffold(
//         backgroundColor: Colors.blue,
//         body: Center(
//           child: LoadingAnimationWidget.inkDrop(  //この部分
//             color: Colors.white,
//             size: 100,
//           ),
//         ));
//   }


//   //Firestoreのデータベース定義
//   final db = FirebaseFirestore.instance;

//   //userIDの定義 (null合体演算子: 左がnullの場合は右)
//   final userID = FirebaseAuth.instance.currentUser?.uid ?? 'test';

//   //データの追加 (使う際はmap名と、collection系に値を入れて使う)
//   // void add(WidgetRef ref) {
//   //   //Map<String, dynamic>に変換
//   //   final Map<String, dynamic> counterMap = {
//   //     'count': ref.read(counterProvider),
//   //   };

//   //   //Firestoreへデータ追加
//   //   try{
//   //     db.collection().doc().set(counterMap);
//   //   } catch(e){
//   //     print('Error : $e');
//   //   }
//   // }
//   void listen(WidgetRef ref){
//       final docRef = db.collection("messages");
//       docRef.snapshots().listen(
//         (event) => get(ref),
//         onError: (error) => print("Listen failed: $error"),
//       );
//   }



//   //データ取得
//   void get(WidgetRef ref) async {
//     try{
//       //TODO: doc内の値を動的に入れる
//       // await db.collection("messages").doc("LnejSZiJx86FaYQEQwMk").get().then((event) {
//       Map<String, dynamic> result = {};

//       await db.collection("messages").get().then((event) {
//         for (var doc in event.docs) {
//           result = doc.data();
//           // print("${doc.id} => ${doc.data()}");
//         }
//       //firestoreのkey:value型のデータ
//       // var result = event.data();
//       //valueのみを抽出
//       var value = result!['original'];
//       //valueをMAPとして使えるようデコード
//       var valueMap = jsonDecode(value);
//       //対象のデータを取得できることを確認
//       // print(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['endTimeOffset']['seconds']);
//       // print(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['startTimeOffset']['seconds']);

//      //作業中
//       //該当データを入れる変数
//       var targetdata = null;
//       //解析データの中から該当データを探す
//       //TODO: 'bmx bike'がなかった場合の、第二候補・第三候補を作る
//       for(var i = 0; i < valueMap['shotLabelAnnotations'].length; i++){
//         if(valueMap['shotLabelAnnotations'][i]['entity']['description'] == 'bmx bike'){
//           targetdata = valueMap['shotLabelAnnotations'][i];
//         }
//         // print(valueMap['shotLabelAnnotations'][i]['entity']['description']);
//       }
//       //Start時刻定義(double型)
//       final startSeconds = double.parse(targetdata['segments'][0]['segment']['startTimeOffset']['seconds']);
//       final startNanos = targetdata['segments'][0]['segment']['startTimeOffset']['nanos'] * 0.000000001;
//       // final startTime = startSeconds + startNanos;
//       final startTime = startSeconds + startNanos;
//       print(startTime);
//       // × 0.000000001
//       //End時刻定義(double型)
//       final endSeconds = double.parse(targetdata['segments'][0]['segment']['endTimeOffset']['seconds']);
//       final endNanos = targetdata['segments'][0]['segment']['endTimeOffset']['nanos'] * 0.000000001;
//       // final endTime = endSeconds + endNanos;
//       final endTime = endSeconds + endNanos;
//       print(endTime);

//       //プロバイダーにstartTimeとendTimeを渡す
//       // var parsedouble = double.parse(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['endTimeOffset']['seconds']);
//       ref.watch(StartTrimStateProvider.state).state = startTime;
//       ref.watch(EndTrimStateProvider.state).state = endTime;
//       if(endTime !=0.0){
//         Navigator.of(context).pop();
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (_) => VideoEditor_app(),
//         //   ),
//         // );
//       }
//     });
//     } catch (e){
//       print('Error : $e');
//     }
//   }

//   //データの削除
//   // void delete() async {
//   //   try {
//   //     db.collection("messages").doc("LnejSZiJx86FaYQEQwMk").delete().then((doc) => null);
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }
//   // }
// }