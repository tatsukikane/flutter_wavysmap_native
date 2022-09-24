import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/video_controller.dart';
import 'package:flutter_wavysmap_native/map/screens/video_dialog.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';
import 'package:get/get.dart';

import '../constants/restaurants.dart';

Widget carouselCard(int index, num distance, num duration, BuildContext context) {
  final VideoController videoController = Get.put(VideoController());

  //videoController.videoListからtapされたカルーセルと同じvideoIDのリストを取得
  var data = videoController.videoList[index];
  videoController.videoList.forEach((list) {
    if(list.id == products[index].videoId){
      data = list;
    }
  });
  //----------------------
  return InkWell(
    //TODO: カルーセルタップ時に動画を再生させる処理を書く
    onTap: (){
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return video_dialog(videodeta: data);
        }
      );
    },
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              // backgroundImage: NetworkImage(restaurants[index]['image']),
              backgroundImage: NetworkImage(products[index].thumbnail),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // restaurants[index]['name'],
                    products[index].spotName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Text(restaurants[index]['items'],
                  Text(products[index].caption,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text(
                    '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                    style: const TextStyle(color: Colors.tealAccent),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
