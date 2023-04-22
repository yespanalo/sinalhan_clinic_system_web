import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sinalhan_clinic_system_web/function/firebaseFunctions.dart';
import 'package:sweetsheet/sweetsheet.dart';

import 'package:http/http.dart' as http;

class UpdateUser extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String uid;

  const UpdateUser(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNumber,
      required this.uid})
      : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  DateTime now = DateTime.now();
  String msg = "";
  @override
  void initState() {
    msg = "";
    super.initState();
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  late TextEditingController firstNameController = new TextEditingController()
    ..text = widget.firstName;
  late TextEditingController lastNameController = new TextEditingController()
    ..text = widget.lastName;
  late TextEditingController emailController = new TextEditingController()
    ..text = widget.email;
  late TextEditingController mobileNumberController =
      new TextEditingController()..text = widget.mobileNumber;

  var _text = '';
  final SweetSheet _sweetSheet = SweetSheet();

  bool isObscureold = true;
  void obscureTexOldt() {
    setState(() {
      isObscureold = !isObscureold;
    });
  }

  bool isObscurenew = true;
  void obscureTexNew() {
    setState(() {
      isObscurenew = !isObscurenew;
    });
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    // if (oldpasswordController.text != widget.password &&
    //     oldpasswordController.text.length > 0) {
    //   return "Invalid Password!";
    // }

    // if (newPasswordController.text.length < 4 &&
    //     newPasswordController.text.length > 0) {
    //   return 'Too short';
    // }
    // return null if the text is valid
    return null;
  }

  void _submit() {
    // if there is no error text
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      _sweetSheet.show(
        context: context,
        title: Text("Confirmation"),
        description: Text("Update User?"),
        color: SweetSheetColor.SUCCESS,
        negative: SweetSheetAction(
          onPressed: () async {
            String? error = await FirestoreServices.updateUserField(
                widget.uid,
                firstNameController.text,
                lastNameController.text,
                mobileNumberController.text,
                emailController.text);
            if (error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully Updated!')),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please check your details')),
              );
              Navigator.pop(context);
            }
          },
          title: 'CONFIRM',
        ),
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'CANCEL',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      margin: EdgeInsets.only(
                          top: 50, bottom: 50, left: 10, right: 10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Update User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Update User Details.",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    child: TextField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(
                                            r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!,./\d]')),
                                        LengthLimitingTextInputFormatter(20),
                                      ],
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          hintText: "First Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 250,
                                    child: TextField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(RegExp(
                                            r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!,./\d]')),
                                        LengthLimitingTextInputFormatter(20),
                                      ],
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          hintText: "Last Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 500,
                                    child: TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          hintText: "Email",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 520,
                                child: TextField(
                                  controller: mobileNumberController,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Mobile Number",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(15)),
                                      // foregroundColor:
                                      //     MaterialStateProperty.all<Color>(Colors.red),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 40, 170, 44)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 40, 170, 44)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
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
                                              Colors.grey),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }
}
