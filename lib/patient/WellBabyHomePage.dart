import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/forms/wellbabyformedit.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/patientProfile_page.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants copy.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/services.dart' as flutterServices;
import 'dart:html' as html;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../login/login.dart';

class PatientHomePageWellBaby extends StatefulWidget {
  const PatientHomePageWellBaby({required this.uid, Key? key})
      : super(key: key);
  final String uid;
  @override
  State<PatientHomePageWellBaby> createState() =>
      _PatientHomePageWellBabyState();
}

class _PatientHomePageWellBabyState extends State<PatientHomePageWellBaby> {
  TextEditingController diagnosis = new TextEditingController();
  TextEditingController recommend = new TextEditingController();
  TextEditingController visitDateController = new TextEditingController();
  TextEditingController reasonController = new TextEditingController();
  TextEditingController _initialDateController = TextEditingController();
  DateTime? _selectedDate;

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

  final SweetSheet _sweetSheet = SweetSheet();

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
                            IconButton(
                              onPressed: () {
                                _sweetSheet.show(
                                  context: context,
                                  title: Text("Confirmation"),
                                  description: Text(
                                      "Are you sure you want to sign out?"),
                                  color: SweetSheetColor.SUCCESS,
                                  negative: SweetSheetAction(
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    title: 'CONFIRM',
                                  ),
                                  positive: SweetSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: 'CANCEL',
                                  ),
                                );
                              },
                              icon: Icon(Icons.logout),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WellBabyRecordFormEdit(
                                                        uid: widget.uid)),
                                          );
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
                                      StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection("patients")
                                            .doc(widget.uid)
                                            .collection("vaccines")
                                            .snapshots(),
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
                                            // If data is available, display the documents
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
                                              "Upcoming Visits",
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
                                              visitDateController:
                                                  visitDateController,
                                              reasonController:
                                                  reasonController,
                                            ),
                                            Text(
                                              "Compulsary Visits",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 5.0),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CompulsaryVisitList(
                                              patientId: data['uid'],
                                              patientName: data['first name'],
                                              patientCategory: data['category'],
                                              diagnosis: diagnosis,
                                              recommend: recommend,
                                              visitDateController:
                                                  visitDateController,
                                              reasonController:
                                                  reasonController,
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
    List placeholder = ["Not Applicable"];
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
    var vaccines =
        (visitData as Map<String, dynamic>)?['vaccine'] ?? placeholder;
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
                        patientName: patientName,
                        vaccine: vaccines,
                      );
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
            .orderBy('visit date',
                descending: true) // Sort by "visit date" in descending order
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
            child: SizedBox(
              height: 280,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    DocumentSnapshot visitHistory = snapshot.data!.docs[index];
                    return VisitHistoryCard(context, visitHistory);
                  },
                ),
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
  final List vaccine;

  VisitHistoryDialog(
      {required this.patientId,
      required this.visitId,
      required this.visitDate,
      required this.vaccine,
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
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Vaccines: ",
                        //       style: TextStyle(
                        //           color: Colors.grey,
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.bold,
                        //           letterSpacing: 1.5,
                        //           wordSpacing: 5.0),
                        //     ),
                        //     Container(
                        //       width: 500,
                        //       child: Text(
                        //         data['vaccine'].join(
                        //             '\n'), // Join the array elements with a comma and space
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.bold,
                        //           wordSpacing: 5.0,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Information("Recommendation: ", data['instruction']),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Injected Vaccines: ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  wordSpacing: 5.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: vaccine
                                  .map<Widget>((control) => Text(
                                        control.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            wordSpacing: 5.0),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
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
    return Container(
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
              Informations(reason.toString().toUpperCase(), "Reason of Visit"),
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
          SizedBox(
            width: 20,
          ),
          Tooltip(
            message: "Cancel Appointment",
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete this appointment?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Proceed with document deletion
                              FirebaseFirestore.instance
                                  .collection('patients')
                                  .doc(patientId)
                                  .collection('appointments')
                                  .doc(upcomingVisit['visit id'])
                                  .delete()
                                  .then((_) {
                                // Document deleted successfully
                                print('Document deleted');
                              }).catchError((error) {
                                // Error occurred while deleting document
                                print('Error deleting document: $error');
                              });

                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(FontAwesomeIcons.trash, color: Colors.white)),
          ),
        ],
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
                    color: secondaryaccent,
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
                            child: DateSelectionContainerWellBabyRecord(
                              onDateSelected: _handleDateSelected,
                            ),
                          ),
                        if (widget.patientCategory == "Well-Baby Record")
                          Container(
                            child:
                                DateSelectionContainerIndividualPatientRecord(
                              onDateSelected: _handleDateSelected,
                            ),
                          ),
                        if (widget.patientCategory == "Pre-Natal Record")
                          Container(
                            child: DateSelectionContainerWellBabyRecord(
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

class ScheduleCompulsaryDialog extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientCategory;
  final TextEditingController reasonController;
  final TextEditingController visitDateController;

  ScheduleCompulsaryDialog(
      {required this.patientId,
      required this.patientName,
      required this.reasonController,
      required this.visitDateController,
      required this.patientCategory});

  @override
  State<ScheduleCompulsaryDialog> createState() =>
      _ScheduleCompulsaryDialogState();
}

class _ScheduleCompulsaryDialogState extends State<ScheduleCompulsaryDialog> {
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
        'Set Initial Date',
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
                            child: DateSelectionContainerWellBabyRecord(
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

            DateTime currentDate = dateTime;

            for (int i = 0; i < 12; i++) {
              var doc = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(widget.patientId)
                  .collection('compulsary visit')
                  .doc();

              await doc.set({
                'reason of visit': "Compulsary Monthly Checkup",
                'visit date': currentDate,
                'visit id': doc.id
              });

              currentDate =
                  currentDate.add(Duration(days: 28)); // Add 28 days (4 weeks)
            }

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
              "Did not show up",
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

class CompulsaryUpcomingVisitDialog extends StatefulWidget {
  final String patientId;
  final String visitId;
  final String visitDate;
  final String patientName;
  final TextEditingController Diagnosiscontroller;
  final TextEditingController Recommendationcontroller;
  final Timestamp? visitDateTime;

  CompulsaryUpcomingVisitDialog(
      {required this.patientId,
      required this.visitId,
      required this.visitDate,
      required this.patientName,
      required this.Diagnosiscontroller,
      required this.Recommendationcontroller,
      required this.visitDateTime});

  @override
  State<CompulsaryUpcomingVisitDialog> createState() =>
      _CompulsaryUpcomingVisitDialogState();
}

class _CompulsaryUpcomingVisitDialogState
    extends State<CompulsaryUpcomingVisitDialog> {
  String reasonofVisit = "";

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

  List<String> selectedVaccines = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Compulsary Visit',
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
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('patients')
                    .doc(widget.patientId)
                    .collection('compulsary visit')
                    .doc(widget.visitId)
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
                        Information("Patient name: ", widget.patientName),
                        Information(
                            "Reason of visit: ", data['reason of visit']),

                        DiagnosisAndRecommendation(context, 'Recommendation',
                            widget.Recommendationcontroller),
                        // Information("Visit date: ", visitDate),
                        // Information("Diagnosis: ", data['diagnosis']),
                        // Information("Recommendation: ", data['instruction'])
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('patients')
                              .where('category', isEqualTo: 'Well-Baby Record')
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              List<QueryDocumentSnapshot> patientDocs =
                                  snapshot.data!.docs;
                              return Builder(builder: (BuildContext context) {
                                return textboxVaccine(patientDocs);
                              });
                            }
                            return Container();
                          },
                        ),
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
                  .doc(widget.patientId)
                  .collection('visit history')
                  .doc();
              await doc.set({
                'diagnosis': "",
                'instruction': widget.Recommendationcontroller.text,
                'reason of visit': reasonofVisit,
                'visit date': widget.visitDateTime,
                'visit id': doc.id,
                'vaccine': selectedVaccines,
              });

              var markAsDone = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(widget.patientId)
                  .collection('compulsary visit')
                  .doc(widget.visitId);
              await markAsDone.delete();

              CollectionReference vaccinesCollection = FirebaseFirestore
                  .instance
                  .collection("patients")
                  .doc(widget.patientId)
                  .collection("vaccines");

              for (String vaccineName in selectedVaccines) {
                QuerySnapshot querySnapshot = await vaccinesCollection
                    .where("vaccine name", isEqualTo: vaccineName)
                    .get();

                for (QueryDocumentSnapshot documentSnapshot
                    in querySnapshot.docs) {
                  DocumentReference documentRef =
                      vaccinesCollection.doc(documentSnapshot.id);
                  String formattedDate =
                      DateFormat("MMM d, yyyy").format(DateTime.now());
                  await documentRef.update({"vaccine date": formattedDate});
                }
              }

              Fluttertoast.showToast(
                  msg: "Success!",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              widget.Diagnosiscontroller.text = "";
              widget.Recommendationcontroller.text = "";
              Navigator.pop(context);
            },
            child: Text("Mark as done")),
        TextButton(
            onPressed: () async {
              var markAsDone = await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(widget.patientId)
                  .collection('compulsary visit')
                  .doc(widget.visitId);
              await markAsDone.delete();

              Fluttertoast.showToast(
                  msg: "Success!",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              widget.Diagnosiscontroller.text = "";
              widget.Recommendationcontroller.text = "";
              Navigator.pop(context);
            },
            child: Text(
              "Did not show up",
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

  SizedBox textboxVaccine(List<QueryDocumentSnapshot<Object?>> patientDocs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: patientDocs.length,
        itemBuilder: (BuildContext context, int index) {
          QueryDocumentSnapshot patientDoc = patientDocs[index];
          return FutureBuilder<QuerySnapshot>(
            future: patientDoc.reference
                .collection('vaccines')
                .where('vaccine date', isEqualTo: '')
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> vaccinesSnapshot) {
              if (vaccinesSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (vaccinesSnapshot.hasError) {
                return Text('Error: ${vaccinesSnapshot.error}');
              }
              if (vaccinesSnapshot.hasData) {
                List<QueryDocumentSnapshot> vaccinesDocs =
                    vaccinesSnapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vaccinesDocs.length,
                  itemBuilder: (BuildContext context, int vaccinesIndex) {
                    QueryDocumentSnapshot vaccineDoc =
                        vaccinesDocs[vaccinesIndex];
                    bool isChecked =
                        selectedVaccines.contains(vaccineDoc['vaccine name']);

                    return CheckboxListTile(
                      title: Text(vaccineDoc['vaccine name']),
                      subtitle: Text(vaccineDoc['vaccine date']),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            selectedVaccines.add(vaccineDoc['vaccine name']);
                          } else {
                            selectedVaccines.remove(vaccineDoc['vaccine name']);
                          }
                        });
                      },
                    );
                  },
                );
              }
              return Container();
            },
          );
        },
      ),
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

