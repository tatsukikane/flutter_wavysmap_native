import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/video_editor/video_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


/// 動画表示用Provider
final VideoStateProvider = StateProvider((ref) => null);

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
    //savedVideoPathProvider(トリム後の保存したデータのpath)の値をputFile()で使えるよう変数に代入
    savedVideoPath = ref.read(savedVideoPathProvider.state).state;
    super.initState();
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
                  CloudStorageService().uploadVideo();
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
  void uploadVideo() async {
    try{
      //動画を選択
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      // File file = File(video!.path);
      File file = File(pickedFile!.path);

      //TODO: 下記1行のコメントアウトを外し、putFile(file);の値を変える。 解析動画を上げる時と、投稿動画を上げる時の切り分けを実装
      //下記で取得したpathから動画をfirebase storageにUPできた putFile(file)のfileの部分を変えればok
      // File file1 = File.fromUri(Uri.parse(VideoStateProviderPath));
      // print(file1);


    //Firebase Cloud Storageにアップロード
      //TODO:
      //uploadNameは動的に変更する(投稿動画の場合)
      String uploadName = 'trim.mp4';
      //解析用動画UP用参照
      final storageRef = FirebaseStorage.instance.ref().child('${uploadName}');

      //投稿動画UP用参照 投稿時にその動画のURIを取得する
      final storage = FirebaseStorage.instanceFor(bucket: "gs://functions-test-post").ref().child('${uploadName}');

      final task = await storageRef.putFile(file);
      // final task = await storage.putFile(file, SettableMetadata(
      //   //型定義
      //   contentType: "video/mp4",
      // ));

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
    } catch (e) {
      print(e);
    }
  }





  //画像のダウンロード
  // void downloadPic(WidgetRef ref) async{
  //   try {
  //     //参照の作成
  //     String downloadName = 'trim.mp4';
  //     final storageRef = FirebaseStorage.instance.refFromURL('gs://functions-test-7bc83.appspot.com');

  //     //画像をメモリに保存し、Uni8Listへ変換
  //     const oneMegabyte = 1024 * 1024;
  //     ref.read(VideoStateProvider.state).state = await storageRef.getData();
  //   } on FirebaseException catch (e) {
  //   // Handle any errors.
  // }
  // }

}





// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class video_upload extends StatefulWidget {
//   const video_upload({Key? key}) : super(key: key);

//   @override
//   State<video_upload> createState() => _video_uploadState();
// }

// class _video_uploadState extends State<video_upload> {
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }