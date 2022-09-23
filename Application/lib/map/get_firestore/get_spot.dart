// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mapbox_navigation/get_firestore/spot_model.dart';


// class getspot extends StatefulWidget {
//   const getspot({Key? key}) : super(key: key);

//   @override
//   State<getspot> createState() => _getspotState();
// }

// class _getspotState extends State<getspot> {
//   @override
//   void initState() {
//     super.initState();
//     ///Firestoreからデータを取得する場合
//     get();
//   }
//   List<SpotModel> products = [];

//   Future get() async{
//     var collection = await FirebaseFirestore.instance.collection('spots').get();
//     products = collection.docs.map((doc) => SpotModel(
//             doc['id'],
//             doc['name'],
//             doc['items'],
//             doc['image'],
//             doc['coordinates']
//         )).toList();
//         this.products = products;

//         print(this.products);
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("test"),
//     );
//   }








// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class ProductListModel extends ChangeNotifier {
//   List<SpotModel> products = [];

//   Future getProducts() async {
//     var collection = await FirebaseFirestore.instance.collection('spots').get();
//     products = collection.docs
//         .map((doc) => SpotModel(
//             doc['id'],
//             doc['name'],
//             doc['items'],
//             doc['image'],
//             doc['coordinates']
//         ))
//         .toList();
//     this.products = products;
//     notifyListeners();
//     print(products);
//   }
// }