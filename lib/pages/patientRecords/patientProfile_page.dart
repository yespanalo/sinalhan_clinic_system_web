import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';
import 'dart:io';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class PatientProfiel extends StatefulWidget {
  const PatientProfiel({
    required this.uid,
    super.key,
  });

  final String uid;
  @override
  State<PatientProfiel> createState() => _PatientProfielState();
}

class _PatientProfielState extends State<PatientProfiel> {
  late Future<DocumentSnapshot> _userDataFuture;
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  TextEditingController diagnosis = new TextEditingController();
  TextEditingController recommend = new TextEditingController();
  TextEditingController visitDateController = new TextEditingController();
  TextEditingController reasonController = new TextEditingController();

  bool moreInfoVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userDataFuture =
        FirebaseFirestore.instance.collection('patients').doc(widget.uid).get();
  }

  Future<Widget> _getImageWidget() async {
    FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'gs://sinalhan-clinic-system.appspot.com',
    );
    Reference ref = storage.ref().child(widget.uid + '.png');
    String downloadUrl = await ref.getDownloadURL();

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(downloadUrl),
        ),
      ),
    );
  }

  Future<TaskSnapshot?> addPictureToStorage(
      String uid, String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('$uid.png');

    // Read the image file
    File file = File(imagePath);
    TaskSnapshot? uploadTask;

    try {
      uploadTask = await ref.putFile(file);

      // Check if the upload is successful
      if (uploadTask.state == TaskState.success) {
        return uploadTask;
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        await addPictureToStorage(widget.uid, _selectedImage!.path);
        print('Image uploaded successfully');
      } catch (error) {
        print('Image upload failed: $error');
      }
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 216, 216, 216),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('patients')
            .doc(widget.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text('No Data Found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            // Object? data = snapshot.data?.data();
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          BackButton(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Barangay Sinalhan Clinic",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Mont",
                                    fontSize: 24,
                                    color: Color(0xff1B1C1E)),
                              ),
                              Text(
                                "Patient Records",
                                style: TextStyle(
                                    fontFamily: "Mont",
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20.0), // Change the value as needed
                      ),
                      width: MediaQuery.of(context).size.width / 1.5,
                      // height: MediaQuery.of(context).size.height / 1,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 50, left: 50, right: 50),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<Widget>(
                                    future: _getImageWidget(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Widget> snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'images/place.jpg'),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          // data['gender'].toString(),
                                          data['first name'] +
                                              " " +
                                              data['last name'],
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              wordSpacing: 5.0),
                                        ),
                                        Text(
                                          "26 yrs, female · March 24, 1997",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              wordSpacing: 5.0),
                                        ),
                                        Text(
                                          "#61, Marinig Cabuyao Laguna",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              wordSpacing: 5.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        FontAwesomeIcons.edit,
                                        color: secondaryaccent,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: secondaryaccent,
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 50, right: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "General Information".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 5.0),
                                    ),
                                    Text(
                                      data['category'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Informations(data['civil status'],
                                                "Civil Status"),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Informations(
                                                data['email'], "Email"),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Informations(data['fathers name'],
                                                "Father's Name"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Informations(
                                                data['religion'], "Religion"),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Informations(
                                                data['educational attainment'],
                                                "Educational Attainment"),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Informations(data['mothers name'],
                                                "Mother's Name"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Informations(data['contact number'],
                                                "Contact number"),
                                            SizedBox(height: 40),
                                            Informations(data['occupation'],
                                                "Occupation"),
                                            SizedBox(height: 40),
                                            Informations(
                                                data['gender'].toString(),
                                                "Gender")
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Visibility(
                                      visible: moreInfoVisible,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Healthy & Unhealthy Habits"
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                                wordSpacing: 5.0),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Informations(data['smoking'],
                                                      "Smoking"),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Informations(data['alcohol'],
                                                      "Drinking Alcohol"),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Informations(
                                                      data['illicit drugs'],
                                                      "Illicit Drugs"),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Informations(data['religion'],
                                                      "Religion"),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Informations(
                                                      data[
                                                          'educational attainment'],
                                                      "Educational Attainment"),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Informations(
                                                      data['mothers name'],
                                                      "Mother's Name"),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Informations(
                                                      data['contact number'],
                                                      "Contact number"),
                                                  SizedBox(height: 40),
                                                  Informations(
                                                      data['occupation'],
                                                      "Occupation"),
                                                  SizedBox(height: 40),
                                                  Informations(
                                                      data['gender'].toString(),
                                                      "Gender"),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        moreInfoVisible == false
                                            ? "View More"
                                            : "Show Less",
                                        style:
                                            TextStyle(color: secondaryaccent),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          moreInfoVisible = !moreInfoVisible;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: secondaryaccent,
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 50, right: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Visit History",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 5.0),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    VisitHistoryList(
                                      patientId: data['uid'],
                                      patientName: data['first name'],
                                    ),
                                    Text(
                                      "Upcoming Visit",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 5.0),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    UpcomingVisitList(
                                      patientId: data['uid'],
                                      patientName: data['first name'],
                                      patientCategory: data['category'],
                                      diagnosis: diagnosis,
                                      recommend: recommend,
                                      visitDateController: visitDateController,
                                      reasonController: reasonController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Column Informations(value, key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value == null ? "N/A" : "$value",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              wordSpacing: 5.0),
        ),
        SizedBox(height: 10),
        Text(
          "$key",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    );
  }
}

class VisitHistoryDialog extends StatelessWidget {
  final String patientId;
  final String visitId;
  final String visitDate;
  final String patientName;

  VisitHistoryDialog(
      {required this.patientId,
      required this.visitId,
      required this.visitDate,
      required this.patientName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Visit History Details',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            wordSpacing: 5.0),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('patients')
                    .doc(patientId)
                    .collection('visit history')
                    .doc(visitId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data() == null) {
                    return Center(child: Text('No Data Found'));
                  } else {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Divider(
                          color: secondaryaccent,
                          thickness: 2,
                        ),
                        Information("Patient name: ", patientName),
                        Information(
                            "Reason of visit: ", data['reason of visit']),
                        Information("Visit date: ", visitDate),
                        Information("Diagnosis: ", data['diagnosis']),
                        Information("Recommendation: ", data['instruction'])
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(color: secondaryaccent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Row Information(String header, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              wordSpacing: 5.0),
        ),
        Container(
          width: 500,
          child: Text(
            value,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, wordSpacing: 5.0),
          ),
        ),
      ],
    );
  }
}

