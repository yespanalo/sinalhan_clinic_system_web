import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MoreInfo extends StatefulWidget {
  const MoreInfo({required this.uid, Key? key}) : super(key: key);
  final String uid;
  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
