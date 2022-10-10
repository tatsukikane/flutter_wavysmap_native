import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/auth_controller.dart';
import 'package:flutter_wavysmap_native/map/screens/restaurants_map.dart';
import 'package:flutter_wavysmap_native/views/screens/add_video_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/profile_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/search_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/video_screen.dart';

//ボトムバー用ページリスト(パッケージ利用)
// List<Widget> pages = <Widget>[
//   VideoScreen(),
//   RestaurantsMap(),
//   const AddVideoScreen(),
//   SearchScreen(),
//   ProfileScreen(uid: authController.user.uid),
// ];
//変更前 パッケージ使わない場合
List pages = [
  VideoScreen(),
  RestaurantsMap(),
  const AddVideoScreen(),
  SearchScreen(),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.blue.shade300;
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
