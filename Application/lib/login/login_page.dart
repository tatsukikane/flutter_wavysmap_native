import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_wavysmap_native/mypage/my_page.dart';
import 'package:provider/provider.dart';

import '../register/register_page.dart';
import 'login_model.dart';



class LoginPage extends StatelessWidget {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _images = _firestore.collection('images');
  final Stream<QuerySnapshot> _imagesStream = _images.snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log in',
          ),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (text) {
                      model.setEmail(text);
                    },
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                
                  TextField(
                    controller: model.subtitleController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    onChanged: (text) {
                      model.setPassword(text);
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      model.startLoading();

                      //追加の処理
                      try{
                          await model.login();
                          // Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyPage()),
                          );
                        } catch(err) {
                          //エラーの出力
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(err.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } finally {
                          model.endLoading();
                        }
                    },
                  child: Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 24,
                      
                    ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //画面遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                          fullscreenDialog: true,
                          ),
                      );
                  },
                  child: Text('新規登録の方はこちら'),
                  ),




                          ],
                        ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )



              ],
            );
      }),
    ),
    
      ),
    );
  }
}