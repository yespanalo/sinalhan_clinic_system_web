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
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController birthdateController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  TextEditingController birthLengthController = new TextEditingController();
  TextEditingController doneDateController = new TextEditingController();
  TextEditingController nbsrController = new TextEditingController();
  TextEditingController motherName = new TextEditingController();
  TextEditingController motherAge = new TextEditingController();
  TextEditingController motherCpab = new TextEditingController();
  TextEditingController motherAddress = new TextEditingController();
  TextEditingController motherBdayController = new TextEditingController();
  TextEditingController dateOfBCG = new TextEditingController();
  TextEditingController dateOfHEPAB = new TextEditingController();
  TextEditingController dateOfPENTA1 = new TextEditingController();
  TextEditingController dateOfPENTA2 = new TextEditingController();
  TextEditingController dateOfPENTA3 = new TextEditingController();
  TextEditingController dateOfMCV1 = new TextEditingController();
  TextEditingController dateOfMCV2 = new TextEditingController();
  TextEditingController dateOfOPV1 = new TextEditingController();
  TextEditingController dateOfOPV2 = new TextEditingController();
  TextEditingController dateOfOPV3 = new TextEditingController();
  TextEditingController dateOfROTA1 = new TextEditingController();
  TextEditingController dateOfROTA2 = new TextEditingController();
  TextEditingController dateOfIPV = new TextEditingController();
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
      'weight': weightController.text,
      'length': birthLengthController.text,
      'place of delivery': podValue,
      'type of delivery': todValue,
      'attended by': abValue,
      'done date': doneDateController.text,
      'newborn screening result': nbsrController.text,
      'mother name': motherName.text,
      'mother age': motherAddress.text,
      'mother cpab': motherCpab.text,
      'mother address': motherAddress.text,
      'mother birthday': motherBdayController.text,
      'date of bcg': dateOfBCG.text,
      'date of hepa b': dateOfHEPAB.text,
      'date of penta 1': dateOfPENTA1.text,
      'date of penta 2': dateOfPENTA2.text,
      'date of penta 3': dateOfPENTA3.text,
      'date of mcv 1': dateOfMCV1.text,
      'date of mcv 2': dateOfMCV2.text,
      'date of opv 1': dateOfOPV1.text,
      'date of opv 2': dateOfOPV2.text,
      'date of opv 3': dateOfOPV3.text,
      'date of rota 1': dateOfROTA1.text,
      'date of rota 2': dateOfROTA2.text,
      'date of ipv': dateOfIPV.text,
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
                        SizedBox(
                          height: 80,
                        ),
                        Header(text: "New Born Screening"),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Done Date",
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
                                    controller: doneDateController,
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
                                      doneDateController.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                        newBornScreeningResult(),
                        Header(text: "Mother Information"),
                        MotherWidget(
                          motherName: motherName,
                          motherAge: motherAge,
                          motherCpab: motherCpab,
                          motherAddress: motherAddress,
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
                        Header(text: "Immunizations"),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 30, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BCG",
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
                                    controller: dateOfBCG,
                                    decoration: InputDecoration(
                                        hintText: "Date of BCG",
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
                                      dateOfBCG.text =
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
                                  "HEPA B",
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
                                    controller: dateOfHEPAB,
                                    decoration: InputDecoration(
                                        hintText: "Date of HEPA B",
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
                                      dateOfHEPAB.text =
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
                                  "PENTA 1",
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
                                    controller: dateOfPENTA1,
                                    decoration: InputDecoration(
                                        hintText: "Date of PENTA 1",
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
                                      dateOfPENTA1.text =
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
                                  "PENTA 2",
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
                                    controller: dateOfPENTA2,
                                    decoration: InputDecoration(
                                        hintText: "Date of PENTA 2",
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
                                      dateOfPENTA2.text =
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
                                  "PENTA 3",
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
                                    controller: dateOfPENTA3,
                                    decoration: InputDecoration(
                                        hintText: "Date of PENTA 3",
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
                                      dateOfPENTA3.text =
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
                                  "MCV 1",
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
                                    controller: dateOfMCV1,
                                    decoration: InputDecoration(
                                        hintText: "Date of MCV 1",
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
                                      dateOfMCV1.text =
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
                                  "MCV 2",
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
                                    controller: dateOfMCV2,
                                    decoration: InputDecoration(
                                        hintText: "Date of MCV 2",
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
                                      dateOfMCV2.text =
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
                                  "OPV 1",
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
                                    controller: dateOfOPV1,
                                    decoration: InputDecoration(
                                        hintText: "Date of OPV 1",
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
                                      dateOfOPV1.text =
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
                                  "OPV 2",
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
                                    controller: dateOfOPV2,
                                    decoration: InputDecoration(
                                        hintText: "Date of OPV 2",
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
                                      dateOfOPV2.text =
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
                                  "OPV 3",
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
                                    controller: dateOfOPV3,
                                    decoration: InputDecoration(
                                        hintText: "Date of OPV 3",
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
                                      dateOfOPV3.text =
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
                                  "ROTA 1",
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
                                    controller: dateOfROTA1,
                                    decoration: InputDecoration(
                                        hintText: "Date of ROTA 1",
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
                                      dateOfROTA1.text =
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
                                  "ROTA 2",
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
                                    controller: dateOfROTA2,
                                    decoration: InputDecoration(
                                        hintText: "Date of ROTA 2",
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
                                      dateOfROTA2.text =
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
                                  "IPV",
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
                                    controller: dateOfIPV,
                                    decoration: InputDecoration(
                                        hintText: "Date of IPV",
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
                                      dateOfIPV.text =
                                          DateFormat('yyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ]),
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

  Container newBornScreeningResult() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Result",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: nbsrController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "Text",
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
          height: 75,
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
            "Weight",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: weightController,
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

class MotherWidget extends StatelessWidget {
  const MotherWidget(
      {Key? key,
      required this.motherName,
      required this.motherAge,
      required this.motherCpab,
      required this.motherAddress})
      : super(key: key);

  final TextEditingController motherName;
  final TextEditingController motherAge;
  final TextEditingController motherCpab;
  final TextEditingController motherAddress;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: motherCpab,
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
                    "CPAB(TT GIVEN TO MOTHER)",
                    style: TextStyle(fontSize: 11),
                  )
                ],
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
                  controller: motherAddress,
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
                    width: 215,
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
                    width: 215,
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
                    width: 215,
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