class VisitHistoryList extends StatelessWidget {
  final String patientId;
  final String patientName;

  VisitHistoryList({required this.patientId, required this.patientName});

  Widget VisitHistoryCard(BuildContext context, DocumentSnapshot visitHistory) {
    Object visitData = visitHistory.data()!;
    var visitTimestamp =
        (visitData as Map<String, dynamic>)?['visit date'] as Timestamp?;
    var visitDateTime = visitTimestamp?.toDate();
    var formattedDate = DateFormat('MMMM d, y').format(visitDateTime!);

    var visitDay = visitDateTime?.day.toString() ?? '';
    var visitMonth =
        visitDateTime != null ? DateFormat('MMMM').format(visitDateTime) : '';
    var visitYear = visitDateTime?.year.toString() ?? '';
    var visitDayOfWeek =
        visitDateTime != null ? DateFormat('EEEE').format(visitDateTime) : '';
    var reason = (visitData as Map<String, dynamic>)?['reason of visit'] ?? '';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Future.delayed(Duration(milliseconds: 100)).then(
            (value) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Builder(
                    builder: (context) {
                      return VisitHistoryDialog(
                          patientId: patientId,
                          visitId: visitData['visit id'],
                          visitDate: formattedDate,
                          patientName: patientName);
                    },
                  );
                },
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.only(left: 50, right: 50),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 243, 243, 243),
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Informations(
                      reason.toString().toUpperCase(), "Reason of Visit"),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    visitDay,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    visitMonth.toUpperCase() + " " + visitYear.toUpperCase(),
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: secondaryaccent),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    visitDayOfWeek,
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column Informations(value, key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$value",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              wordSpacing: 5.0),
        ),
        SizedBox(height: 10),
        Text(
          "$key",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .collection('visit history')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text("No data found");
          }
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                snapshot.data!.docs.length,
                (index) {
                  DocumentSnapshot visitHistory = snapshot.data!.docs[index];
                  return VisitHistoryCard(context, visitHistory);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpcomingVisitDialog extends StatelessWidget {
  final String patientId;
  final String visitId;
  final String visitDate;
  final String patientName;
  final TextEditingController Diagnosiscontroller;
  final TextEditingController Recommendationcontroller;
  final Timestamp? visitDateTime;

  String reasonofVisit = "";

  UpcomingVisitDialog(
      {required this.patientId,
      required this.visitId,
      required this.visitDate,
      required this.patientName,
      required this.Diagnosiscontroller,
      required this.Recommendationcontroller,
      required this.visitDateTime});

  Column DiagnosisAndRecommendation(
      BuildContext context, String header, TextEditingController Controller) {
    String _text = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                wordSpacing: 5.0)),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            controller: Controller,
            textAlignVertical: TextAlignVertical.top,
            expands: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 5, top: 2, bottom: 2),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Upcoming Visit',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            wordSpacing: 5.0),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('patients')
                    .doc(patientId)
                    .collection('appointments')
                    .doc(visitId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data() == null) {
                    return Column(
                      children: [
                        Text('No Data Found'),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  } else {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    reasonofVisit = data['reason of visit'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Divider(
                          color: secondaryaccent,
                          thickness: 2,
                        ),
                        Information("Patient name: ", patientName),
                        Information(
                            "Reason of visit: ", data['reason of visit']),
                        DiagnosisAndRecommendation(
                            context, 'Diagnosis', Diagnosiscontroller),
                        DiagnosisAndRecommendation(
                            context, 'Recommendation', Recommendationcontroller)
                        // Information("Visit date: ", visitDate),
                        // Information("Diagnosis: ", data['diagnosis']),
                        // Information("Recommendation: ", data['instruction'])
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              var doc = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(patientId)
                  .collection('visit history')
                  .doc();
              await doc.set({
                'diagnosis': Diagnosiscontroller.text,
                'instruction': Recommendationcontroller.text,
                'reason of visit': reasonofVisit,
                'visit date': visitDateTime,
                'visit id': doc.id
              });

              var markAsDone = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(patientId)
                  .collection('appointments')
                  .doc(visitId);
              await markAsDone.delete();

              Fluttertoast.showToast(
                  msg: "Success!",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Diagnosiscontroller.text = "";
              Recommendationcontroller.text = "";
              Navigator.pop(context);
            },
            child: Text("Mark as done")),
        TextButton(
            onPressed: () async {
              var markAsDone = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(patientId)
                  .collection('appointments')
                  .doc(visitId);
              await markAsDone.delete();

              Fluttertoast.showToast(
                  msg: "Success!",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Diagnosiscontroller.text = "";
              Recommendationcontroller.text = "";
              Navigator.pop(context);
            },
            child: Text(
              "Did not come",
              style: TextStyle(color: Colors.green),
            )),
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(color: secondaryaccent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Row Information(String header, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              wordSpacing: 5.0),
        ),
        Container(
          width: 500,
          child: Text(
            value,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, wordSpacing: 5.0),
          ),
        ),
      ],
    );
  }
}

