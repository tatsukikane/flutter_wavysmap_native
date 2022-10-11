//掲示板の詳細
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_wavysmap_native/controllers/ikuyo_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/video_latlang_map_screen.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../controllers/board_controller.dart';

class BoardDetailScreen extends StatefulWidget {
  final bordDeta;
  BoardDetailScreen({super.key, required this.bordDeta});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}


class _BoardDetailScreenState extends State<BoardDetailScreen> {
  IkuyoController ikuyoController = Get.put(IkuyoController());

  //futurebuilder用関数
  Future _videoOutput() async {
    var list = await ikuyoController.getStampList(widget.bordDeta.id);
    var imgList = [];
    for(var i = 0; i < list.length; i++){
      imgList.add(await ikuyoController.getPlofImage(list[i]));
    }
    return imgList;
  }

  @override
  Widget build(BuildContext context) {
    var ikuyoProfImage = "";
    final size = MediaQuery.of(context).size;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                height: size.height / 5,
                width: size.width,
                fit: BoxFit.cover,
                // imageUrl: restaurants[index]['image'],
                imageUrl: widget.bordDeta.boardPicture,
              ),
              //掲示板の位置情報をMap上で確認
              Positioned(
                top: 100,
                right: 10,
                child: InkWell(
                  onTap: (){
                    //LatLng型に変換できなかった為、文字列操作
                    final stringLatLng = widget.bordDeta.latlng.split(",");
                    double lat = double.parse(stringLatLng[0].split("(")[1]);
                    double lng = double.parse(stringLatLng[1].split(")")[0]);
              
                    LatLng position = LatLng(lat, lng);
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
                      fontSize: 48
                    ),
                  ),
                ),
              ),
            ]
          ),
          Expanded(
            child: Stack(
              children:[ 
                Container(
                  height: 240,
                  width: size.width,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.today),
                          Text(
                            widget.bordDeta.scheduledDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.bordDeta.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(widget.bordDeta.comment),
                      const Spacer(),
                      Container(
                        height: 64,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: _videoOutput(),
                          builder: (context,snapshot){
                            List<Widget> children;
                            //データが入るまでは、ローディングを入れる為のif文
                            if (snapshot.hasData) {
                              children = <Widget>[
                                widget.bordDeta.likes.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: (snapshot.data as List).length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final list = snapshot.data as List;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 56,
                                          width: 56,
                                          child: InkWell(
                                            highlightColor: Colors.blue.withOpacity(1),
                                            splashColor: Colors.grey.withOpacity(0.7),
                                            onTap: (){
                                              //TODO: ikuyoボタンで表示されるアイコンをタップした際の挙動
                                              print(list);
                                            },
                                            child:ClipOval(
                                                child: CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                  imageUrl: list[index]
                                                ),
                                              )
                                          ),
                                        ),
                                      );
                                    },
                                )
                                :const Text("Ikuyoスタンプを押して参加しよう!")
                              ];
                            //snapshotにデータが格納されていなかった場合
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}',
                                      style: TextStyle(
                                        color: Colors.red,)),
                                )
                              ];
                            //ロード中
                            } else {
                              children = <Widget>[
                                const SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 60,
                                  height: 60,
                                ),
                              ];
                            }
                            return Row(
                                children: children,
                            );



                            // return widget.bordDeta.likes.length > 0
                            //   ? ListView.builder(
                            //       scrollDirection: Axis.horizontal,
                            //       // physics: const NeverScrollableScrollPhysics(),
                            //       shrinkWrap: true,
                            //       padding: EdgeInsets.zero,
                            //       itemCount: (snapshot.data as List).length,
                            //       itemBuilder: (BuildContext context, int index) {
                            //         final list = snapshot.data as List;
                            //         return Padding(
                            //           padding: const EdgeInsets.only(right: 8.0),
                            //           child: Container(
                            //             height: 56,
                            //             width: 56,
                            //             child: InkWell(
                            //               highlightColor: Colors.blue.withOpacity(1),
                            //               splashColor: Colors.grey.withOpacity(0.7),
                            //               onTap: (){
                            //                 //TODO: ikuyoボタンで表示されるアイコンをタップした際の挙動
                            //                 print(list);
                            //               },
                            //               child:ClipOval(
                            //                   child: CachedNetworkImage(
                            //                     height: 30,
                            //                     width: 30,
                            //                     fit: BoxFit.cover,
                            //                     imageUrl: list[index]
                            //                   ),
                            //                 )
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //   )
                            //   :const Text("Ikuyoスタンプを押して参加しよう!");
                          }
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: size.width - 70,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    highlightColor: Colors.blue.withOpacity(1),
                    splashColor: Colors.grey.withOpacity(0.7),
                    onTap: (){
                      IkuyoController().updatePostId(widget.bordDeta.id);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 56,
                        height: 56,
                        child: Image.asset('assets/icon/ikuyo-moji.png',fit: BoxFit.contain),
                      ), 
                    ),
                  ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}