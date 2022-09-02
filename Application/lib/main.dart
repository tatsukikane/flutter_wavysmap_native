import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_wavysmap_native/video_editor/video_editor.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const VideoEditor_app(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //firestore用
  final db = FirebaseFirestore.instance;

  //firestore内のデータを取得し、デコードする関数
  void getstore() async{
    // print("ここ");
    await db.collection("messages").doc("LnejSZiJx86FaYQEQwMk").get().then((event) {
      //firestoreのkey:value型のデータ
      var result = event.data();
      //valueのみを抽出
      var value = result!['original'];
      //valueをMAPとして使えるようデコード
      var valueMap = jsonDecode(value);
      //対象のデータを取得できることを確認
      print("ここ");
      print(valueMap['shotLabelAnnotations'][0]['segments'][0]['segment']['endTimeOffset']['seconds']);
    });
}


@override
  void initState() {
    // TODO: implement initState
    getstore();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'yobidasi',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}