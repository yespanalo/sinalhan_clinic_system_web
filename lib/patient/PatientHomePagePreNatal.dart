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

class PatientHomeProfilePreNatal extends StatefulWidget {
  const PatientHomeProfilePreNatal({required this.uid, Key? key})
      : super(key: key);
  final String uid;
  @override
  State<PatientHomeProfilePreNatal> createState() =>
      _PatientHomeProfilePreNatalState();
}

class _PatientHomeProfilePreNatalState
    extends State<PatientHomeProfilePreNatal> {
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
              pw.Text('Address: ' + patientData!['address']),
              pw.SizedBox(height: 10),
              pw.Text('Contact Number: ' + patientData!['contact number']),
              pw.SizedBox(height: 10),
              pw.Text('Email: ' + patientData!['email']),
              pw.SizedBox(height: 10),
              pw.Text('AOG: ' + patientData!['assessment of gestational date']),
              pw.SizedBox(height: 10),
              pw.Text('Gravida: ' + patientData!['gravida']),
              pw.SizedBox(height: 10),
              pw.Text('Number of fullterm Pregnancy: ' + patientData!['term']),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Number of premature Pregnancy: ' + patientData!['preterm']),
              pw.SizedBox(height: 10),
              pw.Text('Number of abortion: ' + patientData!['abortion']),
              pw.SizedBox(height: 10),
              pw.Text('Number of living children: ' + patientData!['living']),
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
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              _sweetSheet.show(
                                context: context,
                                title: Text("Confirmation"),
                                description:
                                    Text("Are you sure you want to sign out?"),
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
                                              'Female',
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
                                          data['address'],
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
                                            Informations(data['husband name'],
                                                "Husband Name"),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Informations(
                                                data[
                                                    'assessment of gestational date'],
                                                "AOG"),
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
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Informations(data['term'],
                                                "Number of full term"),
                                            SizedBox(height: 40),
                                            Informations(data['preterm'],
                                                "Number of premature"),
                                            SizedBox(height: 40),
                                            Informations(data['living'],
                                                "Number of living children"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Informations(
                                                _formatBirthdate(data[
                                                    'estimated date of confinement']),
                                                "Due Date"),
                                            SizedBox(height: 40),
                                            Container(),
                                            SizedBox(height: 40),
                                            Container(),
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
                                      visitDateController: visitDateController,
                                      reasonController: reasonController,
                                      dueDate: DateTime.parse(data[
                                          'estimated date of confinement']),
                                    ),
                                  ],
                                ),
                              )
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
              height: MediaQuery.of(context).size.height / 1.5,
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
                        DiagnosisAndRecommendation(
                            context, 'Diagnosis', widget.Diagnosiscontroller),
                        DiagnosisAndRecommendation(context, 'Recommendation',
                            widget.Recommendationcontroller),

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
  final DateTime dueDate;

  CompulsaryVisitList({
    required this.patientId,
    required this.patientName,
    required this.patientCategory,
    required this.diagnosis,
    required this.recommend,
    required this.visitDateController,
    required this.reasonController,
    required this.dueDate,
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
            color: secondaryaccent,
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Builder(builder: (context) {
                          return ScheduleCompulsaryDialog(
                            patientId: patientId,
                            patientName: patientName,
                            visitDateController: visitDateController,
                            reasonController: reasonController,
                            patientCategory: patientCategory,
                            dueDate: dueDate,
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

class ScheduleCompulsaryDialog extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientCategory;
  final TextEditingController reasonController;
  final TextEditingController visitDateController;
  final DateTime dueDate;

  ScheduleCompulsaryDialog(
      {required this.patientId,
      required this.patientName,
      required this.reasonController,
      required this.visitDateController,
      required this.dueDate,
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

            DateTime currentDate = dateTime;
            DateTime dueDate =
                widget.dueDate; // Set your specific due date here

            while (currentDate.isBefore(dueDate)) {
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
