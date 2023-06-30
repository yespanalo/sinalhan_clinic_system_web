import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import '../../constants copy.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/services.dart' as flutterServices;
import 'dart:html' as html;

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

  Future<pdfWidgets.Widget> addImage(
      pdfWidgets.Document pdf, String filename) async {
    final imageByteData = await rootBundle.load('$filename');
    final imageUint8List = imageByteData.buffer
        .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    final image = pdfWidgets.MemoryImage(imageUint8List);

    return pdfWidgets.Center(
      child: pdfWidgets.Image(image),
    );
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy, hh:mm a');
    return formatter.format(now);
  }

  Future<void> generatePDF(String documentId) async {
    final pdf = pw.Document();
    final headerImage = await addImage(pdf, 'images/sinalhanLogo.png');

    // Retrieve the specific patient document from Firestore
    final patientDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(documentId)
        .get();
    if (patientDoc.exists) {
      final patientData = patientDoc.data();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pdfWidgets.Row(children: [
                pdfWidgets.Container(width: 50, height: 50, child: headerImage),
                pdfWidgets.SizedBox(width: 20),
                pdfWidgets.Column(
                  crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                  children: [
                    pdfWidgets.Container(
                      child: pdfWidgets.Text(
                        'Barangay Sinalhan Clinic',
                        style: pdfWidgets.TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    pdfWidgets.Text(
                      'Patient Profile',
                      style: pdfWidgets.TextStyle(
                        fontSize: 20.0,
                        fontWeight: pdfWidgets.FontWeight.bold,
                      ),
                    ),
                    pdfWidgets.Text(
                      'Generated on: ${_getFormattedDate()}',
                      style: pdfWidgets.TextStyle(
                        fontSize: 10.0,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ]),
              pw.SizedBox(height: 30),
              pw.Text('Name: ' +
                  patientData!['first name'] +
                  " " +
                  patientData["last name"]),
              pw.SizedBox(height: 10),
              pw.Text('Category: ' + patientData!['category']),
              pw.SizedBox(height: 10),
              pw.Text('Birthdate: ' + patientData!['birthdate']),
              pw.SizedBox(height: 10),
              pw.Text('Gender: ' + patientData!['gender']),
              pw.SizedBox(height: 10),
              pw.Text('Birth Weight: ' + patientData!['gender']),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Place of Delivery: ' + patientData!['place of delivery']),
              pw.SizedBox(height: 10),
              pw.Text('Type of Delivery: ' + patientData!['type of delivery']),
              pw.SizedBox(height: 10),
              pw.Text('Attended By: ' + patientData!['attended by']),
              pw.SizedBox(height: 10),
              pw.Text('Mother\'s Name: ' + patientData!['mother name']),
              pw.SizedBox(height: 10),
              pw.Text('Mother\'s Address: ' + patientData!['mother address']),
              pw.SizedBox(height: 10),
              pw.Text('Mother\'s Contact Number: ' +
                  patientData!['contact number']),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Mother\'s Birthdate: ' + patientData!['mother birthday']),
            ],
          );
        },
      ));

      // Save the PDF file
      final bytes = await pdf.save();

      // Convert the bytes to Blob
      final blob = html.Blob([bytes], 'application/pdf');

      // Create a download URL
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element with the download URL
      final anchor = html.AnchorElement()
        ..href = url
        ..download = 'patient_$documentId.pdf';

      // Programmatically click the anchor to trigger the download
      anchor.click();

      // Clean up the temporary objects
      html.Url.revokeObjectUrl(url);
    } else {
      print('Patient document not found');
    }
  }

  pw.Row pdfRow(Map<String, dynamic> additionalInfo, String title,
      String condition, String value) {
    return pw.Row(
      children: [
        pw.Text(title),
        pw.SizedBox(width: 20),
        condition != "" ? pw.Text(value) : pw.SizedBox(height: 0, width: 0),
      ],
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
                                            await generatePDF(data["uid"]);
                                            print('PDF generated');
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
                                      FutureBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
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

                                            return SingleChildScrollView(
                                              child: Container(
                                                height: 250,
                                                child: ListView.builder(
                                                  itemCount:
                                                      vaccineDocuments.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Map<String, dynamic> data =
                                                        vaccineDocuments[index]
                                                            .data();

                                                    return Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                            data[
                                                                'vaccine name'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            data['vaccine date'] !=
                                                                        null &&
                                                                    data['vaccine date'] !=
                                                                        ""
                                                                ? data[
                                                                    'vaccine date']
                                                                : "Not vaccinated",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: data['vaccine date'] !=
                                                                          null &&
                                                                      data['vaccine date'] !=
                                                                          ""
                                                                  ? Colors.grey
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                          trailing: Icon(
                                                            data['vaccine date'] !=
                                                                        null &&
                                                                    data['vaccine date'] !=
                                                                        ""
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons.cancel,
                                                            color: data['vaccine date'] !=
                                                                        null &&
                                                                    data['vaccine date'] !=
                                                                        ""
                                                                ? Colors.green
                                                                : Colors.red,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        if (index !=
                                                            vaccineDocuments
                                                                    .length -
                                                                1)
                                                          Divider(),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            // If no data is available, display a message
                                            return Text('No documents found.');
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(
                                        //     left: 50, right: 50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          ],
                                        ),
                                      )
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vaccines: ",
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
                                data['vaccine'].join(
                                    '\n'), // Join the array elements with a comma and space
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 5.0,
                                ),
                              ),
                            ),
                          ],
                        ),
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
