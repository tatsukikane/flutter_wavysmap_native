import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wavysmap_native/models/board_model.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/models/user.dart';

class BoardSearchController extends GetxController {
  final Rx<List<Board>> _searchedBoards = Rx<List<Board>>([]);

  List<Board> get searchedBoards => _searchedBoards.value;

  searchBoard(String typedUser) async {
    _searchedBoards.bindStream(firestore
        .collection('board')
        .where('comment', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Board> retVal = [];
      for (var elem in query.docs) {
        retVal.add(Board.fromSnap(elem));
      }
      return retVal;
    }));
  }
}