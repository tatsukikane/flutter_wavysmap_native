import 'package:cloud_firestore/cloud_firestore.dart';
import '../edit_profile/edit_profile_page.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'my_model.dart';



class MyPage extends StatelessWidget {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _images = _firestore.collection('users');
  final Stream<QuerySnapshot> _imagesStream = _images.snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Text(
            'MyPage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
          ),

          actions: [
           Consumer<MyModel>(builder: (context, model, child){
                return IconButton(onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(model.name!, model.description!),
                      ),
                    );
                    model.fetchUser();
                },
                icon: Icon(
                  Icons.edit,
                  color:Colors.black
                ));
              }
            ),
          ],
        ),
        body: Center(
          child: Consumer<MyModel>(builder: (context, model, child){
            return Stack(
              children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: 240,
                        height: 240,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        // height: 300,
                        //プロフィール画像表示
                        child: model.imagefile != null
                      ? Image.network(model.imagefile!)
                      : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                image: AssetImage('assets/icon.jpeg'),
                              ),
                            ),
                        ),
                      ),
                      Text(
                        model.name ?? 'anonymous',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor: Colors.lightGreen,
                          decorationStyle: TextDecorationStyle.double,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,

                      ),  
                      Text(
                        model.email ?? 'メールアドレスなし',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        model.description ??'.......',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(onPressed: () async{
                        //ログアウト
                        await model.logout();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MyHomePage()),
                        // );
                      },
                      child: Text(
                        'ログアウト',
                        style: TextStyle(fontSize: 16),
                       ),
                      )
                    ],
                ),
                  ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
      }),
    ),
    
      ),
    );
  }
}
