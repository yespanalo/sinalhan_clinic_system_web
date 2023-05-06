import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinalhan_clinic_system_web/function/firebaseFunctions.dart';
import 'package:intl/intl.dart';

class IndividualPatientRecordForm extends StatefulWidget {
  const IndividualPatientRecordForm({Key? key}) : super(key: key);

  @override
  State<IndividualPatientRecordForm> createState() =>
      _IndividualPatientRecordFormState();
}

class _IndividualPatientRecordFormState
    extends State<IndividualPatientRecordForm> {
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

  //firebase function
  void addIndividualPatient() async {
    String initials = 'IPR'; // Set the initials to whatever you want.
    String customID =
        '$initials-${FirebaseFirestore.instance.collection('patients').doc().id}';
    await FirebaseFirestore.instance.collection('patients').doc(customID).set({
      'first name': firstName.text,
      'last name': lastName.text,
      'middle name': middleName.text,
      'category': "Individual Patient Record",
      'email': emailController.text,
      'contact number': mobileNumber.text,
      'uid': customID,
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
    });
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
                BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
                      email(
                        emailController: emailController,
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
                      Header(
                        text: "Patient Medical History",
                      ),
                      patiendMedicalHistory(
                        heading: "Please list past medical history",
                      ),
                      patiendMedicalHistory(
                        heading: "Please list any Operations and Dates of Each",
                      ),
                      patiendMedicalHistory(
                        heading:
                            "Please list any diseases that run in the family",
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
                      patiendMedicalHistory(
                        heading:
                            "Please list if there are children immunizations received",
                      ),
                      Visibility(
                        visible: !isMale,
                        child: patiendMedicalHistory(
                          heading:
                              "Please list if there are young women immunizations received",
                        ),
                      ),
                      Visibility(
                        visible: !isMale,
                        child: patiendMedicalHistory(
                          heading:
                              "Please list if there are immunizations for pregnant received",
                        ),
                      ),
                      patiendMedicalHistory(
                        heading:
                            "Please list if there are immunizations for elderly received",
                      ),
                      Visibility(
                        visible: !isMale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Header(text: "Menstrual History"),
                            Menarche(),
                            LastMens(),
                            periodDuration(),
                            padsPerDay(),
                            IntervalCycle(),
                            OnsetofIntercourse(),
                            patiendMedicalHistory(
                                heading:
                                    "Please list birth control method if there is any"),
                            Menopause(),
                          ],
                        ),
                      ),
                      Header(text: "Pregnancy History"),
                      Gravida(),
                      Parity(),
                      Premature(),
                      Abortion(),
                      LivingChildren(),
                      FamilyPlanning(),
                      Header(text: "Patient Physical Examination Findings"),
                      BloodPressure(),
                      HeartRate(),
                      RespiratoryRate(),
                      Height(),
                      Weight(),
                      WaistCircumference(),
                      TextButton(
                          onPressed: () {
                            addIndividualPatient();
                            Navigator.pop(context);
                          },
                          child: Text("Add"))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
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
          "Access to family planning?",
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
  }) : super(key: key);

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
              // fathersBirthdateController.text =
              //     DateFormat('yyy-MM-dd').format(date);
            },
          ),
        ),
      ]),
    );
  }
}

class patiendMedicalHistory extends StatelessWidget {
  const patiendMedicalHistory({Key? key, required this.heading})
      : super(key: key);

  final String heading;

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
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient E-Mail",
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
