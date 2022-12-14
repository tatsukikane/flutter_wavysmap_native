import 'package:flutter_wavysmap_native/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_wavysmap_native/map/main.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';

import '../constants/restaurants.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
  //getCyclingRouteUsingMapboxで並び替えてる
  final response = await getCyclingRouteUsingMapbox(
      currentLatLng,
      //ローカルJsondata使用
      // LatLng(double.parse(restaurants[index]['coordinates']['latitude']),
      //     double.parse(restaurants[index]['coordinates']['longitude'])));
      LatLng(products[index].latitude,products[index].longitude));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  // print('-------------------${restaurants[index]['name']}-------------------');
  print('-------------------${products[index].spotName}-------------------');

  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

//保存と共有
void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('restaurant--$index', response);
}
