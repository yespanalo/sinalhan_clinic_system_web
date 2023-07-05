import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants copy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/services.dart' as flutterServices;
import 'dart:html' as html;

class Schedules extends StatefulWidget {
  const Schedules({
    Key? key,
    required TimeOfDay timeOfDay,
    required this.period,
  })  : _timeOfDay = timeOfDay,
        super(key: key);
  final TimeOfDay _timeOfDay;
  final String period;
  @override
  State<Schedules> createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  CalendarController _calendarController = CalendarController();

  List<Appointment> _appointments = [];
  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  void loadAppointments() async {
    QuerySnapshot patientSnapshot =
        await FirebaseFirestore.instance.collection('patients').get();

    List<Appointment> appointments = [];

    for (QueryDocumentSnapshot patientDoc in patientSnapshot.docs) {
      String firstName = patientDoc['first name'];
      String lastName = patientDoc['last name'];
      String category = patientDoc['category'];

      QuerySnapshot appointmentSnapshot = await patientDoc.reference
          .collection('appointments')
          .orderBy('visit date')
          .get();

      List<Appointment> patientAppointments = appointmentSnapshot.docs
          .map((appointmentDoc) {
            Map<String, dynamic>? data =
                appointmentDoc.data() as Map<String, dynamic>?;

            if (data != null) {
              DateTime? visitDate = data['visit date']?.toDate();
              String? reasonOfVisit = data['reason of visit'];

              if (visitDate != null && reasonOfVisit != null) {
                final DateTime today = DateTime.now();

                return Appointment(
                  startTime: visitDate.add(Duration(hours: 8)),
                  endTime: visitDate.add(Duration(hours: 12)),
                  subject: reasonOfVisit,
                  patientName: '$firstName $lastName', // Add patient name
                  category: '$category', // Add patient name
                );
              }
            }

            return null;
          })
          .whereType<Appointment>()
          .toList();

      appointments.addAll(patientAppointments);
    }

    setState(() {
      _appointments = appointments;
      print(_appointments);
    });
  }

  int IndividualpatientCount = 0;
  int WellBabyCount = 0;
  int PreNatalCount = 0;
  int total = 0;

  Future<List<Map<String, dynamic>>> fetchInventoryData() async {
    QuerySnapshot medicineSnapshot =
        await FirebaseFirestore.instance.collection('patients').get();

    List<Map<String, dynamic>> inventoryData = [];
    DateTime currentDate = DateTime.now();

    // Calculate the start and end dates of the current week
    DateTime startDate =
        currentDate.subtract(Duration(days: currentDate.weekday));
    DateTime endDate = startDate.add(Duration(days: 5));
    for (DocumentSnapshot medicineDoc in medicineSnapshot.docs) {
      String name = "";
      String category = "";

      QuerySnapshot batchSnapshot =
          await medicineDoc.reference.collection('visit history').get();
      int totalQuantity = 0;
      String reasonOfVisit = "";
      String visitDate = "";

      for (DocumentSnapshot batchDoc in batchSnapshot.docs) {
        // int quantity = batchDoc['quantity'];
        // totalQuantity += quantity;

        DateTime batchVisitDate = batchDoc['visit date']
            .toDate(); // Assuming 'visit date' field is a Firestore Timestamp

        if (batchVisitDate.isAfter(startDate) &&
            batchVisitDate.isBefore(endDate)) {
          name = medicineDoc['first name'] + " " + medicineDoc['last name'];
          category = medicineDoc['category'];
          reasonOfVisit = batchDoc['reason of visit'];

          final DateFormat formatter = DateFormat('MMMM d, yyyy');
          visitDate = formatter.format(batchVisitDate);

          if (category == "Individual Patient Record") {
            IndividualpatientCount++;
          } else if (category == "Pre-Natal Record") {
            PreNatalCount++;
          } else {
            WellBabyCount++;
          }
          total = IndividualpatientCount + PreNatalCount + WellBabyCount;

          break; // Exit the inner loop if a valid visit date is found
        }
      }

      Map<String, dynamic> inventoryItem = {
        'name': name,
        'category': category,
        'reasonOfVisit': reasonOfVisit,
        'date': visitDate,
        'individualCount': IndividualpatientCount,
        'wellbabyCount': WellBabyCount,
        'prenatalCount': PreNatalCount,
      };

      inventoryData.add(inventoryItem);
    }

    return inventoryData;
  }

  Future<void> generateAndDownloadInventorySummaryReport(
      List<Map<String, dynamic>> inventoryData) async {
    final pdf = await generateInventorySummaryReport(inventoryData);
    downloadPdfReport(pdf, "TotalAppointment.pdf");
    IndividualpatientCount = 0;
    PreNatalCount = 0;
    WellBabyCount = 0;
    total = 0;
  }

