import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/controllers/auth_controller.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:flutter_wavysmap_native/models/pin.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

List<PinModel> products = [];

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
//アニメーション用
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    //アニメーション用
    _controller = AnimationController(vsync: this);
    get();
    initializeLocationAndSave();
  }

  //ユーザーブロック機能 ユーザーデフォルト
  final String? blockedUser = sharedPreferences.getString('blockedUser');

  Future get() async {
    //TODO: ユーザーブロック機能 Mapフィルタリング
    if (blockedUser != null) {
      var collection = await FirebaseFirestore.instance
          .collection('pins')
          .where('uid', isNotEqualTo: blockedUser)
          .get();
      products = collection.docs
          .map((doc) => PinModel(
                doc['username'],
                doc['uid'],
                doc['id'],
                doc['videoId'],
                doc['spotName'],
                doc['caption'],
                doc['videoUrl'],
                doc['thumbnail'],
                doc['latitude'],
                doc['longitude'],
              ))
          .toList();
    } else {
      var collection =
          await FirebaseFirestore.instance.collection('pins').get();
      products = collection.docs
          .map((doc) => PinModel(
                doc['username'],
                doc['uid'],
                doc['id'],
                doc['videoId'],
                doc['spotName'],
                doc['caption'],
                doc['videoUrl'],
                doc['thumbnail'],
                doc['latitude'],
                doc['longitude'],
              ))
          .toList();
    }
  }

  //位置情報の許可がされなかった際の初期値
  Future<Position> getLocation() async {
    return Position.fromMap(<String, double>{
      'latitude': 35.65980096106451,
      'longitude': 139.70081144278382,
    });
  }

  void initializeLocationAndSave() async {
    //初期位置情報
    Position _locationData = await getLocation();

    //現在位置の許可と取得
    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return _locationData;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return _locationData = await Geolocator.getCurrentPosition();
    }

    await _determinePosition();
    print(_locationData);

//location.dartバージョン----------------------------
    //位置情報の許可がされなかった際の初期値
    // Future<LocationData> getLocation() async {
    //   return LocationData.fromMap(<String, double>{
    //     'latitude': 35.65980096106451,
    //     'longitude': 139.70081144278382,
    //   });
    // }

    // void initializeLocationAndSave() async {
    //   // Ensure all permissions are collected for Locations
    //   Location _location = Location();
    //   bool? _serviceEnabled;
    //   PermissionStatus? _permissionGranted;
    //   //初期位置情報
    //   LocationData _locationData = await getLocation();

    //   _serviceEnabled = await _location.serviceEnabled();
    //   if (!_serviceEnabled) {
    //     _serviceEnabled = await _location.requestService();
    //   }

    //   _permissionGranted = await _location.hasPermission();
    //   if (_permissionGranted == PermissionStatus.denied) {
    //     _permissionGranted = await _location.requestPermission();
    //   }

    //   // ユーザーの現在地を取得
    //   if(_serviceEnabled && _permissionGranted == PermissionStatus.granted){
    //     _locationData = await _location.getLocation();
    //   }

//---------------------------------------

    print("ここ${_locationData}");
    LatLng currentLatLng =
        LatLng(_locationData.latitude, _locationData.longitude);

    // sharedPreferencesにユーザーロケーションを格納
    sharedPreferences.setDouble('latitude', _locationData.latitude);
    sharedPreferences.setDouble('longitude', _locationData.longitude);

    // Get and store the directions API response in sharedPreferences

    // for (int i = 0; i < restaurants.length; i++) {
    // for (int i = 0; i < products.length; i++) {
    //   //リスト内要素をAPIに渡す
    //   Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
    //   saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    // }

    Firebase.initializeApp().then((value) {
      Get.put(AuthController());
    });

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            'assets/46833-looping-energy-orb.json',
          ),
        ),
        Material(
          color: const Color.fromARGB(137, 49, 48, 48),
          child: Center(child: Image.asset('assets/image/logo3.png')),
        ),
      ],
    );
  }
}
