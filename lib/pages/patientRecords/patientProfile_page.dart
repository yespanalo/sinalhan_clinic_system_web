import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class PatientProfiel extends StatefulWidget {
  const PatientProfiel({super.key, required this.uid});

  final String uid;
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
    userData();
  }

  late String patientName = "";
  void userData() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.uid)
        .get();
    final Map<String, dynamic>? data = snapshot.data() as Map<String,
        dynamic>?; // Move the "as" keyword outside of the parentheses
    setState(() {
      patientName = data?['first name'] ?? '';
    });
    // Using the null-aware operator and providing a default value
    print(patientName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Text(patientName)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
