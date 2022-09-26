import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/board_search_controller.dart';
// import 'package:tiktok/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/models/board_model.dart';
import 'package:flutter_wavysmap_native/views/screens/board_%20detail_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/board_screen.dart';

import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/models/user.dart';
import 'package:flutter_wavysmap_native/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final BoardSearchController boardSearchController = Get.put(BoardSearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 5, 5, 226),
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'イベント・掲示板検索',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              icon: Icon(Icons.content_paste_search)
            ),
            onFieldSubmitted: (value) => boardSearchController.searchBoard(value),
          ),
        ),
        // body: BoardScreen(),
        body: boardSearchController.searchedBoards.isEmpty
            ? BoardScreen()
            : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  // itemCount: restaurants.length,
                  itemCount: boardSearchController.searchedBoards.length,
                  itemBuilder: (BuildContext context, int index) {
                    final board = boardSearchController.searchedBoards[index];
                    return InkWell(
                      onTap: (){
                        showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            // return Text(bordController.comments[index].id);
                            return Center(
                              child: Container(
                                height: 400,
                                child: BoardDetailScreen(bordDeta: boardSearchController.searchedBoards[index])
                              ),
                            );
                            // return bordController.comments[index]
                          // return video_dialog(videodeta: data);
                          }
                        );
                        print(boardSearchController.searchedBoards[index].id);
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              height: 175,
                              width: 140,
                              fit: BoxFit.cover,
                              // imageUrl: restaurants[index]['image'],
                              imageUrl: board.profilePhoto,
                            ),
                            Expanded(
                              child: Container(
                                height: 175,
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Text(
                                          board.username,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      // restaurants[index]['name'],
                                      board.comment,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    // Text(restaurants[index]['items']),
                                    // Text(products[index].caption),
                                    const Spacer(),
                                    Text(
                                      "ここにスタンプを表示させる"
                                    )
                                    // Row(
                                    //   children: [
                                    //     cardButtons(Icons.call, 'Call'),
                                    //     cardButtons(Icons.location_on, 'Map'),
                                    //     const Spacer(),
                                    //     // Text('${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km'),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
            )
      );
    });
  }
}
