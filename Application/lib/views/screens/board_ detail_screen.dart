//掲示板の詳細
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controllers/board_controller.dart';

class BoardDetailScreen extends StatefulWidget {
  final bordDeta;
  const BoardDetailScreen({super.key, required this.bordDeta});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  // BoardController bordController = Get.find();
  @override
  Widget build(BuildContext context) {
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
            imageUrl: widget.bordDeta.profilePhoto,
          ),
          Expanded(
            child: Container(
              height: 175,
              width: size.width,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const Text('スタンプ表示'),
                  // Text(
                  //   'Closes at 10PM',
                  //   style:
                  //       TextStyle(color: Colors.redAccent[100]),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}