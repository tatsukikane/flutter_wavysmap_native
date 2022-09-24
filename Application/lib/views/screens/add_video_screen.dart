import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:flutter_wavysmap_native/map/helpers/shared_prefs.dart';
import 'package:flutter_wavysmap_native/video_upload/video_upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/views/screens/confirm_screen.dart';
import 'package:lottie/lottie.dart';

class AddVideoScreen extends ConsumerWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    print("ここ");
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
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/dot-pattern-background.json',
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => showOptionsDialog(context),
                  child: Container(
                    width: 190,
                    height: 50,
                    decoration: BoxDecoration(color: buttonColor),
                    child: const Center(
                      child: Text(
                        'Add Video',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: (){
                    CloudStorageService().uploadVideo(ref, context);
                  },
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const VideoUploadPage()),
                  // ),
                  child: Container(
                    width: 190,
                    height: 50,
                    decoration: BoxDecoration(color: buttonColor),
                    child: const Center(
                      child: Text(
                        'Auto Trimming',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
