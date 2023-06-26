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

class WellBabyRecordForm extends StatefulWidget {
  const WellBabyRecordForm({Key? key}) : super(key: key);

  @override
  State<WellBabyRecordForm> createState() => _WellBabyRecordFormState();
}

class _WellBabyRecordFormState extends State<WellBabyRecordForm> {
  Future<bool> addWellBabyPatient() async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        motherMobileNumber.text.isEmpty ||
        birthdateController.text.isEmpty ||
        birthWeightController.text.isEmpty ||
        birthLengthController.text.isEmpty ||
        motherName.text.isEmpty) {
      // Show an error message or perform necessary actions for handling empty fields
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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

// Reference the main "patients" collection
      CollectionReference patientsCollection =
          FirebaseFirestore.instance.collection('patients');

// Create a new document in the "patients" collection
      DocumentReference patientDocRef =
          patientsCollection.doc(userCredential.user!.uid);

// Set the data for the main document
      await patientDocRef.set({
        'type': "Patient",
        'first name': firstName.text,
        'last name': lastName.text,
        'middle name': middleName.text,
        'gender': genderDropdownValue,
        'birthdate': birthdateController.text,
        'weight': birthWeightController.text,
        'length': birthLengthController.text,
        'place of delivery': podValue,
        'type of delivery': todValue,
        'attended by': abValue,
        'mother name': motherName.text,
        'mother age': motherAddress.text,
        'contact number': motherMobileNumber.text,
        'mother address': motherAddress.text,
        'mother birthday': motherBdayController.text,
        'uid': userCredential.user!.uid,
        'category': "Well-Baby Record",
        'email': emailController.text,
      });

// Reference the subcollection within the main document
      CollectionReference subcollectionRef =
          patientDocRef.collection('vaccines');

// Create a new document in the subcollection with auto-generated document ID
      DocumentReference subDocRef = await subcollectionRef.add(
        {
          "vaccine uid": "",
          "vaccine name": "BCG",
          "vaccine description": "Vaccine against tuberculosis",
          "vaccine date": birthdateController.text
        },
      );
      String subDocId = subDocRef.id;
      await subDocRef.update({"vaccine uid": subDocId});

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
      print('Error adding Well-Baby patient: $error');
      return false; // Return false to indicate failure
    }
  }

  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController birthdateController = new TextEditingController();
  TextEditingController birthWeightController = new TextEditingController();
  TextEditingController birthLengthController = new TextEditingController();
  TextEditingController doneDateController = new TextEditingController();
  TextEditingController nbsrController = new TextEditingController();
  TextEditingController motherName = new TextEditingController();
  TextEditingController motherMobileNumber = new TextEditingController();
  TextEditingController motherAge = new TextEditingController();
  TextEditingController motherAddress = new TextEditingController();
  TextEditingController motherBdayController = new TextEditingController();

  List<String> genderList = <String>['Male', 'Female'];
  late String genderDropdownValue = genderList.first;
  bool isMale = true;

  String? podValue;
  String? todValue;
  String? abValue;

  void addPreNatalPatient() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(userCredential.user!.uid)
        .set({
      'type': "Patient",
      'first name': firstName.text,
      'last name': lastName.text,
      'middle name': middleName.text,
      'gender': genderDropdownValue,
      'birthdate': birthdateController.text,
      'weight': birthWeightController.text,
      'length': birthLengthController.text,
      'place of delivery': podValue,
      'type of delivery': todValue,
      'attended by': abValue,
      'mother name': motherName.text,
      'mother contact number': motherMobileNumber.text,
      'mother address': motherAddress.text,
      'mother birthday': motherBdayController.text,
      'uid': userCredential.user!.uid,
      'category': "Well-Baby Record",
    });
  }

  var _text = '';

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
                              "WELL BABY FORM",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(),
                          ],
                        ),
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
                                "Enter Password",
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
                        NameWidget(
                          firstname: firstName,
                          middlename: middleName,
                          lastname: lastName,
                        ),
                        patientGender(),
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
                        Weight(),
                        birthLength(),
                        placeOfDelivery(),
                        typeOfDelivery(),
                        attendedBy(),
                        Header(text: "Mother Information"),
                        MotherWidget(
                          motherName: motherName,
                          motherAge: motherAge,
                          motherAddress: motherAddress,
                          mobileNumber: motherMobileNumber,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mother Birthday",
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
                                    controller: motherBdayController,
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
                                      motherBdayController.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
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
                                  bool addWellBabySuccess =
                                      await addWellBabyPatient();
                                  if (addWellBabySuccess) {
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container attendedBy() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Attended By",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 128,
          width: 330,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    value: "Doctor",
                    groupValue: abValue,
                    onChanged: (String? value) {
                      setState(() {
                        abValue = value;
                      });
                    },
                  ),
                  Text("Doctor")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Nurse",
                    groupValue: abValue,
                    onChanged: (String? value) {
                      setState(() {
                        abValue = value;
                      });
                    },
                  ),
                  Text("Nurse")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Midwife",
                    groupValue: abValue,
                    onChanged: (String? value) {
                      setState(() {
                        abValue = value;
                      });
                    },
                  ),
                  Text("Midwife")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Hilot/TBA",
                    groupValue: abValue,
                    onChanged: (String? value) {
                      setState(() {
                        abValue = value;
                      });
                    },
                  ),
                  Text("Hilot/TBA")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container typeOfDelivery() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Type of Delivery",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 75,
          width: 330,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    value: "Caesarean Section",
                    groupValue: todValue,
                    onChanged: (String? value) {
                      setState(() {
                        todValue = value;
                      });
                    },
                  ),
                  Text("Caesarean Section")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Normal Spontaneous Delivery",
                    groupValue: todValue,
                    onChanged: (String? value) {
                      setState(() {
                        todValue = value;
                      });
                    },
                  ),
                  Text("Normal Spontaneous Delivery")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container placeOfDelivery() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Place of Delivery",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 75,
          width: 330,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    value: "Hospital",
                    groupValue: podValue,
                    onChanged: (String? value) {
                      setState(() {
                        podValue = value;
                      });
                    },
                  ),
                  Text("Hospital")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Lying-in",
                    groupValue: podValue,
                    onChanged: (String? value) {
                      setState(() {
                        podValue = value;
                      });
                    },
                  ),
                  Text("Lying-in")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container birthLength() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Birth Length",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: birthLengthController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  suffixText: "cm",
                  hintText: "e.g.,170 cm",
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
        ],
      ),
    );
  }

  Container Weight() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Birth Weight",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: birthWeightController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  suffixText: "kg",
                  hintText: "e.g.,70 kg",
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
        ],
      ),
    );
  }

  Container patientGender() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Patient Gender",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 330,
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid, width: 0.50),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: genderDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: (String? value) {
                setState(() {
                  genderDropdownValue = value!;
                  if (genderDropdownValue == 'Male') {
                    isMale = true;
                  } else {
                    isMale = false;
                  }

                  // checkSex();
                });
              },
              items: genderList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ]),
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

