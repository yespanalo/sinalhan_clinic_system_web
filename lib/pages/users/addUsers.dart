import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sinalhan_clinic_system_web/constants.dart';
import 'package:sinalhan_clinic_system_web/function/authFunctions.dart';
import 'package:sinalhan_clinic_system_web/home.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool error = false, sending = false, success = false;
  DateTime now = DateTime.now();
  String msg = "";

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose(); // release the stream
    passwordController.dispose(); // release the stream
    confirmPasswordController.dispose(); // release the stream
    firstNameController.dispose(); // release the stream
    lastNameController.dispose(); // release the stream
    emailController.dispose(); // release the stream
    mobileNumberController.dispose(); // release the stream
    super.dispose();
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();

  String _userType = '';
  var _text = '';
  final SweetSheet _sweetSheet = SweetSheet();

  void checkUserTypeRadio(String value) {
    setState(() {
      _userType = value;
    });
  }

  bool isObscure = true;
  void obscureText() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  bool isObscureConfirm = true;
  void obscureTextConfirm() {
    setState(() {
      isObscureConfirm = !isObscureConfirm;
    });
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code

    if (passwordController.text.length < 4 &&
        passwordController.text.length > 0) {
      return 'Too short';
    }

    if (passwordController.text != confirmPasswordController.text) {
      return 'Password doesn\'t match';
    }
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
        description: Text("Add User?"),
        color: SweetSheetColor.SUCCESS,
        negative: SweetSheetAction(
          onPressed: () async {
            String? error = await AuthServices.signupUser(
              emailController.text,
              passwordController.text,
              firstNameController.text,
              lastNameController.text,
              mobileNumberController.text,
              _userType,
              context,
            );
            if (error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully Registered!')),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please check your details')),
              );
              Navigator.pop(context);
            }

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Home(),
            //   ),
            // );
          },
          title: 'CONFIRM',
        ),
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.pop(context);
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
                            "Add New User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Enter User Details.",
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
                                    width: 250,
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 250,
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
                                    width: 250,
                                    child: TextField(
                                      obscureText: isObscure,
                                      onChanged: (text) =>
                                          setState(() => _text),
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: obscureText,
                                            icon: isObscure
                                                ? Icon(Icons.remove_red_eye)
                                                : Icon(Icons
                                                    .remove_red_eye_outlined),
                                          ),
                                          errorText: _errorText,
                                          counterText: "",
                                          hintText: "Password",
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
                                      obscureText: isObscureConfirm,
                                      onChanged: (text) =>
                                          setState(() => _text),
                                      controller: confirmPasswordController,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: obscureTextConfirm,
                                            icon: isObscure
                                                ? Icon(Icons.remove_red_eye)
                                                : Icon(Icons
                                                    .remove_red_eye_outlined),
                                          ),
                                          counterText: "",
                                          hintText: "Confirm Password",
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
                              Text(
                                "Type",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 118, 118, 118),
                                    fontWeight: FontWeight.bold),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 30,
                                        child: ListTile(
                                          title: Text('Admin',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          leading: Radio(
                                              value: 'Admin',
                                              groupValue: _userType,
                                              onChanged: (value) {
                                                checkUserTypeRadio(
                                                    value as String);
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 29,
                                      ),
                                      Container(
                                        width: 250,
                                        height: 30,
                                        child: ListTile(
                                          title: Text('Health Worker',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          leading: Radio(
                                              value: 'Health Worker',
                                              groupValue: _userType,
                                              onChanged: (value) {
                                                checkUserTypeRadio(
                                                    value as String);
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                      "Add",
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
                                              secondaryaccent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          side: BorderSide(
                                              color: secondaryaccent),
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
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Home(),
                                      //   ),
                                      // );
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
