import 'package:flutter/material.dart';
import 'package:login_page_auth/home_page.dart';
import 'package:login_page_auth/widget/build_text_widget.dart';

import 'firebase_service.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool passwordVisible = false;
  TextEditingController myEmailCondroler = TextEditingController();
  TextEditingController myPasswordCondroler = TextEditingController();
  @override
  void initState() {
    passwordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: myEmailCondroler,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 15)),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    controller: myPasswordCondroler,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
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
                    final message = await AuthService().registration(
                      email: myEmailCondroler.text,
                      password: myPasswordCondroler.text,
                    );
                    if (message!.contains('Success')) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  },
                  child: Center(
                    child: BuildTextWidget(
                        text: 'Create account',
                        Fontsize: 20,
                        Fontcolor: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
