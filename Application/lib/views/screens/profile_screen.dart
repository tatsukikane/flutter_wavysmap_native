import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/controllers/profile_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/delete_account_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/profile_video_dialog.dart';
import 'package:flutter_wavysmap_native/views/user_search_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (authController.user.isAnonymous) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/alien2.png'),
                  const Text(
                    "アカウント登録が必要です。",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height:24),
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
        } else if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator()
            );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserSearchScreen(),
                  ),
                );
              },
            ),
            actions: [
              InkWell(
                child: const Icon(Icons.more_horiz),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DeleteAccountScreen(uid: authController.user.uid),
                    ),
                  );
                },
              ),
            ],
            title: Text(
              controller.user['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.user['profilePhoto'],
                                height: 100,
                                width: 100,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  controller.user['following'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user['followers'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black54,
                              width: 1,
                              height: 15,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.user['likes'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 140,
                          height: 47,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                if (widget.uid == authController.user.uid) {
                                  authController.signOut();
                                } else {
                                  controller.followUser();
                                }
                              },
                              child: Text(
                                widget.uid == authController.user.uid
                                    ? 'Sign Out'
                                    : controller.user['isFollowing']
                                        ? 'Unfollow'
                                        : 'Follow',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.user['thumbnails'].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            String thumbnail =
                                controller.user['thumbnails'][index];
                            return InkWell(
                              onTap: ()async{
                                final videoCollection = await controller.getVideo(thumbnail);
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return profile_video_dialog(videodeta: videoCollection);
                                  }
                                );
                                print(videoCollection["videoUrl"]);
                              },
                              child: CachedNetworkImage(
                                imageUrl: thumbnail,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
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
    );
  }
}
