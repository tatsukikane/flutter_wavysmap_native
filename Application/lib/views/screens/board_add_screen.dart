//掲示板投稿用
//TODO: 写真、コメント、緯度軽度を入れられる様にする。

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_wavysmap_native/controllers/board_controller.dart';
import 'package:flutter_wavysmap_native/views/screens/add_board_map.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class BoardAddScreen extends StatefulWidget {
  BoardAddScreen({super.key});

  @override
  State<BoardAddScreen> createState() => _BoardAddScreenState();
}

class _BoardAddScreenState extends State<BoardAddScreen> {
  final TextEditingController _boardAddController = TextEditingController();
  BoardController bordController = Get.put(BoardController());
  var targetday;
  var viewday = "予定日を選択";
  dynamic pickedImage = AssetImage("assets/image/city_landscape.jpeg");
  var selectedLatlng ;
  var filepath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                    SizedBox(
                        height: 480,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: pickedImage
                                )
                            ),
                        )),
                      // const CircleAvatar(
                      //   radius: 64,
                      //   backgroundImage: AssetImage("assets/icon/alien.png"),
                      //   backgroundColor: Color.fromARGB(255, 100, 181, 246),
                      // ),
                      Center(
                        child: Container(
                          height: 480,
                          // bottom: -10,
                          // left: 80,
                          child: IconButton(
                            // onPressed: () => bordController.pickImage(),
                            onPressed: ()async{
                              filepath = await bordController.pickImage();
                              setState(() {
                                pickedImage = FileImage(filepath);
                              });
                            },
                            
                            icon: const Icon(
                              size: 56,
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:24.0),
                        child: IconButton(
                          icon: const Icon(Icons.undo, size: 40, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_calendar,
                        color: Colors.white, size: 30.0),
                        // ボタンが押されたときに表示する
                        onPressed: () {
                          var now = DateTime.now();
                          DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(now.year, now.month, now.day),
                            maxTime: DateTime(now.year + 1, 12, 31), 
                            onConfirm: (date) {
                              setState(() {
                                print(targetday);
                                  targetday = date;
                                  viewday = date.toString().split(' ')[0];
                                  print(targetday);
                              });
                            },
                            currentTime: targetday, locale: LocaleType.jp
                          );
                        },
                      ),
                      Text(
                        viewday
                      )
                    ],
                  ),
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      controller: _boardAddController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'キャプションを入力...',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                          bordController.postComment(context, _boardAddController.text, filepath, selectedLatlng, targetday.toString().split(" ")[0]);
                          bordController.showProgressDialog(context);
                      },
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: InkWell(
                        onTap: () async {
                          selectedLatlng =
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddBoardMap(),
                              ),
                            );
                          print(selectedLatlng);
                        },
                        child: Lottie.asset(
                          'assets/earth-globe-map.json',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_wavysmap_native/constants.dart';
// import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
// import 'package:flutter_wavysmap_native/views/widgets/text_input_field.dart';

// class SignupScreen extends StatelessWidget {
//   SignupScreen({Key? key}) : super(key: key);

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Wavy's Map",
//               style: TextStyle(
//                 fontSize: 35,
//                 color: buttonColor,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             const Text(
//               'Register',
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(
//               height: 25,
//             ),
//             Stack(
//               children: [
//                 const CircleAvatar(
//                   radius: 64,
//                   backgroundImage: AssetImage("assets/icon/alien.png"),
//                   backgroundColor: Color.fromARGB(255, 100, 181, 246),
//                 ),
//                 Positioned(
//                   bottom: -10,
//                   left: 80,
//                   child: IconButton(
//                     onPressed: () => authController.pickImage(),
//                     icon: const Icon(
//                       Icons.add_a_photo,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextInputField(
//                 controller: _usernameController,
//                 labelText: 'Username',
//                 icon: Icons.person,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextInputField(
//                 controller: _emailController,
//                 labelText: 'Email',
//                 icon: Icons.email,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextInputField(
//                 controller: _passwordController,
//                 labelText: 'Password',
//                 icon: Icons.lock,
//                 isObscure: true,
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width - 40,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: buttonColor,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(5),
//                 ),
//               ),
//               child: InkWell(
//                 onTap: () => authController.registerUser(
//                   _usernameController.text,
//                   _emailController.text,
//                   _passwordController.text,
//                   authController.profilePhoto,
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Register',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Already have an account? ',
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () => Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => LoginScreen(),
//                     ),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 20, color: buttonColor),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
