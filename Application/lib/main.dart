import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

//map用
late SharedPreferences sharedPreferences;
//stateを使うため
final navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   sharedPreferences = await SharedPreferences.getInstance();
//   await dotenv.load(fileName: "assets/config/.env");
//   // Firebase.initializeApp().then((value) {
//     // Get.put(AuthController());
//   // });
//     await FirebaseAnalytics.instance.logEvent(
//     name: 'MyApp',
//   );
//     runApp(
//     const ProviderScope(child: MyApp()),
//   );
// }

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    sharedPreferences = await SharedPreferences.getInstance();
    await dotenv.load(fileName: "assets/config/.env");
    await FirebaseAnalytics.instance.logEvent(
      name: 'MyApp',
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(
      const ProviderScope(child: MyApp()),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      // home: LoginScreen(),
      home: const Splash(),
    );
  }
}