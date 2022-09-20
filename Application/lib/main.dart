import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/controllers/auth_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/signup_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });

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
      home: LoginScreen(),
    );
  }
}


// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_wavysmap_native/realtime_database/realtime_database_page.dart';
// import 'package:flutter_wavysmap_native/register/register_page.dart';
// import 'package:flutter_wavysmap_native/video_editor/video_editor.dart';
// import 'package:flutter_wavysmap_native/video_upload/video_upload.dart';
// import 'auth/auth_page.dart';
// import 'firebase_options.dart';
// import 'firestore/firestore_page.dart';
// import 'login/login_page.dart';
// import 'mypage/my_page.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//     const ProviderScope(child: MyApp()),
//   );
// }

// /// Providerの初期化 デモ
// // final counterProvider = StateNotifierProvider.autoDispose<Counter, int>((ref) {
// //   return Counter();
// // });

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//       debugShowCheckedModeBanner: false, //debug非表示
//     );
//   }
// }

// class MyHomePage extends ConsumerWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref){
//     //ユーザー情報の取得
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if(user == null) {
//         ref.watch(userEmailProvider.state).state = 'ログインしていません';
//       } else {
//         ref.watch(userEmailProvider.state).state = user.email!;
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Homepage'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(10),
//         children: <Widget>[
//           //ユーザー情報の表示
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.person),
//               Text(ref.watch(userEmailProvider)),
//             ],
//           ),

//           /// ページ遷移
//           // const _PagePushButton(
//           //   buttonTitle: '認証ページ',
//           //   pagename: AuthPage(),
//           // ),
//           const _PagePushButton(
//             buttonTitle: 'firestoreページ',
//             pagename: FirestorePage(),
//           ),
//           const _PagePushButton(
//             buttonTitle: 'realtimedetabaseページ',
//             pagename: RealtimeDatabasePage(),
//           ),
//           const _PagePushButton(
//             buttonTitle: 'videoUpLoadページ',
//             pagename: VideoUploadPage(),
//           ),
//           const _PagePushButton(
//             buttonTitle: 'VideoEditorページ',
//             pagename: VideoEditor_app(),
//           ),
//           _PagePushButton(
//             buttonTitle: '新規登録ページ',
//             pagename: RegisterPage(),
//           ),
//           _PagePushButton(
//             buttonTitle: 'ログインページ',
//             pagename: LoginPage(),
//           ),
//           _PagePushButton(
//             buttonTitle: 'Mypage',
//             pagename: MyPage(),
//           ),

//         ],
//       ),
//     );
//   }
// }

// /// ページ遷移のボタン
// class _PagePushButton extends StatelessWidget {
//   const _PagePushButton({
//     Key? key,
//     required this.buttonTitle,
//     required this.pagename,
//   }) : super(key: key);

//   final String buttonTitle;
//   final dynamic pagename;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         child: Text(buttonTitle),
//       ),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => pagename),
//         );
//       },
//     );
//   }
// }
