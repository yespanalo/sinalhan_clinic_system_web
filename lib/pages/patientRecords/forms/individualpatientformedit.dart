import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../../constants copy.dart';

class IndividualPatientEditForm extends StatefulWidget {
  const IndividualPatientEditForm({required this.uid, Key? key})
      : super(key: key);

  final String uid;
  @override
  State<IndividualPatientEditForm> createState() =>
      _IndividualPatientEditFormState();
}

class _IndividualPatientEditFormState extends State<IndividualPatientEditForm> {
  FirebaseFirestore? firestore;
  CollectionReference? patientsCollection;
  Map<String, dynamic>? formData;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    firestore = FirebaseFirestore.instance;
    patientsCollection = firestore!.collection('patients');

    try {
      DocumentSnapshot snapshot =
          await patientsCollection!.doc(widget.uid).get();
      if (snapshot.exists) {
        setState(() {
          formData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        // Handle case where the form doesn't exist
        print('Form not found.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  late String? smokingValue = formData!['additional info']['smoking'];
  late bool packsPerYearVisibility = smokingValue == "Yes" ? true : false;

  late String? alcoholValue = formData!['additional info']['alcohol'];
  late bool bottlePerYearVisibility = alcoholValue == "Yes" ? true : false;

  List<String> genderList = <String>['Male', 'Female'];
  late String genderDropdownValue = formData!['gender'.toString()];
  bool isMale = true;

  late String? drugsValue = formData!['additional info']['illicit drugs'];
  late String? menopauseValue = formData!['additional info']['menopause'];
  late String? familyplanningValue =
      formData!['additional info']['family planning'];

  // List<String> MenarcheList = <String>['True', 'False'];
  // late String MenarcheDropdownValue = formData!['menarche'.toString()];

  List<String> CivilStatusList = <String>[
    'Single',
    'Married',
    'Annuled',
    'Widow/Widower',
    'Separted'
  ];
  late String CivilStatusDropdownValue = formData!['civil status'.toString()];

  List<String> EducationList = <String>[
    'College Degree, Post Graduate',
    'High School',
    'Elementary',
    'Vocational',
    'No Schooling'
  ];
  late String EducationDropdownValue =
      formData!['educational attainment'.toString()];

  late List<dynamic> pastMedicalHistoryList =
      formData!['additional info']['pastMedicalList'];
  void addItemToPastMedicalHistory(String newItem) {
    setState(() {
      pastMedicalHistoryList.add(newItem);
    });
  }

  late List<dynamic> pastOperationList =
      formData!['additional info']['past operation'];
  void addItemToPastOperationList(String newItem) {
    setState(() {
      pastOperationList.add(newItem);
    });
  }

  late List<dynamic> familyDiseasesList =
      formData!['additional info']['family diseases'];
  void addItemToFamilyDiseasesListList(String newItem) {
    setState(() {
      familyDiseasesList.add(newItem);
    });
  }

  late List<dynamic> childrenImmunizationList =
      formData!['additional info']['children immunizations'];

  void addItemTochildrenImmunizationList(String newItem) {
    setState(() {
      childrenImmunizationList.add(newItem);
    });
  }

  late List<dynamic> youngWomenImmunizationList =
      formData!['additional info']['women immunizations'];

  void addItemToyoungWomenImmunizationList(String newItem) {
    setState(() {
      youngWomenImmunizationList.add(newItem);
    });
  }

  late List<dynamic> pregnantImmunizationList =
      formData!['additional info']['pregnant immunizations'];

  void addItemTopregnantImmunizationList(String newItem) {
    setState(() {
      pregnantImmunizationList.add(newItem);
    });
  }

  late List<dynamic> elderlyImmunizationList =
      formData!['additional info']['elderly immunizations'];

  void addItemToelderlyImmunizationList(String newItem) {
    setState(() {
      elderlyImmunizationList.add(newItem);
    });
  }

  late List<dynamic> birthControlList =
      formData!['additional info']['birth control'];
  void addItemToBirthControlList(String newItem) {
    setState(() {
      birthControlList.add(newItem);
    });
  }

  void _showAddItemDialog(String itemCallBack) {
    String newItem = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please list any diseases that run in the family'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (itemCallBack == "family") {
                  addItemToFamilyDiseasesListList(newItem);
                } else if (itemCallBack == "pastOperation") {
                  addItemToPastOperationList(newItem);
                } else if (itemCallBack == "pastMedicalHistory") {
                  addItemToPastMedicalHistory(newItem);
                } else if (itemCallBack == "childrenImmunizations") {
                  addItemTochildrenImmunizationList(newItem);
                } else if (itemCallBack == "youngWomenImmunization") {
                  addItemToyoungWomenImmunizationList(newItem);
                } else if (itemCallBack == "pregnantImmunization") {
                  addItemTopregnantImmunizationList(newItem);
                } else if (itemCallBack == "birthControl") {
                  addItemToBirthControlList(newItem);
                } else {
                  addItemToelderlyImmunizationList(newItem);
                }

                // addItemCallback(newItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference patientsCollection = firestore.collection('patients');

    if (formData != null) {
      TextEditingController firstname = new TextEditingController()
        ..text = formData!['first name'];
      TextEditingController middlename = new TextEditingController()
        ..text = formData!['middle name'];
      TextEditingController lastname = new TextEditingController()
        ..text = formData!['last name'];
      TextEditingController birthdateController = new TextEditingController()
        ..text = formData!['birthdate'];
      TextEditingController contactNumber = new TextEditingController()
        ..text = formData!['contact number'];
      TextEditingController streetController = new TextEditingController()
        ..text = formData!['address'];
      TextEditingController cityController = new TextEditingController()
        ..text = formData!['address'];
      TextEditingController provinceController = new TextEditingController()
        ..text = formData!['address'];
      TextEditingController emailController = new TextEditingController()
        ..text = formData!['email'];
      TextEditingController religionController = new TextEditingController()
        ..text = formData!['religion'];
      TextEditingController occupationController = new TextEditingController()
        ..text = formData!['occupation'];
      TextEditingController motherName = new TextEditingController()
        ..text = formData!['mothers name'];
      TextEditingController fatherName = new TextEditingController()
        ..text = formData!['fathers name'];
      TextEditingController packsController = new TextEditingController()
        ..text = formData!['additional info']['packs per year'];
      TextEditingController bottlesController = new TextEditingController()
        ..text = formData!['additional info']['bottle per year'];
      TextEditingController lastMensController = new TextEditingController()
        ..text = formData!['additional info']['last mens'];
      TextEditingController periodDurationController =
          new TextEditingController()
            ..text = formData!['additional info']['period duration'];
      TextEditingController padsController = new TextEditingController()
        ..text = formData!['additional info']['pads per day'];
      TextEditingController intervalCycleController =
          new TextEditingController()
            ..text = formData!['additional info']['interval cycle'];
      TextEditingController onsetController = new TextEditingController()
        ..text = formData!['additional info']['onset of sexual intercourse'];
      TextEditingController gravidaController = new TextEditingController()
        ..text = formData!['additional info']['gravida'];
      TextEditingController parityController = new TextEditingController()
        ..text = formData!['additional info']['parity'];
      TextEditingController prematureController = new TextEditingController()
        ..text = formData!['additional info']['number of premature'];
      TextEditingController abortionController = new TextEditingController()
        ..text = formData!['additional info']['number of abortion'];
      TextEditingController livingChildrenController =
          new TextEditingController()
            ..text = formData!['additional info']['number of living children'];
      var _text;
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
                                "INDIVIDUAL HEALTH PROFILE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(),
                            ],
                          ),
                          Header(
                            text: "General Patient Information",
                          ),

                          NameWidget(firstname, middlename, lastname),
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
                                          DateFormat('yyyy-MM-dd').format(date);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          patientGender(),
                          Address(streetController, cityController,
                              provinceController),
                          phoneNumber(contactNumber),
                          civilStatus(),
                          religion(religionController),
                          occupation(occupationController),
                          educationalAttainment(),
                          mothersName(motherName),
                          fathersName(fatherName),
                          Header(
                            text: "Patient Medical History",
                          ),
                          getList(
                            "List past medical history",
                            pastMedicalHistoryList,
                            () => _showAddItemDialog("pastMedicalHistory"),
                          ),
                          getList(
                            "Please list past operations",
                            pastOperationList,
                            () => _showAddItemDialog("pastOperation"),
                          ),
                          getList(
                            "Please list family diseases",
                            familyDiseasesList,
                            () => _showAddItemDialog("family"),
                          ),
                          Header(
                            text: "Healthy & Unhealthy Habits",
                          ),
                          SmokingRadio(),
                          Visibility(
                            visible: packsPerYearVisibility,
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.only(
                                  left: 30, right: 20, bottom: 10),
                              child: TextField(
                                controller: packsController,
                                decoration: InputDecoration(
                                  hintText:
                                      "Please enter how many packs per year",
                                  contentPadding: EdgeInsets.only(
                                      left: 5, top: 2, bottom: 2),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          alcoholRadio(),
                          Visibility(
                            visible: bottlePerYearVisibility,
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.only(
                                  left: 30, right: 20, bottom: 10),
                              child: TextField(
                                controller: bottlesController,
                                decoration: InputDecoration(
                                  hintText: "Please enter how bottles per year",
                                  contentPadding: EdgeInsets.only(
                                      left: 5, top: 2, bottom: 2),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DrugsRadio(),
                          Header(text: "Immunizations"),
                          getList(
                              "Please list if there are children immunizations received",
                              childrenImmunizationList,
                              () =>
                                  _showAddItemDialog("childrenImmunizations")),
                          Visibility(
                            visible: !isMale,
                            child: getList(
                              "Please list if there are young women immunizations received",
                              youngWomenImmunizationList,
                              () =>
                                  _showAddItemDialog("youngWomenImmunization"),
                            ),
                          ),
                          Visibility(
                            visible: !isMale,
                            child: getList(
                              "Please list if there are immunizations for pregnant received",
                              pregnantImmunizationList,
                              () => _showAddItemDialog("pregnantImmunization"),
                            ),
                          ),
                          getList(
                            "Please list if there are elderly immunizations received",
                            elderlyImmunizationList,
                            () => _showAddItemDialog("elderlyImmunizations"),
                          ),

                          Visibility(
                            visible: !isMale,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Header(text: "Menstrual History"),
                                // Menarche(),
                                LastMens(lastMensController),
                                periodDuration(periodDurationController),
                                padsPerDay(padsController),
                                IntervalCycle(intervalCycleController),
                                OnsetofIntercourse(onsetController),
                                getList(
                                  "Please list birth control method if there is any",
                                  birthControlList,
                                  () => _showAddItemDialog("birthControl"),
                                ),
                                Menopause(),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !isMale,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Header(text: "Pregnancy History"),
                                Gravida(gravidaController),
                                Parity(parityController),
                                Premature(prematureController),
                                Abortion(abortionController),
                                LivingChildren(livingChildrenController),
                                FamilyPlanning(),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20, bottom: 10, left: 20, right: 20),
                                width: 400,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    addIndividualPatient();
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                width: 400,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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

                          // LastMens(lastMensController),
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
    } else {
      return SizedBox(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      );
    }
  }

  // Container Menarche() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Text(
  //         "Menarche",
  //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
  //       ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         height: 40,
  //         width: 330,
  //         padding: EdgeInsets.only(left: 8, right: 8),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5.0),
  //           border: Border.all(
  //               color: Colors.grey, style: BorderStyle.solid, width: 0.50),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             value: MenarcheDropdownValue,
  //             icon: const Icon(Icons.arrow_downward),
  //             elevation: 16,
  //             style: const TextStyle(
  //               color: Colors.black,
  //             ),
  //             borderRadius: BorderRadius.circular(8),
  //             onChanged: (String? value) {
  //               setState(() {
  //                 MenarcheDropdownValue = value!;
  //                 // checkSex();
  //               });
  //             },
  //             items: MenarcheList.map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }
  Container FamilyPlanning() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Access to  planning?",
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
                    value: "No",
                    groupValue: familyplanningValue,
                    onChanged: (String? value) {
                      setState(() {
                        familyplanningValue = value;
                      });
                    },
                  ),
                  Text("No")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: familyplanningValue,
                    onChanged: (String? value) {
                      setState(() {
                        familyplanningValue = value;
                      });
                    },
                  ),
                  Text("Yes")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container LivingChildren(TextEditingController livingChildrenController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of Living Children",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: livingChildrenController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,3",
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
            "Enter the number of living children",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Abortion(TextEditingController abortionController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of Abortion",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: abortionController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,0",
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
            "Enter the number of abortion",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Premature(TextEditingController prematureController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of Premature",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: prematureController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,0",
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
            "Enter the number of premature",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Parity(TextEditingController parityController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Parity",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: parityController,

              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,3",
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
            "Enter the number of delivery",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Gravida(TextEditingController gravidaController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gravida",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: gravidaController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,3",
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
            "Enter the number of pregnancy",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Menopause() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Menopause?",
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
                    value: "No",
                    groupValue: menopauseValue,
                    onChanged: (String? value) {
                      setState(() {
                        menopauseValue = value;
                      });
                    },
                  ),
                  Text("No")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: menopauseValue,
                    onChanged: (String? value) {
                      setState(() {
                        menopauseValue = value;
                      });
                    },
                  ),
                  Text("Yes")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container DrugsRadio() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Illicit Drugs?",
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
                    value: "No",
                    groupValue: drugsValue,
                    onChanged: (String? value) {
                      setState(() {
                        drugsValue = value;
                      });
                    },
                  ),
                  Text("No")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: drugsValue,
                    onChanged: (String? value) {
                      setState(() {
                        drugsValue = value;
                      });
                    },
                  ),
                  Text("Yes")
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container alcoholRadio() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Do you drink alcohol?",
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
                    value: "No",
                    groupValue: alcoholValue,
                    onChanged: (String? value) {
                      setState(() {
                        alcoholValue = value;
                        bottlePerYearVisibility = false;
                      });
                    },
                  ),
                  Text("No")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: alcoholValue,
                    onChanged: (String? value) {
                      setState(() {
                        alcoholValue = value;
                        bottlePerYearVisibility = true;
                      });
                    },
                  ),
                  Text("Yes")
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container SmokingRadio() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Do you smoke?",
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
                    value: "No",
                    groupValue: smokingValue,
                    onChanged: (String? value) {
                      setState(() {
                        smokingValue = value;
                        packsPerYearVisibility = false;
                      });
                    },
                  ),
                  Text("No")
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: smokingValue,
                    onChanged: (String? value) {
                      setState(() {
                        smokingValue = value;
                        packsPerYearVisibility = true;
                      });
                    },
                  ),
                  Text("Yes")
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Column getList(header, list, addFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
          child: Text(
            "$header",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.9,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Colors.blue,
                    style: BorderStyle.solid,
                    width: 0.50,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(list[index]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: secondaryaccent,
                      ),
                      onPressed: () {
                        // Handle delete button pressed for the item at index
                        // Remove the item from the list or perform any other actions
                        // Here's an example of removing the item:
                        setState(() {
                          list.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
          width: MediaQuery.of(context).size.width / 4.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: Colors.blue,
              style: BorderStyle.solid,
              width: 0.50,
            ),
          ),
          child: TextButton(
            onPressed: addFunction,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Container educationalAttainment() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Highest Completed Educational Attainment",
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
              value: EducationDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: (String? value) {
                setState(() {
                  EducationDropdownValue = value!;
                  // checkSex();
                });
              },
              items:
                  EducationList.map<DropdownMenuItem<String>>((String value) {
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

  Container civilStatus() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Civil Status",
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
              value: CivilStatusDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: (String? value) {
                setState(() {
                  CivilStatusDropdownValue = value!;
                  // checkSex();
                });
              },
              items:
                  CivilStatusList.map<DropdownMenuItem<String>>((String value) {
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

  Container OnsetofIntercourse(TextEditingController onsetController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Onset of Sexual Intercourse",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: onsetController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,18",
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
            "Enter the age of first intercourse",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container IntervalCycle(TextEditingController intervalCycleController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Interval Cycle",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: intervalCycleController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,28",
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
            "Enter how many days is your cycle",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container padsPerDay(TextEditingController padsController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of pads/day",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: padsController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,2",
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
            "Enter pads per day during menstruation",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container periodDuration(TextEditingController periodDurationController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Period Duration",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: periodDurationController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,7",
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
            "Enter how many days your period last",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container fathersName(TextEditingController fatherName) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Father's Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: fatherName,
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
        ],
      ),
    );
  }

  Container mothersName(TextEditingController motherName) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mother's Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: motherName,
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
        ],
      ),
    );
  }

  Container occupation(TextEditingController occupationController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Occupation",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: occupationController,
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
        ],
      ),
    );
  }

  Container religion(TextEditingController religionController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Religion",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: religionController,
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
        ],
      ),
    );
  }

  Container email(TextEditingController emailController) {
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

  Container phoneNumber(TextEditingController contactNumber) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phone Number",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
              ],
              controller: contactNumber,
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
            "Please enter a valid phone number.",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Address(
      TextEditingController streetController,
      TextEditingController cityController,
      TextEditingController provinceController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                child: TextField(
                  controller: streetController,
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
            ],
          ),
        ],
      ),
    );
  }

  Container LastMens(TextEditingController lastMensController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Last Menstruation Period",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 330,
          child: TextField(
            readOnly: true,
            controller: lastMensController,
            decoration: InputDecoration(
                hintText: "Please enter last menstruation period",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                )),
            onTap: () async {
              DateTime date = DateTime(1900);
              FocusScope.of(context).requestFocus(new FocusNode());
              date = (await showDatePicker(
                  context: context,
                  initialDate: DateTime(2021),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100)))!;
              lastMensController.text = DateFormat('yyy-MM-dd').format(date);
            },
          ),
        ),
      ]),
    );
  }

  Container NameWidget(TextEditingController firstname,
      TextEditingController middlename, TextEditingController lastname) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
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

void addIndividualPatient() {}

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
