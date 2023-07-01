import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants copy.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/services.dart' as flutterServices;
import 'dart:html' as html;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PatientProfilePreNatal extends StatefulWidget {
  const PatientProfilePreNatal({required this.uid, Key? key}) : super(key: key);
  final String uid;
  @override
  State<PatientProfilePreNatal> createState() => _PatientProfilePreNatalState();
}

class _PatientProfilePreNatalState extends State<PatientProfilePreNatal> {
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

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy, hh:mm a');
    return formatter.format(now);
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
                        padding:
                            const EdgeInsets.only(top: 50, left: 50, right: 50),
                        child: SingleChildScrollView(
                          child: Column(
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
                                        image:
                                            AssetImage('images/prenatal.png'),
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
                                              _calculateAge(data['birthdate']),
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
        },
      ),
    );
  }
}
