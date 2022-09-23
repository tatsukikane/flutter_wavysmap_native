// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'firebase_options.dart';
// import 'get_firestore/get_spot.dart';
// import 'ui/splash.dart';

// late SharedPreferences sharedPreferences;


// //stateを使うため
// final navigatorKey = GlobalKey<NavigatorState>();
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   sharedPreferences = await SharedPreferences.getInstance();
//   await dotenv.load(fileName: "assets/config/.env");
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mapbox Flutter',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(brightness: Brightness.light),
//       darkTheme: ThemeData(brightness: Brightness.dark),
//       themeMode: ThemeMode.dark,
//       home: const Splash(),
//     );
//   }
// }
