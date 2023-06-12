import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
                                      Text('Name: $patientName'),
                                      Text(
                                          'Scheduled Date: $formattedStartTime'),
                                      Text('Category: $category'),
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
