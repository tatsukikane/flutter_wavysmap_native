import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/board_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/board_%20detail_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:timeago/timeago.dart' as tago;

//掲示板
class BoardScreen extends StatelessWidget {
  // final String id;
  BoardScreen({
    Key? key,
    // required this.id,
  }) : super(key: key);

  final TextEditingController _bordController = TextEditingController();
  BoardController bordController = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // bordController.updatePostId(id);
    bordController.getComment();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: size.width,
            height: size.height - 176,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                return ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  // itemCount: restaurants.length,
                  itemCount: bordController.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment = bordController.comments[index];
                    return InkWell(
                      onTap: (){
                        showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            //TODO:ここにboard_detail_screen.dartをここで返す
                            // return Text(bordController.comments[index].id);
                            return Center(
                              child: Container(
                                height: 400,
                                child: BoardDetailScreen(bordDeta: bordController.comments[index])
                              ),
                            );
                            // return bordController.comments[index]
                          // return video_dialog(videodeta: data);
                          }
                        );
                        print(bordController.comments[index].id);
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
                              imageUrl: comment.boardPicture,
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
                                        Icon(Icons.today),
                                        Text(
                                          comment.scheduledDate
                                        ),
                                      ],

                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Text(
                                          comment.username,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      // restaurants[index]['name'],
                                      comment.comment,
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
                );
                  }),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_wavysmap_native/map/constants/restaurants.dart';
// import 'package:flutter_wavysmap_native/map/ui/splash.dart';

// import '../helpers/shared_prefs.dart';

// class RestaurantsTable extends StatefulWidget {
//   const RestaurantsTable({Key? key}) : super(key: key);

//   @override
//   State<RestaurantsTable> createState() => _RestaurantsTableState();
// }

// class _RestaurantsTableState extends State<RestaurantsTable> {
//   /// Add handlers to buttons later on
//   /// For call and maps we can use url_launcher package.
//   /// We can also create a turn-by-turn navigation for a particular restaurant.
//   /// 🔥 Let's look at it in the next video!!

//   Widget cardButtons(IconData iconData, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(5),
//           minimumSize: Size.zero,
//         ),
//         child: Row(
//           children: [
//             Icon(iconData, size: 16),
//             const SizedBox(width: 2),
//             Text(label)
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Restaurants Table'),
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         physics: const ScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CupertinoTextField(
//                 prefix: Padding(
//                   padding: EdgeInsets.only(left: 15),
//                   child: Icon(Icons.search),
//                 ),
//                 padding: EdgeInsets.all(15),
//                 placeholder: 'Search dish or restaurant name',
//                 style: TextStyle(color: Colors.white),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 // itemCount: restaurants.length,
//                 itemCount: products.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     clipBehavior: Clip.antiAlias,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CachedNetworkImage(
//                           height: 175,
//                           width: 140,
//                           fit: BoxFit.cover,
//                           // imageUrl: restaurants[index]['image'],
//                           imageUrl: products[index].thumbnail,
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 175,
//                             padding: const EdgeInsets.all(15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   // restaurants[index]['name'],
//                                   products[index].spotName,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 // Text(restaurants[index]['items']),
//                                 Text(products[index].caption),
//                                 const Spacer(),
//                                 const Text('Waiting time: 2hrs'),
//                                 Text(
//                                   'Closes at 10PM',
//                                   style:
//                                       TextStyle(color: Colors.redAccent[100]),
//                                 ),
//                                 Row(
//                                   children: [
//                                     cardButtons(Icons.call, 'Call'),
//                                     cardButtons(Icons.location_on, 'Map'),
//                                     const Spacer(),
//                                     Text('${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km'),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