class UpcomingVisitList extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String patientCategory;
  final TextEditingController diagnosis;
  final TextEditingController recommend;
  final TextEditingController visitDateController;
  final TextEditingController reasonController;

  UpcomingVisitList({
    required this.patientId,
    required this.patientName,
    required this.patientCategory,
    required this.diagnosis,
    required this.recommend,
    required this.visitDateController,
    required this.reasonController,
  });

  Widget UpcomingVisitCard(
      BuildContext context, DocumentSnapshot upcomingVisit) {
    Object upcomingVisitData = upcomingVisit.data()!;
    var visitTimestamp = (upcomingVisitData
        as Map<String, dynamic>)?['visit date'] as Timestamp?;
    var visitDateTime = visitTimestamp?.toDate();
    var formattedDate = DateFormat('MMMM d, y').format(visitDateTime!);

    var visitDay = visitDateTime?.day.toString() ?? '';
    var visitMonth =
        visitDateTime != null ? DateFormat('MMMM').format(visitDateTime) : '';
    var visitYear = visitDateTime?.year.toString() ?? '';
    var visitDayOfWeek =
        visitDateTime != null ? DateFormat('EEEE').format(visitDateTime) : '';
    var reason =
        (upcomingVisitData as Map<String, dynamic>)?['reason of visit'] ?? '';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Future.delayed(Duration(milliseconds: 100)).then((value) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Builder(builder: (context) {
                    return UpcomingVisitDialog(
                      patientId: patientId,
                      visitId: upcomingVisitData['visit id'],
                      visitDate: formattedDate,
                      patientName: patientName,
                      Diagnosiscontroller: diagnosis,
                      Recommendationcontroller: recommend,
                      visitDateTime: visitTimestamp,
                    );
                  });
                });
          });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 50, right: 50),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: primaryaccent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Informations(
                      reason.toString().toUpperCase(), "Reason of Visit"),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    visitDay,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    visitMonth.toUpperCase() + " " + visitYear.toUpperCase(),
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    visitDayOfWeek,
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column Informations(value, key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$value",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              wordSpacing: 5.0),
        ),
        SizedBox(height: 10),
        Text(
          "$key",
          style: TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .collection('appointments')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Builder(builder: (context) {
                          return ScheduleVisitDialog(
                            patientId: patientId,
                            patientName: patientName,
                            visitDateController: visitDateController,
                            reasonController: reasonController,
                            patientCategory: patientCategory,
                          );
                        });
                      });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: primaryaccent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                snapshot.data!.docs.length,
                (index) {
                  DocumentSnapshot visitHistory = snapshot.data!.docs[index];
                  return UpcomingVisitCard(context, visitHistory);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScheduleVisitDialog extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientCategory;
  final TextEditingController reasonController;
  final TextEditingController visitDateController;

  ScheduleVisitDialog(
      {required this.patientId,
      required this.patientName,
      required this.reasonController,
      required this.visitDateController,
      required this.patientCategory});

  @override
  State<ScheduleVisitDialog> createState() => _ScheduleVisitDialogState();
}

