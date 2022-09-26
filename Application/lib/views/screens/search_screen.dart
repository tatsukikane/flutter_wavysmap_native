import 'package:flutter/material.dart';
// import 'package:tiktok/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/board_screen.dart';

import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/models/user.dart';
import 'package:flutter_wavysmap_native/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

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
            //TODO:掲示板検索に変える
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        // body: BoardScreen(),
        body: searchController.searchedUsers.isEmpty
            ? BoardScreen()
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = searchController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
