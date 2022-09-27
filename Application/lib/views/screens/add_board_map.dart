import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_wavysmap_native/map/helpers/shared_prefs.dart';


class AddBoardMap extends StatefulWidget {
  AddBoardMap({Key? key}) : super(key: key);
  final Completer<MapboxMapController> _controller = Completer();


  @override
  State<AddBoardMap> createState() => _AddBoardMap();
}

  // マーク（ピン）を立てて時刻（hh:mm）のラベルを付ける

class _AddBoardMap extends State<AddBoardMap> {
  LatLng latlng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kRestaurantsList;

  final Completer<MapboxMapController> _controller = Completer();

  var symbol;
  var selectedLatlng;

  //タップ位置にマーカーを表示
  void _addMark(LatLng tapPoint) async {
    if(symbol != null){
      controller.removeSymbol(symbol);
    }
    symbol = await  controller.addSymbol(SymbolOptions(
      geometry: tapPoint,
      iconSize: 0.5,
      //アイコン変更
      iconImage: "assets/icon/ufo.png",
    ));
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latlng, zoom: 15);
  }

  _onMapCreated(MapboxMapController controller) async {
    _controller.complete(controller);
    this.controller = controller;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Restaurants Map'),
      // ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              // onSymbolTapped: _onSymbolTap,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(10, 17), //mapのzoom範囲
              //スタイルの変更
              styleString: "mapbox://styles/tatsukikane/cl7fymo0l000n15pkggakbwf4",
              onMapClick: (point, coordinates) {
                //TODO: tapした位置のlatlng取得
                setState(() {
                  selectedLatlng = coordinates;
                  _addMark(coordinates);
                });
              },
            ),
          ),
          //位置情報選択完了ボタン
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 56,
                  width: 78,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(selectedLatlng);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "選択",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 3,
                      ),
                    )
                  ),
                ),
                SizedBox(height: 51,)

              ],
            ),
          )
        ],
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

