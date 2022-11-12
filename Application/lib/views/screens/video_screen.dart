import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/controllers/info_dialog.dart';
import 'package:flutter_wavysmap_native/controllers/video_controller.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';
import 'package:flutter_wavysmap_native/views/screens/comment_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/video_latlang_map_screen.dart';
import 'package:flutter_wavysmap_native/views/widgets/circle_animation.dart';
import 'package:flutter_wavysmap_native/views/widgets/video_player_item.dart';
import 'package:flutter_wavysmap_native/controllers/user_block_dialog.dart';

import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 80,
      height: 70,
      child: Image.asset('assets/icon/bmx_logo.png',fit: BoxFit.contain,),
      // child: Column(
      //   children: [
      //     Container(
      //         padding: EdgeInsets.all(11),
      //         height: 50,
      //         width: 50,
      //         decoration: BoxDecoration(
      //             gradient: const LinearGradient(
      //               colors: [
      //                 Colors.grey,
      //                 Colors.white,
      //               ],
      //             ),
      //             borderRadius: BorderRadius.circular(25)),
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(25),
      //           child: Image.asset('assets/icon/ufo.png'),
      //         )
      //     )
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                ),
                //ヘルプページ
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 96,),
                     InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text("ヘルプページ"),
                              children: <Widget>[
                                //投稿報告
                                SimpleDialogOption(
                                  onPressed: () => infoDialogController.addInfo(data.id),
                                  child: const Text("投稿を報告する"),
                                ),
                                SimpleDialogOption(
                                  onPressed: ()async{
                                    await userBlockDialogController.addBlockList(data.uid);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => Splash(),
                                    //   ),
                                    // );
                                  },
                                  child: const Text("ユーザーをブロックする"),
                                ),
                                // SimpleDialogOption(
                                //   onPressed: (){
                                //     userBlockDialogController.unblock();
                                //   },
                                //   child: const Text("ユーザーをブロック解除する"),
                                // ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16, top: 16),
                        child: const Icon(
                          Icons.help_outline,
                          size: 32,
                        ),
                      )
                     ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 56,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      // const Icon(
                                      //   Icons.person,
                                      //   size: 20,
                                      //   color: Colors.white,
                                      // ),
                                      Text(
                                        data.username,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        data.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.chat,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Flexible(
                                        child: Text(
                                          data.caption,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 64,
                            margin: EdgeInsets.only(top: size.height / 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                buildProfile(
                                  data.profilePhoto,
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          videoController.likeVideo(data.id),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 32,
                                        color: data.likes.contains(
                                                authController.user.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    // const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                  const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                            id: data.id,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.comment,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // const SizedBox(height: 7),
                                    Text(
                                      data.commentCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: (){
                                    LatLng position = LatLng(data.latitude, data.longitude);
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (context) => VideoLatlangMap(position: position)
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "🌏",
                                    style: TextStyle(
                                      fontSize: 32
                                    ),
                                  ),
                                ),
                                //[reply]
                                // Column(
                                //   children: [
                                //   SizedBox(height: 8),
                                //     InkWell(
                                //       onTap: () {},
                                //       child: const Icon(
                                //         Icons.reply,
                                //         size: 32,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     // const SizedBox(height: 7),
                                //     Text(
                                //       data.shareCount.toString(),
                                //       style: const TextStyle(
                                //         fontSize: 20,
                                //         color: Colors.white,
                                //       ),
                                //     )
                                //   ],
                                // ),
                                const SizedBox(height: 8),
                                CircleAnimation(
                                  child: buildMusicAlbum(data.profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
