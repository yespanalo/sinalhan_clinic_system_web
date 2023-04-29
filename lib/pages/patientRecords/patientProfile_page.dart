import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sinalhan_clinic_management/constants.dart';

class PatientProfiel extends StatefulWidget {
  const PatientProfiel({
    super.key,
  });

  // final String uid;
  @override
  State<PatientProfiel> createState() => _PatientProfielState();
}

class _PatientProfielState extends State<PatientProfiel> {
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
    // userData();
  }

  // late String patientName = "";
  // void userData() async {
  //   final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('patients')
  //       .doc(widget.uid)
  //       .get();
  //   final Map<String, dynamic>? data = snapshot.data() as Map<String,
  //       dynamic>?; // Move the "as" keyword outside of the parentheses
  //   setState(() {
  //     patientName = data?['first name'] ?? '';
  //   });
  //   // Using the null-aware operator and providing a default value
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 216, 216, 216),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                color: Colors.white,
                child: Row(
                  children: [
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
                  borderRadius:
                      BorderRadius.circular(20.0), // Change the value as needed
                ),
                width: MediaQuery.of(context).size.width / 1.5,
                // height: MediaQuery.of(context).size.height / 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("images/mina.jpg"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Mina Sharon Myoi".toUpperCase(),
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
                                      Informations("Single", "Civil Satus"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Informations(
                                          "minariMiyoui@gmail.com", "Email"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Informations(
                                          "Akira Myoui", "Father's Name"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Informations(
                                          "Roman Catholic", "Religion"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Informations("College Graduate",
                                          "Educational Attainment"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Informations(
                                          "Myoui Sachiko", "Mother's Name"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Informations("09690118897", "Address"),
                                      SizedBox(height: 40),
                                      Informations("Kpop Artist", "Occupation"),
                                      SizedBox(height: 40),
                                      Informations("Female", "Gender")
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
                                  style: TextStyle(color: secondaryaccent),
                                ),
                                onPressed: () {},
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
                              VisitHistoryCard(context)
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
      ),
    );
  }

  MouseRegion VisitHistoryCard(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(left: 50, right: 50),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 243, 243, 243),
            borderRadius:
                BorderRadius.circular(20.0), // Change the value as needed
          ),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Informations("Hyperacidity", "Reason of Visit"),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "22",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "April 2023".toUpperCase(),
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: secondaryaccent),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Monday",
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
}
