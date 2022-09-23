import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wavysmap_native/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_wavysmap_native/map/constants/restaurants.dart';
import 'package:flutter_wavysmap_native/map/helpers/commons.dart';
import 'package:flutter_wavysmap_native/map/helpers/shared_prefs.dart';
import 'package:flutter_wavysmap_native/map/main.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';
import 'package:flutter_wavysmap_native/map/widgets/carousel_card.dart';

//MapPinID管理リスト
List mapPinIdList = [];
//カルーセルコントローラー（pinタップ時にカルーセルを操作）
CarouselController buttonCarouselController = CarouselController();

class RestaurantsMap extends StatefulWidget {
  const RestaurantsMap({Key? key}) : super(key: key);

  @override
  State<RestaurantsMap> createState() => _RestaurantsMapState();
}

class _RestaurantsMapState extends State<RestaurantsMap> {
  // Mapbox related
  LatLng latlng = getLatLngFromSharedPrefs();
  //カメラポジション初期値
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kRestaurantsList;

  List<Map> carouselData = [];

  // Carousel related
  int pageIndex = 0;
  late List<Widget> carouselItems;

  //futureを作る為のやつ [Pin]
  final Completer<MapboxMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
    //デフォルトのzoomレベル
    _initialCameraPosition = CameraPosition(target: latlng, zoom: 15);

    // SharedPreferencesのデータから距離と時間を計算products
    // for(int index =0; index < restaurants.length; index++){
    for(int index =0; index < products.length; index++){
      num distance = getDistanceFromSharedPrefs(index)/1000;
      num duration = getDurationFromSharedPrefs(index)/60;
      carouselData.add({'index': index, 'distance': distance, 'duration': duration});
      print(carouselData);
    }
    //並び替え
    carouselData.sort((a,b)=>a['duration']<b['duration'] ? 0 : 1);

    // カルーセルウィジェットの一覧を生成
    carouselItems = List<Widget>.generate(
      // restaurants.length,
      products.length,
      (index) => carouselCard(carouselData[index]['index'], 
        carouselData[index]['distance'], carouselData[index]['duration'])
    );

    // initialize map symbols in the same order as carousel widgets
    _kRestaurantsList = List<CameraPosition>.generate(
      // restaurants.length,
      products.length,
      (index) => CameraPosition(
        target: getLatLngFromRestaurantData(carouselData[index]['index']),
        zoom: 15 //zoom初期値
      )
    );

  }

  _addSourceAndLineLayer(int index) async {
    // print(index);
    // 選択されたカルーセルの位置にカメラポジションを移動
    controller.animateCamera(CameraUpdate.newCameraPosition(_kRestaurantsList[index]));
    

    // 送信元と送信先の間にポリラインを追加する
    // Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    // final fills = {
    //   "type": "FeatureCollection",
    //   "features": [
    //     {
    //       "type": "Feature",
    //       "id": 0,
    //       "properties": <String, dynamic>{},
    //       "geometry": geometry,
    //     },
    //   ]
    // };

    // lineLayerとsourceが存在する場合は削除する。
    // if(removeLayer == true){
    //   await controller.removeLayer("lines");
    //   await controller.removeSource("fills");
    // }

    // 新しいソースとlineLayerを追加する
    // await controller.addSource("fills", GeojsonSourceProperties(data: fills));
    // await controller.addLineLayer("fills", "lines", LineLayerProperties(
    //   lineColor: Colors.green.toHexStringRGB(),
    //   lineCap: "round",
    //   lineJoin: "round",
    //   lineWidth: 2,
    // ));
  }

  _onMapCreated(MapboxMapController controller) async {
    _controller.complete(controller);
    _controller.future.then((mapboxMap) {
      mapboxMap.onSymbolTapped.add(_onSymbolTap);
    });
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for(CameraPosition _kRestaurant in _kRestaurantsList){
      var pin = await controller.addSymbol(SymbolOptions(
        geometry: _kRestaurant.target,
        iconSize: 0.2,
        //アイコン変更
        iconImage: "assets/icon/skate-park2.png",
      ));
      //生成したMapPinのIDを配列に追加
      mapPinIdList.add(pin.id);
      print(pin.id);
    }
    print('リスト$mapPinIdList');
    _addSourceAndLineLayer(0);

  }

  //マークをタップしたときに Symbol の情報を表示する
  void _onSymbolTap(Symbol symbol) {
    _dispSymbolInfo(symbol);
  }

  // Map上のpinを押した時の挙動
  //TODO: Tap時に動画or掲示板を表示させる
  void _dispSymbolInfo(Symbol symbol) {
    //タップされたPinのID
    var pinid = symbol.id;
    //mapPinIdList内のPinidと一致するインデックス番号を取得
    int pinindex = mapPinIdList.indexOf(pinid);
    //pinindexにあたるカルーセルへ移動
    setState(() {
      buttonCarouselController.jumpToPage(pinindex);
    });
    
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Symbol ID : ${symbol.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants Map'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: MapboxMap(
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                // onSymbolTapped: _onSymbolTap,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(10, 17), //mapのzoom範囲
                //スタイルの変更
                styleString: "mapbox://styles/tatsukikane/cl7fymo0l000n15pkggakbwf4",
              ),
            ),
            CarouselSlider(
              items: carouselItems,
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false, //無限スクロール
                scrollDirection: Axis.horizontal, //スクロール方向
                onPageChanged: (int index, CarouselPageChangedReason reason){
                  setState(() {
                    //ページの切り替え
                    pageIndex = index;
                  });
                  _addSourceAndLineLayer(index);
                }
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //現在位置に移動
          controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

