import 'package:flutter/material.dart';
import 'package:login_page_auth/create_account.dart';
import 'package:login_page_auth/phone_auth_page.dart';
import 'package:login_page_auth/widget/build_text_widget.dart';

import 'firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool passwordVisible = false;
  TextEditingController myEmailController = TextEditingController();
  TextEditingController myPasswordController = TextEditingController();

  @override
  void initState() {
    passwordVisible = true;
    super.initState();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black)),
                    width: 400,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 90),
                        BuildTextWidget(
                            text: "continue with ",
                            Fontsize: 15,
                            Fontcolor: Colors.black),
                        SizedBox(width: 10),
                        Image.asset(
                          "assets/twitter.jpg",
                          width: 50,
                          height: 27,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccount()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black)),
                    width: 400,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 90),
                        BuildTextWidget(
                            text: "create account ",
                            Fontsize: 15,
                            Fontcolor: Colors.black),
                        SizedBox(width: 10),
                        Icon(Icons.mail_outline_sharp, size: 40),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneOTPVerification()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black)),
                    width: 400,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 90),
                        BuildTextWidget(
                            text: "phone number ",
                            Fontsize: 15,
                            Fontcolor: Colors.black),
                        SizedBox(width: 10),
                        Icon(Icons.phone_android, size: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildTextWidget(
                text: 'welcome',
                Fontsize: 35,
                Fontcolor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    controller: myEmailController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      controller: myPasswordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black54),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        hintText: "Password",
                        hintStyle: TextStyle(fontSize: 15),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 60,
                  width: 550,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: GestureDetector(
                    onTap: () async {
                      final message = await AuthService().login(
                        email: myEmailController.text,
                        password: myPasswordController.text,
                      );
                      if (message!.contains('Success')) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PhoneOTPVerification(),
                          ),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    },
                    child: Center(
                      child: BuildTextWidget(
                          text: 'login', Fontsize: 20, Fontcolor: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 70),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: BuildTextWidget(
                          text: 'or continue with',
                          Fontsize: 15,
                          Fontcolor: Colors.black)),
                  Expanded(
                    child: Divider(
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: GestureDetector(
                        onTap: () async {
                          final userCredential =
                              await AuthService().signInWithGoogle();
                          if (userCredential != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Signed in with Google: ${userCredential.user!.email}'),
                              ),
                            );
                            // Navigate to a different screen if needed
                          }
                        },
                        child: Image.asset(
                          "assets/google.jpg",
                          height: 43,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: GestureDetector(
                        onTap: () {
                          print('button pressed');
                        },
                        child: Image.asset(
                          "assets/apple.jpg",
                          height: 43,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet(context); // Show bottom sheet
                        },
                        child: Icon(
                          Icons.more_horiz_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
