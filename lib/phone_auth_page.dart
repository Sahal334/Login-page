import 'package:flutter/material.dart';
import 'package:login_page_auth/firebase_service.dart';
import 'package:login_page_auth/widget/build_text_widget.dart';

class PhoneOTPVerification extends StatefulWidget {
  const PhoneOTPVerification({Key? key}) : super(key: key);

  @override
  State<PhoneOTPVerification> createState() => _PhoneOTPVerificationState();
}

class _PhoneOTPVerificationState extends State<PhoneOTPVerification> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isOtpVisible = false;
  String? verificationId;

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputTextField("Contact Number", phoneNumberController, context),
            isOtpVisible
                ? inputTextField("OTP", otpController, context)
                : SizedBox(),
            !isOtpVisible
                ? SendOTPButton("Send OTP")
                : SubmitOTPButton("Submit"),
          ],
        ),
      ),
    );
  }

  Widget SendOTPButton(String text) => ElevatedButton(
        onPressed: () async {
          setState(() {
            isOtpVisible = true;
          });
          await AuthService().sendOTP(phoneNumberController.text, onCodeSent);
        },
        child:
            BuildTextWidget(text: text, Fontsize: 14, Fontcolor: Colors.black),
      );

  void onCodeSent(String verificationId, int? resendToken) {
    setState(() {
      this.verificationId = verificationId;
      isOtpVisible = true;
    });
    AuthService().printMessage(
        "Verification code sent to +91${phoneNumberController.text}");
  }

  Widget SubmitOTPButton(String text) => ElevatedButton(
        onPressed: () async {
          if (verificationId != null) {
            try {
              await AuthService()
                  .authenticate(verificationId!, otpController.text);
            } catch (e) {
              AuthService().printMessage("Failed to authenticate: $e");
            }
          } else {
            AuthService().printMessage("Verification ID is null");
          }
        },
        child:
            BuildTextWidget(text: text, Fontsize: 14, Fontcolor: Colors.black),
      );

  Widget inputTextField(String labelText,
          TextEditingController textEditingController, BuildContext context) =>
      Padding(
        padding: EdgeInsets.all(10.00),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: TextFormField(
            obscureText: labelText == "OTP" ? true : false,
            controller: textEditingController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              hintText: labelText,
              hintStyle: TextStyle(fontSize: 15),
            ),
          ),
        ),
      );
}
