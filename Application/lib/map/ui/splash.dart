import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/auth_controller.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_wavysmap_native/map/constants/restaurants.dart';
import 'package:flutter_wavysmap_native/map/get_firestore/spot_model.dart';
import 'package:flutter_wavysmap_native/map/main.dart';

import '../helpers/directions_handler.dart';
import '../screens/home_management.dart';

List<SpotModel> products = [];

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    get();
    initializeLocationAndSave();
  }

  Future get() async{
    var collection = await FirebaseFirestore.instance.collection('spots').get();
    products = collection.docs.map((doc) => SpotModel(
            doc['id'],
            doc['name'],
            doc['items'],
            doc['image'],
            doc['latitude'],
            doc['longitude'],
        )).toList();
        print("ここやで");
        // print(products[0].);
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // ユーザーの現在地を取得する
    LocationData _locationData = await _location.getLocation();
    LatLng currentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);

    // Get and store the directions API response in sharedPreferences



    // for (int i = 0; i < restaurants.length; i++) {
    for (int i = 0; i < products.length; i++) {
      //リスト内要素をAPIに渡す
      Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }

    Firebase.initializeApp().then((value) {
      Get.put(AuthController());
    });

    Navigator.pushAndRemoveUntil(
        context,
        // MaterialPageRoute(builder: (_) => const HomeManagement()),
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(child: Image.asset('assets/image/splash.png')),
    );
  }
}