class CompulsaryVisitList extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String patientCategory;
  final TextEditingController diagnosis;
  final TextEditingController recommend;
  final TextEditingController visitDateController;
  final TextEditingController reasonController;

  CompulsaryVisitList({
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
          // Future.delayed(Duration(milliseconds: 100)).then((value) {
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Builder(builder: (context) {
          //           return CompulsaryUpcomingVisitDialog(
          //             patientId: patientId,
          //             visitId: upcomingVisitData['visit id'],
          //             visitDate: formattedDate,
          //             patientName: patientName,
          //             Diagnosiscontroller: diagnosis,
          //             Recommendationcontroller: recommend,
          //             visitDateTime: visitTimestamp,
          //           );
          //         });
          //       });
          // });
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
            .collection('compulsary visit')
            .orderBy('visit date', descending: false)
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
                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return Builder(builder: (context) {
                  //         return ScheduleCompulsaryDialog(
                  //           patientId: patientId,
                  //           patientName: patientName,
                  //           visitDateController: visitDateController,
                  //           reasonController: reasonController,
                  //           patientCategory: patientCategory,
                  //         );
                  //       });
                  //     });
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
            child: SizedBox(
              height: 280,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    DocumentSnapshot visitHistory = snapshot.data!.docs[index];
                    return UpcomingVisitCard(context, visitHistory);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