class _ScheduleVisitDialogState extends State<ScheduleVisitDialog> {
  DateTime? selectedDate;

  void _handleDateSelected(DateTime? date) {
    setState(() {
      selectedDate = date;
    });
  }

  var _text = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Schedule a Visit',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            wordSpacing: 5.0),
      ),
      content: SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: secondaryaccent,
                  thickness: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reason of Visit",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 40,
                      child: TextField(
                        controller: widget.reasonController,
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date of Visit",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.patientCategory ==
                            "Individual Patient Record")
                          Container(
                            child:
                                DateSelectionContainerIndividualPatientRecord(
                              onDateSelected: _handleDateSelected,
                            ),
                          ),
                        if (widget.patientCategory == "Well-Baby Record")
                          Container(
                            child: DateSelectionContainerWellBabyRecord(
                              onDateSelected: _handleDateSelected,
                            ),
                          ),
                        if (widget.patientCategory == "Pre-Natal Record")
                          Container(
                            child: DateSelectionContainerPrenatalRecord(
                              onDateSelected: _handleDateSelected,
                            ),
                          ),
                      ]),
                ),
              ],
            ),
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final dateFormat = DateFormat('yyyy-MM-dd');
            final dateString = dateFormat.format(selectedDate!);
            final dateTime = dateFormat.parse(dateString);
            final timestamp = Timestamp.fromDate(dateTime);

            var doc = await FirebaseFirestore.instance
                .collection('patients')
                .doc(widget.patientId)
                .collection('appointments')
                .doc();
            await doc.set({
              'reason of visit': widget.reasonController.text,
              'visit date': timestamp,
              'visit id': doc.id
            });

            Fluttertoast.showToast(
                msg: "Success!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            widget.reasonController.text = "";
            widget.visitDateController.text = "";
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(color: secondaryaccent),
          ),
          onPressed: () {
            widget.reasonController.text = "";
            widget.visitDateController.text = "";
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DateSelectionContainerIndividualPatientRecord extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  DateSelectionContainerIndividualPatientRecord({required this.onDateSelected});

  @override
  _DateSelectionContainerIndividualPatientRecordState createState() =>
      _DateSelectionContainerIndividualPatientRecordState();
}

