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

  List<Appointment> _appointments = [];
  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  void loadAppointments() async {
    QuerySnapshot appointmentsSnapshot =
        await FirebaseFirestore.instance.collectionGroup('appointments').get();

    List<Appointment> appointments = [];
    appointmentsSnapshot.docs.forEach((appointmentDoc) {
      Map<String, dynamic>? appointmentData =
          appointmentDoc.data() as Map<String, dynamic>?;

      if (appointmentData != null) {
        DateTime? visitDate = appointmentData['visitDate']?.toDate();
        String? reasonOfVisit = appointmentData['reasonOfVisit'];

        if (visitDate != null && reasonOfVisit != null) {
          Appointment appointment = Appointment(
            startTime: visitDate,
            endTime: visitDate.add(Duration(hours: 1)),
            subject: reasonOfVisit,
          );
          appointments.add(appointment);
        }
      }
    });

    setState(() {
      _appointments = appointments;
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
              SfCalendar(
                view: CalendarView.month, // Display the calendar in month view
                dataSource: _DataSource(appointments: _appointments),
              ),
            ],
          ),
        ));
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource({required List<Appointment> appointments}) {
    appointments.forEach((appointment) {
      this.appointments?.add(appointment);
    });
  }
}
