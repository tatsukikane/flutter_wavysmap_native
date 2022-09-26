import 'package:flutter/material.dart';
// import 'package:tiktok/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/controllers/search_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/board_screen.dart';

import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/models/user.dart';
import 'package:flutter_wavysmap_native/views/screens/profile_screen.dart';

class UserSearchScreen extends StatelessWidget {
  UserSearchScreen({Key? key}) : super(key: key);

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
              hintText: 'ユーザー検索',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              icon: Icon(Icons.person_search)
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        body: searchController.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  'Search for users!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
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
