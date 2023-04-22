import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sinalhan_clinic_system_web/function/firebaseFunctions.dart';

class AuthServices {
  static signupUser(
      String email,
      String password,
      String firstName,
      String lastName,
      String mobileNumber,
      String type,
      BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(firstName + " " + lastName);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(firstName, lastName, mobileNumber, email,
          type, userCredential.user!.uid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password Provided is too weak")));
      } else if (e.code == 'email=already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email Provided already Exists")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<String?> signinUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // No error occurred
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found with this email";
      } else if (e.code == "wrong-password") {
        return "Password did not match";
      }
      return e
          .toString(); // Return any other Firebase Auth exception as a string
    } catch (e) {
      return e.toString(); // Return any other exception as a string
    }
  }

  // static signinUser(
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     // ScaffoldMessenger.of(context)
  //     //     .showSnackBar(SnackBar(content: Text('You are Logged In')));
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //     SnackBar(content: Text("No user found with this Email")));
  //       throw Exception("No user found with this Email");
  //     } else if (e.code == "wrong-password") {
  //       // ScaffoldMessenger.of(context)
  //       //     .showSnackBar(SnackBar(content: Text("Password did not match")));
  //       throw Exception("Password did not match");
  //     }
  //   }
  // }
}