class _DateSelectionContainerIndividualPatientRecordState
    extends State<DateSelectionContainerIndividualPatientRecord> {
  DateTime? selectedDate;

  List<DropdownMenuItem<String>> _generateDates() {
    DateTime currentDate = DateTime.now();

    List<DropdownMenuItem<String>> items = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 1; j <= 7; j++) {
        DateTime date = currentDate.add(Duration(days: i * 7 + j));

        if (date.weekday == DateTime.monday ||
            date.weekday == DateTime.tuesday) {
          String formattedDate = DateFormat('MMMM d, y').format(date);
          String identifier = DateFormat('yyyy-MM-dd').format(date);
          items.add(
            DropdownMenuItem<String>(
              value: identifier,
              child: Text(formattedDate),
            ),
          );
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
        items: _generateDates(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              selectedDate = DateTime.parse(value);
            });
            widget.onDateSelected(selectedDate);
          }
        },
        hint: Text('Select a date'),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}

class DateSelectionContainerWellBabyRecord extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  DateSelectionContainerWellBabyRecord({required this.onDateSelected});

  @override
  _DateSelectionContainerWellBabyRecordState createState() =>
      _DateSelectionContainerWellBabyRecordState();
}

class _DateSelectionContainerWellBabyRecordState
    extends State<DateSelectionContainerWellBabyRecord> {
  DateTime? selectedDate;

  List<DropdownMenuItem<String>> _generateDates() {
    DateTime currentDate = DateTime.now();

    List<DropdownMenuItem<String>> items = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 1; j <= 7; j++) {
        DateTime date = currentDate.add(Duration(days: i * 7 + j));

        if (date.weekday == DateTime.wednesday) {
          String formattedDate = DateFormat('MMMM d, y').format(date);
          String identifier = DateFormat('yyyy-MM-dd').format(date);
          items.add(
            DropdownMenuItem<String>(
              value: identifier,
              child: Text(formattedDate),
            ),
          );
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
        items: _generateDates(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              selectedDate = DateTime.parse(value);
            });
            widget.onDateSelected(selectedDate);
          }
        },
        hint: Text('Select a date'),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}

class DateSelectionContainerPrenatalRecord extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  DateSelectionContainerPrenatalRecord({required this.onDateSelected});

  @override
  _DateSelectionContainerPrenatalRecordState createState() =>
      _DateSelectionContainerPrenatalRecordState();
}

class _DateSelectionContainerPrenatalRecordState
    extends State<DateSelectionContainerPrenatalRecord> {
  DateTime? selectedDate;

  List<DropdownMenuItem<String>> _generateDates() {
    DateTime currentDate = DateTime.now();

    List<DropdownMenuItem<String>> items = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 1; j <= 7; j++) {
        DateTime date = currentDate.add(Duration(days: i * 7 + j));

        if (date.weekday == DateTime.thursday) {
          String formattedDate = DateFormat('MMMM d, y').format(date);
          String identifier = DateFormat('yyyy-MM-dd').format(date);
          items.add(
            DropdownMenuItem<String>(
              value: identifier,
              child: Text(formattedDate),
            ),
          );
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
        items: _generateDates(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              selectedDate = DateTime.parse(value);
            });
            widget.onDateSelected(selectedDate);
          }
        },
        hint: Text('Select a date'),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}
