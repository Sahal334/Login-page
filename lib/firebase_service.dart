import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Function for user registration
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message; // Return Firebase Auth error message
      }
    } catch (e) {
      return e.toString(); // General error handling
    }
  }

  // Function for user login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message; // Return Firebase Auth error message
      }
    } catch (e) {
      return e.toString(); // General error handling
    }
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // // Function for phone number verification
  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // Auto-retrieve verification code and sign in user
  //       await _auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Log or handle verification failed error
  //       print('Verification failed: ${e.message}');
  //       // Additional error handling can be added here
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       // This callback is triggered when the verification code is sent
  //       // Normally, you'd prompt the user to enter the SMS code received
  //       // Example:
  //       // String smsCode = await getUserInputCode();
  //
  //       // Using a placeholder for SMS code input (to be replaced by actual user input)
  //       String smsCode = 'xxxxxx';
  //
  //       // Creating a PhoneAuthCredential with the verification ID and SMS code
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId,
  //         smsCode: smsCode,
  //       );
  //
  //       // Sign the user in with the credential
  //       await _auth.signInWithCredential(credential);
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Handle the timeout for code auto-retrieval
  //       print('Auto retrieval timeout: $verificationId');
  //     },
  //     timeout: Duration(seconds: 60), // Timeout duration can be adjusted
  //   );
  // }

  String phoneNumber = "";

  Future<void> sendOTP(
      String phoneNumber, Function(String, int?) codeSent) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolve OTP (e.g., for device auto-detection of OTP)
        await auth.signInWithCredential(credential);
        printMessage(
            "Phone number automatically verified and user signed in: ${credential}");
      },
      verificationFailed: (FirebaseAuthException e) {
        printMessage("Phone number verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save the verification ID to use in the authenticate method
        codeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Called when the automatic retrieval time out
        printMessage("Verification code auto-retrieval timed out");
      },
    );
  }

  Future<void> authenticate(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      printMessage("Authentication Successful");
    } else {
      printMessage("User already exists");
    }
  }

  void printMessage(String msg) {
    debugPrint(msg);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Login with Email and Password
  Future<String?> Googlelogin(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Start the sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