class phoneNumber extends StatelessWidget {
  const phoneNumber({Key? key, required this.contactNumber}) : super(key: key);

  final TextEditingController contactNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              width: 330,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                controller: contactNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please enter a valid phone number.",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class MotherWidget extends StatelessWidget {
  const MotherWidget(
      {Key? key,
      required this.motherName,
      required this.motherAge,
      required this.motherAddress,
      required this.mobileNumber})
      : super(key: key);

  final TextEditingController motherName;
  final TextEditingController motherAge;
  final TextEditingController motherAddress;
  final TextEditingController mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: motherName,
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
                    "Mother Name",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: motherAge,
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
                    "Mother Age",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: motherAddress,
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
                    "Complete Address",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              phoneNumber(contactNumber: mobileNumber)
            ],
          ),
        ],
      ),
    );
  }
}

class NameWidget extends StatelessWidget {
  const NameWidget(
      {Key? key,
      required this.firstname,
      required this.middlename,
      required this.lastname})
      : super(key: key);

  final TextEditingController firstname;
  final TextEditingController middlename;
  final TextEditingController lastname;

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
                    width: 260,
                    height: 40,
                    child: TextField(
                      controller: firstname,
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
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260,
                    height: 40,
                    child: TextField(
                      controller: middlename,
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
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260,
                    height: 40,
                    child: TextField(
                      controller: lastname,
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
