import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/video_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/comment_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/video_latlang_map_screen.dart';
import 'package:flutter_wavysmap_native/views/widgets/circle_animation.dart';
import 'package:flutter_wavysmap_native/views/widgets/video_player_item.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class profile_video_dialog extends StatefulWidget {
  //カルーセルに対応する動画のデータを取得
  final videodeta;
  profile_video_dialog({Key? key, required this.videodeta}) : super(key: key);

  @override
  State<profile_video_dialog> createState() => _video_dialogState();
}

class _video_dialogState extends State<profile_video_dialog> {
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
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayerItem(
            videoUrl: widget.videodeta["videoUrl"],
          ),
          //動画削除機能
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 96),
              InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text("投稿を削除する"),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () => {
                              //TODO: 動画削除関数を作る　削除完了後の表示も
                              print("動画削除機能実装予定")
                            },
                            child: const Text("はい"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.delete_outline,
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
                    //画面下部
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
                            Text(
                              widget.videodeta["username"],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  widget.videodeta["songName"],
                                  style: const TextStyle(
                                    fontSize: 15,
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
                                Flexible(
                                  child: Text(
                                    widget.videodeta["caption"],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //画面右部
                    Container(
                      width: 64,
                      margin: EdgeInsets.only(top: size.height / 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildProfile(
                            widget.videodeta["profilePhoto"],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                      id: widget.videodeta["id"],
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.comment,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.videodeta["commentCount"].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: (){
                              LatLng position = LatLng(widget.videodeta["latitude"], widget.videodeta["longitude"]);
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
                          CircleAnimation(
                            child: SizedBox(
                              width: 80,
                              height: 70,
                              child: Image.asset('assets/icon/bmx_logo.png',fit: BoxFit.contain)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: IconButton(
              icon: Icon(Icons.undo, size: 32, color: Colors.blue.shade300,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}