//単体動画再生テスト OK

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_wavysmap_native/views/widgets/video_player_item.dart';



// class test extends StatelessWidget {
//   const test({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         VideoPlayerItem(
//           videoUrl: data.videoUrl,
//         ),
//         Column(
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.only(
//                         left: 20,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment:
//                             MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             data.username,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             data.caption,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.music_note,
//                                 size: 15,
//                                 color: Colors.white,
//                               ),
//                               Text(
//                                 data.songName,
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 100,
//                     margin: EdgeInsets.only(top: size.height / 5),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         buildProfile(
//                           data.profilePhoto,
//                         ),
//                         Column(
//                           children: [
//                             InkWell(
//                               onTap: () =>
//                                   videoController.likeVideo(data.id),
//                               child: Icon(
//                                 Icons.favorite,
//                                 size: 40,
//                                 color: data.likes.contains(
//                                         authController.user.uid)
//                                     ? Colors.red
//                                     : Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Text(
//                               data.likes.length.toString(),
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             InkWell(
//                               onTap: () => Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => CommentScreen(
//                                     id: data.id,
//                                   ),
//                                 ),
//                               ),
//                               child: const Icon(
//                                 Icons.comment,
//                                 size: 40,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Text(
//                               data.commentCount.toString(),
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             InkWell(
//                               onTap: () {},
//                               child: const Icon(
//                                 Icons.reply,
//                                 size: 40,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Text(
//                               data.shareCount.toString(),
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                         CircleAnimation(
//                           child: buildMusicAlbum(data.profilePhoto),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



//いいねとか無しバージョン
// class test extends StatelessWidget {
//   const test({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//               children: [
//                 VideoPlayerItem(
//                   //再生したい動画URL
//                   videoUrl: 'https://firebasestorage.googleapis.com/v0/b/functions-test-post/o/videos%2FVideo%200?alt=media&token=1a5ba16f-ad1b-4307-8a5f-604538ebfa09',
//                 ),
//                 Column(
//                   children: [
//                     const SizedBox(
//                       height: 100,
//                     ),
//                     Expanded(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.only(
//                                 left: 20,
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Text(
//                                     "テスト",
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "テスト",
//                                     style: const TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.music_note,
//                                         size: 15,
//                                         color: Colors.white,
//                                       ),
//                                       Text(
//                                         "テスト",
//                                         style: const TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }
//       }