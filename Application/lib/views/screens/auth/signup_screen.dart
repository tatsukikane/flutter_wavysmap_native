import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/constants.dart';
import 'package:flutter_wavysmap_native/views/screens/auth/login_screen.dart';
import 'package:flutter_wavysmap_native/views/widgets/text_input_field.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  var agree = 0;

  //プロフ画像管理
  dynamic pickedImage = AssetImage("assets/icon/alien.png");
  //プロフ画像切り替え用 @ath
  var filepath;

//利用規約ダイアログ
Future<void> _showStartDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('利用規約'),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: const WebView(
                initialUrl: 'https://tatsukikane.github.io/wavysmap_privacypolicy/',  //表示したいWebページを指定する
              ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('同意しない'),
            ),
            TextButton(
              onPressed:() {
                agree = 1;
                Navigator.pop(context);
              },
              // onPressed: () => Navigator.pop(context),
              child: Text('同意する'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback(
              (_) => _showStartDialog()
      );
    }
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding:  EdgeInsets.only(bottom: bottomSpace),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wavy's Map",
                      style: TextStyle(
                        fontSize: 35,
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: pickedImage,
                          backgroundColor: Color.fromARGB(255, 100, 181, 246),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () async{
                              filepath = await authController.pickImage();
                              setState(() {
                                pickedImage = FileImage(filepath);
                              });
                            },
                            // onPressed: () => authController.pickImage(),
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _usernameController,
                        labelText: 'Username',
                        icon: Icons.person,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _passwordController,
                        labelText: 'Password',
                        icon: Icons.lock,
                        isObscure: true,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: InkWell(
                        onTap: (){
                          //利用規約の同意可否判断
                          if (agree == 1){
                            authController.registerUser(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                              authController.profilePhoto,
                            );
                          } else {
                            Get.snackbar('新規登録',
                              '登録する場合は、利用規約に同意してください');
                          }
                        },
                        // onTap: () => authController.registerUser(
                        //   _usernameController.text,
                        //   _emailController.text,
                        //   _passwordController.text,
                        //   authController.profilePhoto,
                        // ),
                        child: const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: buttonColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}