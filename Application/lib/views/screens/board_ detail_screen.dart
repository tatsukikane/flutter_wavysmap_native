//掲示板の詳細
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_wavysmap_native/controllers/ikuyo_controller.dart';
import 'package:get/get.dart';

import '../../controllers/board_controller.dart';

class BoardDetailScreen extends StatefulWidget {
  final bordDeta;
  BoardDetailScreen({super.key, required this.bordDeta});
  
  //コントローラー
  // IkuyoController ikuyoController = Get.put(IkuyoController());

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}



class _BoardDetailScreenState extends State<BoardDetailScreen> {
  IkuyoController ikuyoController = Get.put(IkuyoController());
  // BoardController bordController = Get.find();
  // geturl() async{
  //   // print(ikuyoController.getPlofImage(widget.bordDeta.uid).toString());
  //   final test = await ikuyoController.getPlofImage(widget.bordDeta.uid).toString() as String;
  //   print('ここ$test');
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   geturl();
  // }
  //futurebuilder用関数
  Future _videoOutput() async {
    //TODO: 引数が違う？？
    var url = await ikuyoController.getPlofImage(widget.bordDeta.uid);
    // print(url);
    // return await ikuyoController.getPlofImage(widget.bordDeta.uid) as String;
    return await url;
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
          CachedNetworkImage(
            height: size.height / 5,
            width: size.width,
            fit: BoxFit.cover,
            // imageUrl: restaurants[index]['image'],
            imageUrl: widget.bordDeta.boardPicture,
          ),
              Expanded(
                child: Stack(
                  children:[ 
                    Container(
                      height: 175,
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
                            // restaurants[index]['name'],
                            widget.bordDeta.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          // Text(restaurants[index]['items']),
                          Text(widget.bordDeta.comment),
                          const Spacer(),
                          // widget.bordDeta.likes.length > 0
                          // ?Text(comment.likes[0])
                          //TODO: 
                          FutureBuilder (
                            future: _videoOutput(),
                            builder: (context,snapshot){
                              print(snapshot);
                              if (snapshot.hasData) {
                                return widget.bordDeta.likes.length > 0
                                ?
                                CachedNetworkImage(
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data as String
                                )
                                :Text("Ikuyoスタンプを押して参加しよう!");
                                } else {
                                  return Text("データが存在しません");
                                }
                              }
                            )
                          // ?CachedNetworkImage(
                          //   height: 30,
                          //   width: 30,
                          //   fit: BoxFit.cover,
                          //   // imageUrl: restaurants[index]['image'],
                          //   imageUrl: ikuyoController.getPlofImage(widget.bordDeta.uid) as String,
                          // )
                          // :Text("スタンプ"),
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
                          IkuyoController().getStampList(widget.bordDeta.id);
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
              //いくよボタン
              // Positioned(
              //   top: 10.0,
              //   left: size.width - 70,
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(16),
              //     highlightColor: Colors.blue.withOpacity(1),
              //     splashColor: Colors.grey.withOpacity(0.7),
              //     onTap: (){
              //       IkuyoController().updatePostId(widget.bordDeta.id).
              //       print("aaaaaa");
              //     },
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       child: Container(
              //         width: 56,
              //         height: 56,
              //         child: Image.asset('assets/icon/ikuyo-moji.png',fit: BoxFit.contain),
              //       ), 
              //     ),
              //   ),
              // ),
          //   ]
          // )
        ],
      ),
    );
  }
}