  Future<pdfWidgets.Document> generateInventorySummaryReport(
      List<Map<String, dynamic>> data) async {
    final pdf = pdfWidgets.Document();
    // final headerImage = await addImage(pdf, 'images/sinalhanLogo.png');

    pdf.addPage(
      pdfWidgets.MultiPage(
        header: (context) {
          return pdfWidgets.Container(
            alignment: pdfWidgets.Alignment.centerLeft,
            margin: pdfWidgets.EdgeInsets.only(bottom: 20.0),
            child: pdfWidgets.Column(
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: [
                pdfWidgets.Row(children: [
                  // pdfWidgets.Container(
                  //     width: 50, height: 50, child: headerImage),
                  pdfWidgets.SizedBox(width: 20),
                  pdfWidgets.Row(children: [
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
                          'Inventory Summary Report',
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
                  pdfWidgets.Spacer(),
                  pdfWidgets.Column(children: [
                    pdfWidgets.Row(children: [
                      pdfWidgets.Text(
                        "Individual Patients: ",
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.black,
                        ),
                      ),
                      pdfWidgets.Text(
                        IndividualpatientCount.toString(),
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.grey,
                        ),
                      ),
                    ]),
                    pdfWidgets.Row(children: [
                      pdfWidgets.Text(
                        "Pre-Natal Patients: ",
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.black,
                        ),
                      ),
                      pdfWidgets.Text(
                        PreNatalCount.toString(),
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.grey,
                        ),
                      ),
                    ]),
                    pdfWidgets.Row(children: [
                      pdfWidgets.Text(
                        "Well-Baby Patients: ",
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.black,
                        ),
                      ),
                      pdfWidgets.Text(
                        WellBabyCount.toString(),
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.grey,
                        ),
                      ),
                    ]),
                    pdfWidgets.Row(children: [
                      pdfWidgets.Text(
                        "Total: ",
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.black,
                        ),
                      ),
                      pdfWidgets.Text(
                        total.toString(),
                        style: pdfWidgets.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.grey,
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        build: (context) => [
          pdfWidgets.Table.fromTextArray(
            data: [
              ['Name', 'Category', 'Reason of Visit', 'Visit Date'],
              ...data.map((item) => [
                    item['name'],
                    item['category'],
                    item['reasonOfVisit'],
                    item['date']
                  ]),
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy, hh:mm a');
    return formatter.format(now);
  }

  void downloadPdfReport(pdfWidgets.Document pdf, String fileName) async {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 5,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 1.0, color: Color.fromARGB(255, 212, 212, 212)),
            ),
            color: Color(0xffF7F7F7),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Barangay Sinalhan Clinic",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Mont",
                              fontSize: 24,
                              color: Color(0xff1B1C1E)),
                        ),
                        Text(
                          "Appointments",
                          style: TextStyle(
                              fontFamily: "Mont",
                              fontSize: 15,
                              color: Colors.grey),
                        )
                      ],
                    ),
                    const Spacer(),
                    Text(
                      // "${widget._timeOfDay.hourOfPeriod}:${widget._timeOfDay.minute}",
                      formatTimeOfDay(widget._timeOfDay),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Mont",
                          fontSize: 28,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 1.3,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              _calendarController
                                  .backward!(); // Go to the previous month
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              _calendarController
                                  .forward!(); // Go to the next month
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SfCalendar(
                        initialSelectedDate: DateTime.now(),
                        view: CalendarView.month,
                        monthViewSettings: MonthViewSettings(
                            showAgenda: true,
                            agendaItemHeight: 70,
                            agendaStyle: AgendaStyle(
                                appointmentTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        onTap: (CalendarTapDetails details) {
                          if (details.targetElement ==
                              CalendarElement.appointment) {
                            // Retrieve the meeting details
                            String patientName =
                                details.appointments![0].patientName;
                            String category = details.appointments![0].category;
                            DateTime startTime =
                                details.appointments![0].startTime;
                            DateFormat dateFormat = DateFormat('MMMM d, yyyy');
                            String formattedStartTime =
                                dateFormat.format(startTime);

                            // Show a dialog with the meeting details
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Meeting Details'),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Name: ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '$patientName',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Scheduled Date: ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '$formattedStartTime',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Category: ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '$category',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        dataSource:
                            _MyCalendarDataSource(appointments: _appointments),
                        controller: _calendarController,
                        headerStyle: CalendarHeaderStyle(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          List<Map<String, dynamic>> inventoryData =
                              await fetchInventoryData();
                          Future<void> pdf =
                              generateAndDownloadInventorySummaryReport(
                                  inventoryData);
                        },
                        child: Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: secondaryaccent, // Set the fill color to red
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the border radius
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.white,
                              ),
                              Center(
                                child: Text(
                                  "Generate Weekly Visit List",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold // Set the font color to white
                                      ),
                                  textAlign: TextAlign.center,
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
            ],
          ),
        ));
  }
}

class _MyCalendarDataSource extends CalendarDataSource {
  _MyCalendarDataSource({required List<Appointment> appointments}) {
    this.appointments = appointments;
  }
  @override
  String getSubject(int index) {
    return appointments![index].patientName; // Use meeting name as subject
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  DateTime getCategory(int index) {
    return appointments![index].category;
  }
}

class Appointment {
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final String category;
  final String patientName; // Add the patientName property

  Appointment({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.category,
    required this.patientName,
  });
}
