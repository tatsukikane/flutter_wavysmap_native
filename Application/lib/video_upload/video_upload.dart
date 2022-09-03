import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


/// 動画表示用Provider
final VideoStateProvider = StateProvider((ref) => null);

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
  //アップロード
  void uploadVideo() async {
    try{
      //動画を選択
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      // File file = File(video!.path);
      File file = File(pickedFile!.path);

      //Firebase Cloud Storageにアップロード
      String uploadName = 'trim.mp4';
      final storageRef = FirebaseStorage.instance.ref().child('${uploadName}');
      final task = await storageRef.putFile(file);
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