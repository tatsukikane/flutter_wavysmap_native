import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/video_upload/video_upload.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/signup_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/board_add_screen.dart';
import 'package:flutter_wavysmap_native/views/widgets/card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_wavysmap_native/views/screens/confirm_screen.dart';
import 'package:lottie/lottie.dart';

class AddVideoScreen extends ConsumerWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    print(File(video!.path));
    print(video.path);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    // //lat lng 単体
    // print(sharedPreferences.getDouble('latitude'));
    // print(sharedPreferences.getDouble('longitude'));
    // //latlng型
    // print(getLatLngFromSharedPrefs());
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (authController.user.isAnonymous){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/alien3.png'),
              const Text(
                "アカウント登録が必要です。",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height:24),
              ElevatedButton(
                onPressed: () {
                  authController.signOut();        
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'アカウント作成',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Lottie.asset(
              'assets/bang.json',
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(
                //   width: 190,
                //   height: 50,
                //   child: ElevatedButton(
                //     child: Text(
                //       'Add Video',
                //     ),
                //     onPressed: () => showOptionsDialog(context),
                //     style: ElevatedButton.styleFrom(
                //       textStyle: TextStyle(
                //         fontSize: 20,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(20),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 24),
                // SizedBox(
                //   width: 190,
                //   height: 50,
                //   child: ElevatedButton(
                //     child: Text(
                //       'Auto Trimming',
                //     ),
                //     onPressed: () => CloudStorageService().uploadVideo(ref, context),
                //     style: ElevatedButton.styleFrom(
                //       textStyle: TextStyle(
                //         fontSize: 20,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(20),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 24),
                // //テスト
                // SizedBox(
                //   width: 190,
                //   height: 50,
                //   child: ElevatedButton(
                //     child: Text(
                //       '掲示板',
                //     ),
                //     onPressed: (){
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => BoardAddScreen(),
                //         ),
                //     );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       textStyle: TextStyle(
                //         fontSize: 20,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(20),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: screenHeight / 33),
                InkWell(
                  onTap: () => showOptionsDialog(context),
                  child: TransparentImageCard(
                    width: MediaQuery.of(context).size.height,
                    imageProvider: const AssetImage('assets/image/alien.jpeg'),
                    title: const Text(
                      '動画投稿',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    description: const Text(
                      'カメラから動画を投稿',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 33),
                InkWell(
                  onTap: () => CloudStorageService().uploadVideo(ref, context),
                  child: TransparentImageCard(
                    width: MediaQuery.of(context).size.height,
                    imageProvider: const AssetImage('assets/image/alien2.jpeg'),
                    title: const Text(
                      '自動トリミング',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    description: const Text(
                      'おまかせ自動編集でサクッと投稿(BMX限定)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 33),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BoardAddScreen(),
                      ),
                    );
                  },
                  child: TransparentImageCard(
                    width: MediaQuery.of(context).size.height,
                    imageProvider: const AssetImage('assets/icon.jpeg'),
                    title: const Text(
                      '掲示板',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    description: const Text(
                      '自由に仲間を募集しよう',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: (){
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => BoardAddScreen(),
                //       ),
                //     );
                //   },
                //   child: Text("掲示板"))
                // InkWell(
                //   onTap: (){
                //     CloudStorageService().uploadVideo(ref, context);
                //   },
                //   // onTap: () => Navigator.push(
                //   //   context,
                //   //   MaterialPageRoute(builder: (context) => const VideoUploadPage()),
                //   // ),
                //   child: Container(
                //     width: 190,
                //     height: 50,
                //     decoration: BoxDecoration(color: buttonColor),
                //     child: const Center(
                //       child: Text(
                //         'Auto Trimming',
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
