import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';

import '../constants/restaurants.dart';

//ローカルJsondata使用
// LatLng getLatLngFromRestaurantData(int index) {
//   return LatLng(double.parse(restaurants[index]['coordinates']['latitude']),
//       double.parse(restaurants[index]['coordinates']['longitude']));
// }
//firestoreデータ
LatLng getLatLngFromRestaurantData(int index) {
  return LatLng(products[index].latitude,
      products[index].longitude);
}
