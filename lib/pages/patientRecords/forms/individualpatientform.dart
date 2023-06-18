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

class IndividualPatientRecordForm extends StatefulWidget {
  const IndividualPatientRecordForm({Key? key}) : super(key: key);

  @override
  State<IndividualPatientRecordForm> createState() =>
      _IndividualPatientRecordFormState();
}

class _IndividualPatientRecordFormState
    extends State<IndividualPatientRecordForm> {
  TextEditingController passwordController = new TextEditingController();

  TextEditingController motherName = new TextEditingController();
  TextEditingController fatherName = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController birthdateController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController provinceController = new TextEditingController();
  TextEditingController religionController = new TextEditingController();
  TextEditingController occupationController = new TextEditingController();
  TextEditingController birthcontrolController = new TextEditingController();
  TextEditingController elderImmuController = new TextEditingController();
  TextEditingController pregImmuController = new TextEditingController();
  TextEditingController womenImmuController = new TextEditingController();
  TextEditingController childImmuController = new TextEditingController();
  TextEditingController medhistoryListController = new TextEditingController();
  TextEditingController operationsListController = new TextEditingController();
  TextEditingController diseaseListController = new TextEditingController();
  TextEditingController bottlesController = new TextEditingController();
  TextEditingController packsController = new TextEditingController();
  TextEditingController lastMensController = new TextEditingController();
  TextEditingController periodDurationController = new TextEditingController();
  TextEditingController padsController = new TextEditingController();
  TextEditingController intervalCycleController = new TextEditingController();
  TextEditingController onsetController = new TextEditingController();
  TextEditingController gravidaController = new TextEditingController();
  TextEditingController parityController = new TextEditingController();
  TextEditingController prematureController = new TextEditingController();
  TextEditingController abortionController = new TextEditingController();
  TextEditingController livingChildrenController = new TextEditingController();
  List<String> genderList = <String>['Male', 'Female'];
  late String genderDropdownValue = genderList.first;
  var _text = '';

  List<String> CivilStatusList = <String>[
    'Single',
    'Married',
    'Annuled',
    'Widow/Widower',
    'Separted'
  ];
  late String CivilStatusDropdownValue = CivilStatusList.first;
  List<String> EducationList = <String>[
    'College Degree, Post Graduate',
    'High School',
    'Elementary',
    'Vocational',
    'No Schooling'
  ];
  late String EducationDropdownValue = EducationList.first;

  List<String> MenarcheList = <String>['True', 'False'];
  late String MenarcheDropdownValue = MenarcheList.first;

  String? smokingValue;
  bool packsPerYearVisibility = false;

  String? alcoholValue;
  bool bottlePerYearVisibility = false;

  String? drugsValue;
  String? menopauseValue;
  String? familyplanningValue;

  bool isMale = true;

  List<String> pastMedicalHistoryList = [];
  void addItemToPastMedicalHistory(String newItem) {
    setState(() {
      pastMedicalHistoryList.add(newItem);
    });
  }

  List<String> pastOperationList = [];
  void addItemToPastOperationList(String newItem) {
    setState(() {
      pastOperationList.add(newItem);
    });
  }

  List<String> familyDiseasesList = [];
  void addItemToFamilyDiseasesListList(String newItem) {
    setState(() {
      familyDiseasesList.add(newItem);
    });
  }

  List<String> childrenImmunizationList = [];
  void addItemTochildrenImmunizationList(String newItem) {
    setState(() {
      childrenImmunizationList.add(newItem);
    });
  }

  List<String> youngWomenImmunizationList = [];
  void addItemToyoungWomenImmunizationList(String newItem) {
    setState(() {
      youngWomenImmunizationList.add(newItem);
    });
  }

  List<String> pregnantImmunizationList = [];
  void addItemTopregnantImmunizationList(String newItem) {
    setState(() {
      pregnantImmunizationList.add(newItem);
    });
  }

  List<String> elderlyImmunizationList = [];
  void addItemToelderlyImmunizationList(String newItem) {
    setState(() {
      elderlyImmunizationList.add(newItem);
    });
  }

  List<String> birthControlList = [];
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
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
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

  Future<void> addPictureToStorage(String uid, String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'gs://sinalhan-clinic-system.appspot.com',
    );
    Reference ref = storage.ref().child('$uid.png');

    // Read the image file as Uint8List
    File file = File(imagePath);
    Uint8List imageBytes = await file.readAsBytes();

    // Upload the image data
    TaskSnapshot uploadTask = await ref.putData(imageBytes);

    // Check if the upload is successful
    if (uploadTask.state == TaskState.success) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
  }

  File? _selectedImage;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (result.files.single.bytes != null) {
        setState(() {
          _selectedImage = File.fromRawPath(result.files.single.bytes!);
        });
      }
    }
  }

  void _uploadImage(String uid) async {
    if (_selectedImage != null) {
      try {
        await addPictureToStorage(uid, _selectedImage!.path);
        print('Image uploaded successfully');
      } catch (error) {
        print('Image upload failed: $error');
      }
    } else {
      print('No image selected');
    }
  }

  void uploadpastMedicalList(uid) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    for (String item in pastMedicalHistoryList) {
      DocumentReference documentRef = firestore.collection('patients').doc(uid);
      batch.set(documentRef, {'pastMedicalList': item});
    }

    batch.commit();
  }

  //firebase function
  void addIndividualPatient() async {
    // Set the initials to whatever you want.
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
      'category': "Individual Patient Record",
      'email': emailController.text,
      'contact number': mobileNumber.text,
      'uid': userCredential.user!.uid,
      'address': streetController.text +
          ", " +
          cityController.text +
          ", " +
          provinceController.text,
      'gender': genderDropdownValue,
      'birthdate': birthdateController.text,
      'civil status': CivilStatusDropdownValue,
      'educational attainment': EducationDropdownValue,
      'religion': religionController.text,
      'occupation': occupationController.text,
      'mothers name': motherName.text,
      'fathers name': fatherName.text,
      "additional info": {
        "alcohol": alcoholValue,
        "birth control": birthControlList,
        "elderly immunizations": elderlyImmunizationList,
        "pregnant immunizations": pregnantImmunizationList,
        "women immunizations": youngWomenImmunizationList,
        "children immunizations": childrenImmunizationList,
        "family diseases": familyDiseasesList,
        "past operation": pastOperationList,
        "bottle per year": bottlesController.text,
        "smoking": smokingValue,
        "packs per year": packsController.text,
        "illicit drugs": drugsValue,
        "menopause": menopauseValue,
        "family planning": familyplanningValue,
        "last mens": lastMensController.text,
        "period duration": periodDurationController.text,
        "pads per day": padsController.text,
        "interval cycle": intervalCycleController.text,
        "onset of sexual intercourse": onsetController.text,
        "gravida": gravidaController.text,
        "parity": parityController.text,
        "number of premature": prematureController.text,
        "number of abortion": abortionController.text,
        "number of living children": livingChildrenController.text,
        "pastMedicalList": pastMedicalHistoryList,
        "menarche": MenarcheDropdownValue
      }
    });
    Fluttertoast.showToast(
        msg: "Success!",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // uploadpastMedicalList(userCredential.user!.uid);
    // _uploadImage(userCredential.user!.uid);
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
                      Header(text: "Sign up with email"),
                      email(
                        emailController: emailController,
                      ),
                      password("Enter password"),
                      // Center(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         _selectedImage != null
                      //             ? _selectedImage!.path.split('/').last
                      //             : 'No image selected',
                      //         style: TextStyle(fontSize: 16),
                      //       ),
                      //       SizedBox(height: 20),
                      //       ElevatedButton(
                      //         onPressed: _pickImage,
                      //         child: Text('Select Image'),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Header(
                        text: "General Patient Information",
                      ),
                      NameWidget(
                        nameOf: "Patient Name",
                        firstname: firstName,
                        middlename: middleName,
                        lastname: lastName,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 30, right: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient Birthdate",
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
                                  readOnly: true,
                                  onChanged: (text) => setState(() => _text),
                                  controller: birthdateController,
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
                      patientGender(),
                      Address(
                        streetAddress: streetController,
                        cityAddress: cityController,
                        provinceAddress: provinceController,
                      ),
                      phoneNumber(
                        contactNumber: mobileNumber,
                      ),

                      // NameWidget(
                      //   nameOf: "Father's Name",
                      // ),
                      // NameWidget(
                      //   nameOf: "Mother's Name",
                      // ),
                      civilStatus(),
                      religion(
                        religionController: religionController,
                      ),

                      occupation(
                        occupationController: occupationController,
                      ),
                      educationalAttainment(),
                      mothersName(),
                      fathersName(),
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
                          margin:
                              EdgeInsets.only(left: 30, right: 20, bottom: 10),
                          child: TextField(
                            controller: packsController,
                            decoration: InputDecoration(
                              hintText: "Please enter how many packs per year",
                              contentPadding:
                                  EdgeInsets.only(left: 5, top: 2, bottom: 2),
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
                          margin:
                              EdgeInsets.only(left: 30, right: 20, bottom: 10),
                          child: TextField(
                            controller: bottlesController,
                            decoration: InputDecoration(
                              hintText: "Please enter how bottles per year",
                              contentPadding:
                                  EdgeInsets.only(left: 5, top: 2, bottom: 2),
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
                        () => _showAddItemDialog("childrenImmunizations"),
                      ),
                      Visibility(
                        visible: !isMale,
                        child: getList(
                          "Please list if there are young women immunizations received",
                          youngWomenImmunizationList,
                          () => _showAddItemDialog("youngWomenImmunization"),
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
                        "Please list if there are children immunizations received",
                        elderlyImmunizationList,
                        () => _showAddItemDialog("elderlyImmunizations"),
                      ),

                      Visibility(
                        visible: !isMale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Header(text: "Menstrual History"),
                            Menarche(),
                            LastMens(lastMensController: lastMensController),
                            periodDuration(),
                            padsPerDay(),
                            IntervalCycle(),
                            OnsetofIntercourse(),
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
                            Gravida(),
                            Parity(),
                            Premature(),
                            Abortion(),
                            LivingChildren(),
                            FamilyPlanning(),
                            // Header(
                            //     text: "Patient Physical Examination Findings"),
                            // BloodPressure(),
                            // HeartRate(),
                            // RespiratoryRate(),
                            // Height(),
                            // Weight(),
                            // WaistCircumference(),
                          ],
                        ),
                      ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryaccent),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
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
          ],
        ),
      )),
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

  Container password(
    text,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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

  Container mothersName() {
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

  Container fathersName() {
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

  Container WaistCircumference() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Waist Circumference",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  suffixText: "cm",
                  hintText: "e.g.,40 cm",
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

  Container Height() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Height",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
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

  Container RespiratoryRate() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Respiratory Rate",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  suffixText: "BPM",
                  hintText: "e.g.,16 BPM",
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

  Container HeartRate() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Heart Rate",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], //
              decoration: InputDecoration(
                  suffixText: "BPM",
                  hintText: "e.g.,60 BPM",
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

  Container BloodPressure() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Blood Pressure",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              ], //
              decoration: InputDecoration(
                  hintText: "e.g.,120/70",
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

  Container LivingChildren() {
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

  Container Abortion() {
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

  Container Premature() {
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

  Container Parity() {
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

  Container Gravida() {
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

  Container OnsetofIntercourse() {
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

  Container IntervalCycle() {
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

  Container padsPerDay() {
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

  Container periodDuration() {
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

  Container Menarche() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Menarche",
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
              value: MenarcheDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
              onChanged: (String? value) {
                setState(() {
                  MenarcheDropdownValue = value!;
                  // checkSex();
                });
              },
              items: MenarcheList.map<DropdownMenuItem<String>>((String value) {
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
}

class LastMens extends StatelessWidget {
  const LastMens({
    Key? key,
    required this.lastMensController,
  }) : super(key: key);

  final TextEditingController lastMensController;

  @override
  Widget build(BuildContext context) {
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
}

class patiendMedicalHistory extends StatelessWidget {
  const patiendMedicalHistory(
      {Key? key, required this.heading, required this.controller})
      : super(key: key);

  final String heading;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$heading",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            width: double.infinity,
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.top,
              expands: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5, top: 2, bottom: 2),
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
}

class occupation extends StatelessWidget {
  const occupation({
    Key? key,
    required this.occupationController,
  }) : super(key: key);
  final TextEditingController occupationController;

  @override
  Widget build(BuildContext context) {
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
}

class religion extends StatelessWidget {
  const religion({
    Key? key,
    required this.religionController,
  }) : super(key: key);

  final TextEditingController religionController;

  @override
  Widget build(BuildContext context) {
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
}

class Address extends StatelessWidget {
  const Address({
    Key? key,
    required this.streetAddress,
    required this.cityAddress,
    required this.provinceAddress,
  }) : super(key: key);

  final TextEditingController streetAddress;
  final TextEditingController cityAddress;
  final TextEditingController provinceAddress;

  @override
  Widget build(BuildContext context) {
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
                  controller: streetAddress,
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
                "Street Address",
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 330,
                        height: 40,
                        child: TextField(
                          controller: cityAddress,
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
                        "City",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 330,
                        height: 40,
                        child: TextField(
                          controller: provinceAddress,
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
                        "Province",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ],
              ),
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
      required this.nameOf,
      required this.firstname,
      required this.middlename,
      required this.lastname})
      : super(key: key);

  final String nameOf;
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
          Text(
            "$nameOf",
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
