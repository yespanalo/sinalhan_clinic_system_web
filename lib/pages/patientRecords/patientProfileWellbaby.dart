import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../constants copy.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVaccineDocuments() async {
    // Reference the "patients" collection
    CollectionReference patientsCollection =
        FirebaseFirestore.instance.collection('patients');

    // Reference the specific patient document
    DocumentReference patientDocRef = patientsCollection.doc(widget.uid);

    // Reference the "vaccine" subcollection within the patient document
    CollectionReference vaccineCollection =
        patientDocRef.collection('vaccines');

    // Fetch all the documents in the "vaccine" subcollection
    return vaccineCollection.get()
        as Future<QuerySnapshot<Map<String, dynamic>>>;
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
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           IndividualPatientEditForm(
                                          //               uid: widget.uid)),
                                          // );
                                        },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              Informations(
                                                  data['place of delivery'],
                                                  "Place of Delivery"),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Informations(
                                                  data['type of delivery'],
                                                  "Type of Delivery"),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Informations(
                                                  _formatBirthdate(
                                                      data['birthdate']),
                                                  "Birthdate"),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Informations(
                                                  data['length'] + " cm",
                                                  "Birth lenght"),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Informations(
                                                  data['weight'] + " kg",
                                                  "Birth Weight"),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Informations(
                                                  data['gender'].toString(),
                                                  "Gender")
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
                                                  "Mother's contact"),
                                              SizedBox(height: 40),
                                              Informations(
                                                  _calculateAge(
                                                      data['mother birthday']),
                                                  "Mother's Age"),
                                              SizedBox(height: 40),
                                              Informations(data['mother name'],
                                                  "Mother's Name"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            // await generatePDF(data["uid"]);
                                            // print('PDF generated');
                                          },
                                          child: Text("Download PDF"))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Vaccine Check List",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            wordSpacing: 5.0),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: 500,
                                        child: FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          future: fetchVaccineDocuments(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // While data is being fetched, display a loading indicator
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              // If an error occurs during fetching, display an error message
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              // If data is successfully fetched, display the documents
                                              List<
                                                      QueryDocumentSnapshot<
                                                          Map<String, dynamic>>>
                                                  vaccineDocuments =
                                                  snapshot.data!.docs;
                                              return ListView.builder(
                                                itemCount:
                                                    vaccineDocuments.length,
                                                itemBuilder: (context, index) {
                                                  // Access the data of each document
                                                  Map<String, dynamic> data =
                                                      vaccineDocuments[index]
                                                          .data();
                                                  // Process the data as needed and display it
                                                  return ListTile(
                                                    title: Container(
                                                      child: Row(
                                                        children: [
                                                          Text(data[
                                                              'vaccine name']),
                                                          Text(data[
                                                              'vaccine date'])
                                                        ],
                                                      ),
                                                    ),

                                                    // ... Other fields and widgets for displaying the data
                                                  );
                                                },
                                              );
                                            } else {
                                              // If no data is available, display a message
                                              return Text(
                                                  'No documents found.');
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
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
