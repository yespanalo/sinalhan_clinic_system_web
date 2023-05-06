import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

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
                                      "Individual Patient Record",
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
                                    TextButton(
                                      child: Text(
                                        "View More",
                                        style:
                                            TextStyle(color: secondaryaccent),
                                      ),
                                      onPressed: () {},
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
                                    )
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
                  Informations(reason, "Reason of Visit"),
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
      height: MediaQuery.of(context).size.height / 2,
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
