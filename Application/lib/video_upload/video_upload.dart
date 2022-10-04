import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/controllers/board_controller.dart';
import 'package:flutter_wavysmap_native/video_editor/video_editor.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';

import '../firestore/firestore_page.dart';


/// 動画表示用Provider
final VideoStateProvider = StateProvider((ref) => null);

//TODO: 選択した動画のPath用Provider videoeditorページで再選択しなくて良いように使う
final originalVideoPathProvider = StateProvider((ref) => XFile(""));

//savedVideoPathProviderの値を入れる変数に代入
String savedVideoPath = "";

//解析用動画up
class VideoUploadPage extends ConsumerStatefulWidget {
  const VideoUploadPage({Key? key}) : super(key: key);

  @override
  VideoUploadPageState createState() => VideoUploadPageState();
}

class VideoUploadPageState extends ConsumerState<VideoUploadPage> {
  @override
  void initState() {
    super.initState();
    //savedVideoPathProvider(トリム後の保存したデータのpath)の値をputFile()で使えるよう変数に代入
    savedVideoPath = ref.read(savedVideoPathProvider.state).state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('動画UP'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  CloudStorageService().uploadVideo(ref, context);
                },
                child: const Icon(Icons.upload),
              ),
              //トリミング済みの動画のUP 関数未定義
              ElevatedButton(
                onPressed: (){
                  CloudStorageService().uploadPostVideo();
                },
                child: Text('トリミング動画UP'),
              ),
            ],
          ),
          ref.watch(VideoStateProvider) == null
            ? const Text('No Video')
            : Image.memory(ref.watch(VideoStateProvider)!),
        ],
      ),
    );
  }
}



//CloudStorage
class CloudStorageService {
  //ユーザーIDの取得
  final userID = FirebaseAuth.instance.currentUser ?? '';

  //【解析用動画のアップロード関数】
  void uploadVideo(WidgetRef ref, context) async {

    try{
      //動画を選択
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      showProgressDialog(context);

      File file = File(pickedFile!.path);


      // `ref` を通じて他のプロバイダを利用する
      ref.read(originalVideoPathProvider.state).state = pickedFile;
      print(ref.read(originalVideoPathProvider.state).state);
      



    //Firebase Cloud Storageにアップロード
      //TODO:
      //uploadNameは動的に変更する(投稿動画の場合)
      String uploadName = 'trim3.mp4';
      //解析用動画UP用参照
      final storageRef = FirebaseStorage.instance.ref().child('${uploadName}');

      //投稿動画UP用参照 投稿時にその動画のURIを取得する
      final storage = FirebaseStorage.instanceFor(bucket: "gs://functions-test-post").ref().child('${uploadName}');

      final task = await storageRef.putFile(file);

      //動画保存処理終了後に画面遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FirestorePage(),
        ),
      );


      print("done");
    } catch (e) {
      print(e);
    }
  }

  //【投稿用動画のアップロード関数】
  void uploadPostVideo() async {
    try{
      //トリミング機能画面で保存した動画のpathから、File型に変換。
      File file = File.fromUri(Uri.parse(savedVideoPath));
      print(file);

    //Firebase Cloud Storageにアップロード
      //uploadNameは動的に変更する
      String uploadName = 'trim.mp4';

      //投稿動画UP用参照       TODO: 投稿時にその動画のURIを取得する
      final storage = FirebaseStorage.instanceFor(bucket: "gs://functions-test-post").ref().child('${uploadName}');

      //動画をstorageに保存
      final task = await storage.putFile(file, SettableMetadata(
        //メタデータの型定義
        contentType: "video/mp4",
      ));
      print("done");
      //TODO: StorageへのUP完了後画面遷移
    } catch (e) {
      print(e);
    }
  }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/alien-city.json',
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
                          WavyAnimatedText('動画読み込み中....'),
                        ],
                          // isRepeatingAnimation: true,
                          repeatForever: true
                      ),
                    )
                  ),
                )
            ],
          ),
        );
      },
    );
  }