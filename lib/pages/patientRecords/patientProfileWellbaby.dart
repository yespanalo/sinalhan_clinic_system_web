import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class patientProfileWellbaby extends StatefulWidget {
  const patientProfileWellbaby({required this.uid, Key? key}) : super(key: key);
  final String uid;
  @override
  State<patientProfileWellbaby> createState() => _patientProfileWellbabyState();
}

class _patientProfileWellbabyState extends State<patientProfileWellbaby> {
  String _formatBirthdate(String birthdate) {
    final DateTime parsedDate = DateTime.parse(birthdate);
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(parsedDate);
  }

  String _calculateAge(String birthdate) {
    final DateTime now = DateTime.now();
    final DateTime dateOfBirth = DateTime.parse(birthdate);
    final int age = now.year - dateOfBirth.year;
    return '$age yrs, ';
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
              // Map<String, dynamic> additionalInfo = data["additional info"];
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
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              20.0), // Change the value as needed
                        ),
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 50, left: 50, right: 50),
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
                                          image: AssetImage('images/child.png'),
                                        ),
                                      ),
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
                                          Row(
                                            children: [
                                              Text(
                                                _calculateAge(
                                                    data['birthdate']),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  wordSpacing: 5.0,
                                                ),
                                              ),
                                              Text(
                                                data['gender'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                    wordSpacing: 5.0),
                                              ),
                                              Text(
                                                " · ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                    wordSpacing: 5.0),
                                              ),
                                              Text(
                                                _formatBirthdate(
                                                    data['birthdate']),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  wordSpacing: 5.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            data['mother address'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                wordSpacing: 5.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
