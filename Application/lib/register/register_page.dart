import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_wavysmap_native/mypage/my_page.dart';
import 'package:flutter_wavysmap_native/register/register_model.dart';
import 'package:provider/provider.dart';



class RegisterPage extends StatelessWidget {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _images = _firestore.collection('images');
  final Stream<QuerySnapshot> _imagesStream = _images.snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign up',
          ),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [

                  //name入力
                  TextField(
                    controller: model.nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  //email入力
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
                  //password入力
                  TextField(
                    controller: model.subtitleController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    onChanged: (text) {
                      model.setPassword(text);
                    },
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  //自己紹介入力
                  TextField(
                    controller: model.descriptionController,
                    decoration: InputDecoration(
                      hintText: '自己紹介',
                    ),
                    onChanged: (text) {
                      model.setDescription(text);
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      model.startLoading();
                    //追加の処理
                    try{
                      await model.singup();
                      // Navigator.of(context).pop();
                      //登録完了後画面遷移
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
                    } finally{
                      model.endLoading();
                    }
                  },
                  child: Text(
                    '登録する',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),

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

