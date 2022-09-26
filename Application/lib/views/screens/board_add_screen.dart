//掲示板投稿用
//TODO: 写真、コメント、緯度軽度を入れられる様にする。

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_wavysmap_native/controllers/board_controller.dart';
import 'package:get/get.dart';

class BoardAddScreen extends StatefulWidget {
  BoardAddScreen({super.key});

  @override
  State<BoardAddScreen> createState() => _BoardAddScreenState();
}

class _BoardAddScreenState extends State<BoardAddScreen> {
  final TextEditingController _boardAddController = TextEditingController();
  BoardController bordController = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
        title: TextFormField(
          controller: _boardAddController,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            labelText: 'Comment',
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
        trailing: TextButton(
          onPressed: () =>
              bordController.postComment(_boardAddController.text),
          child: const Text(
            'Send',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}