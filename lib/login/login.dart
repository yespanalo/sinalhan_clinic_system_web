import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sinalhan_clinic_system_web/categorySelection.dart';
import 'package:sinalhan_clinic_system_web/constants.dart';
import 'package:sinalhan_clinic_system_web/function/authFunctions.dart';
import 'package:sinalhan_clinic_system_web/home.dart';

import '../patient/PatientHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isObscure = true;
  void obscureText() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  bool isWrongCredentials = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Image(image: AssetImage("images/background.jpg")),
                  Positioned(
                    top: 150,
                    left: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Image.asset(
                            "images/sinalhan_logo.png",
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 80, right: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Image.asset(
                              "images/system_logo.png",
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ],
                      ),
                      medsizedbox,
                      const Text(
                        "Welcome",
                        style: h1,
                      ),
                      shortsizedbox,
                      const Text(
                        "Barangay Sinalhan Health Clinic Management System",
                        style: h4,
                      ),
                      shortsizedbox,
                      Visibility(
                        visible: isWrongCredentials,
                        child: Text(
                          "Invalid email or password! Try again!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),

                      shortsizedbox,
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 69, 69, 69)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                      medsizedbox,

                      const Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 69, 69, 69)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: isObscure,
                        controller: password,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: obscureText,
                              icon: isObscure
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                            ),
                            counterText: "",
                            hintText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),

                      longsizedbox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500,
                            height: 50,
                            child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  // foregroundColor:
                                  //     MaterialStateProperty.all<Color>(Colors.red),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          secondaryaccent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: secondaryaccent),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  String? error = await AuthServices.signinUser(
                                    email.text,
                                    password.text,
                                    context,
                                  );

                                  if (error == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('You are Logged In')),
                                    );

                                    String uid =
                                        FirebaseAuth.instance.currentUser!.uid;

                                    DocumentSnapshot patientSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('patients')
                                            .doc(uid)
                                            .get();

                                    DocumentSnapshot userSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .get();

                                    if (patientSnapshot.exists) {
                                      // UID exists in the "patients" collection
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientHomePage(
                                            uid: uid,
                                          ),
                                        ),
                                      );
                                    } else if (userSnapshot.exists) {
                                      // UID exists in the "users" collection
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ),
                                      );
                                    } else {
                                      // UID does not exist in either collection
                                      // Handle the case when the user is not found
                                    }
                                  }
                                },
                                child: const Text("Log in",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white))),
                          ),
                        ],
                      ),
                      medsizedbox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500,
                            height: 50,
                            child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  // foregroundColor:
                                  //     MaterialStateProperty.all<Color>(Colors.red),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          primarycolor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: primarycolor),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => categorySelection(),
                                    ),
                                  );
                                },
                                child: const Text("Sign up",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white))),
                          )
                        ],
                      )
                      // TextButton(
                      //   onPressed: () {
                      //     startTimer();
                      //   },
                      //   child: Text("start"),
                      // ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
