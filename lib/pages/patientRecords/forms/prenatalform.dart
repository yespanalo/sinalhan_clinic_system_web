import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sinalhan_clinic_system_web/constants%20copy.dart';
import 'package:sinalhan_clinic_system_web/function/firebaseFunctions.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PreNatalRecordForm extends StatefulWidget {
  const PreNatalRecordForm({Key? key}) : super(key: key);

  @override
  State<PreNatalRecordForm> createState() => _PreNatalRecordFormState();
}

class _PreNatalRecordFormState extends State<PreNatalRecordForm> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController husband = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController birthdateController = new TextEditingController();
  TextEditingController lmpController = new TextEditingController();
  TextEditingController edcController = new TextEditingController();
  TextEditingController aogController = new TextEditingController();
  TextEditingController gravida = new TextEditingController();
  TextEditingController term = new TextEditingController();
  TextEditingController preterm = new TextEditingController();
  TextEditingController abortion = new TextEditingController();
  TextEditingController living = new TextEditingController();
  TextEditingController contactNumberController = new TextEditingController();

  var _text = "";

  Future<bool> addPreNatalPatient() async {
    if (firstName.text.isEmpty ||
        middleName.text.isEmpty ||
        lastName.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        address.text.isEmpty ||
        lmpController.text.isEmpty ||
        birthdateController.text.isEmpty ||
        edcController.text.isEmpty ||
        aogController.text.isEmpty ||
        gravida.text.isEmpty ||
        term.text.isEmpty ||
        preterm.text.isEmpty ||
        abortion.text.isEmpty ||
        living.text.isEmpty ||
        contactNumberController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userCredential.user!.uid)
          .set({
        'type': "Patient",
        'first name': firstName.text,
        'last name': lastName.text,
        'middle name': middleName.text,
        'category': "Pre-Natal Record",
        'email': emailController.text,
        'password': passwordController.text,
        'contact number': contactNumberController.text,
        'husband name': husband.text,
        'address': address.text,
        'birthdate': birthdateController.text,
        'last mens period': lmpController.text,
        'estimated date of confinement': edcController.text,
        'assessment of gestational date': aogController.text,
        'gravida': gravida.text,
        'term': term.text,
        'preterm': preterm.text,
        'abortion': abortion.text,
        'living': living.text,
        'uid': userCredential.user!.uid
      });

      Fluttertoast.showToast(
        msg: "Success!",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return true; // Return true to indicate success
    } catch (error) {
      print('Error adding individual patient: $error');
      return false; // Return false to indicate failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "PHILIPPINE HEALTH INSURANCE CORPORATION",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              "SANTA ROSA CITY HEALTH OFFICE 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "PRE NATAL FORM",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(),
                          ],
                        ),
                        Header(text: "Sign up with email"),
                        email(
                          emailController: emailController,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 330,
                                child: TextField(
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Header(
                          text: "General Patient Information",
                        ),
                        GeneralInformationWidget(
                            contactNumberController: contactNumberController,
                            firstName: firstName,
                            middleName: middleName,
                            lastName: lastName,
                            age: age,
                            husband: husband,
                            address: address),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Patient Birthdate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 330,
                                  child: TextField(
                                    readOnly: true,
                                    onChanged: (text) => setState(() => _text),
                                    controller: birthdateController,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      date = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2021),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100)))!;
                                      birthdateController.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Last Menstrual Period",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 330,
                                  child: TextField(
                                    readOnly: true,
                                    onChanged: (text) => setState(() => _text),
                                    controller: lmpController,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      date = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2021),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100)))!;
                                      lmpController.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estimated Date of Confinement",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 330,
                                  child: TextField(
                                    readOnly: true,
                                    onChanged: (text) => setState(() => _text),
                                    controller: edcController,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      date = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2021),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100)))!;
                                      edcController.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assessment of Gestational Age",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 330,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d{1,3}$')),
                                    ],
                                    controller: aogController,
                                    decoration: InputDecoration(
                                        hintText: "Number of week of pregnancy",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                  ),
                                ),
                              ]),
                        ),
                        Header(text: 'Obstetric History'),
                        GTPALWidget(
                            gravida: gravida,
                            term: term,
                            preterm: preterm,
                            abortion: abortion,
                            living: living),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 10, left: 20, right: 20),
                              width: 370,
                              height: 50,
                              child: TextButton(
                                onPressed: () async {
                                  bool addPreNatalSuccess =
                                      await addPreNatalPatient();
                                  if (addPreNatalSuccess) {
                                    Navigator.pop(context);
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          secondaryaccent),
                                ),
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 10, left: 20, right: 20),
                              width: 370,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralInformationWidget extends StatelessWidget {
  const GeneralInformationWidget(
      {Key? key,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.age,
      required this.husband,
      required this.contactNumberController,
      required this.address})
      : super(key: key);

  final TextEditingController firstName;
  final TextEditingController middleName;
  final TextEditingController lastName;
  final TextEditingController age;
  final TextEditingController husband;
  final TextEditingController address;
  final TextEditingController contactNumberController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                      ],
                      controller: firstName,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "First Name",
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                      ],
                      controller: middleName,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Middle Name",
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                      ],
                      controller: lastName,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                      ],
                      controller: husband,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Husband Name",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: contactNumberController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,11}$')),
                      ],
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Contact Number",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: address,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Address",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GTPALWidget extends StatelessWidget {
  const GTPALWidget(
      {Key? key,
      required this.gravida,
      required this.term,
      required this.preterm,
      required this.abortion,
      required this.living})
      : super(key: key);

  final TextEditingController gravida;
  final TextEditingController term;
  final TextEditingController preterm;
  final TextEditingController abortion;
  final TextEditingController living;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 215,
                height: 40,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                  ],
                  controller: gravida,
                  decoration: InputDecoration(
                      hintText: "Number of pregnancyr",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Gravida",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 215,
                height: 40,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                  ],
                  controller: preterm,
                  decoration: InputDecoration(
                      hintText: "Number of premature",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Preterm",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 215,
                height: 40,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                  ],
                  controller: term,
                  decoration: InputDecoration(
                      hintText: "Number of full term",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Full Term",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 215,
                height: 40,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                  ],
                  controller: abortion,
                  decoration: InputDecoration(
                      hintText: "Number of abortion",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Abortion",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 215,
                height: 40,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                  ],
                  controller: living,
                  decoration: InputDecoration(
                      hintText: "Number of living children",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Living",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "$text",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
        ],
      ),
    );
  }
}

class email extends StatelessWidget {
  const email({Key? key, required this.emailController}) : super(key: key);

  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter email ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "example@example.com",
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "example@example.com",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
