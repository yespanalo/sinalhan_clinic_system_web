import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sinalhan_clinic_system_web/constants.dart';
import 'package:sinalhan_clinic_system_web/login/login.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/patientRecords_page.dart';
import 'package:sinalhan_clinic_system_web/pages/users/usersPage.dart';
import 'package:sweetsheet/sweetsheet.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    _loadUserName();
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //Variables
  DateTime now = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Timer? _timer;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = "";
  final SweetSheet _sweetSheet = SweetSheet();
  late int _selectedIndex = 0;
  late int pagenum = 0;
  final List<IconData> _icons = [
    FontAwesomeIcons.bookBookmark,
    FontAwesomeIcons.safari,
    FontAwesomeIcons.calendarCheck,
    FontAwesomeIcons.box,
    FontAwesomeIcons.folderClosed,
    FontAwesomeIcons.book,
    FontAwesomeIcons.user,
    FontAwesomeIcons.accusoft,
  ];

  final List<String> _sidetext = [
    "Patient Records",
    "Logs",
    "Appointment",
    "Inventory",
    "Logs",
    "Report",
    "Users",
    "extra",
  ];

//Functions
  Future<void> _loadUserName() async {
    final User user = _auth.currentUser!;
    final uid = user.uid;

    final DocumentSnapshot result =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final userData = result.data() as Map<String, dynamic>;
    final name = userData['first name'] as String;

    setState(() {
      _userName = name;
    });
  }

  Widget _sidePanelTextIcons(int index) {
    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () => {
          setState(() {
            _selectedIndex = index;

            if (index != 0) {
              pagenum = _selectedIndex - 1;
            } else {
              pagenum = 0;
            }
          }),
          print(pagenum),
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              _selectedIndex == index
                  ? const Color(0xff323335)
                  : const Color(0xff1B1C1E),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(top: 20, bottom: 20, left: 10)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ))),
        child: Row(
          children: [
            Icon(
              _icons[index],
              size: 18.0,
              color: _selectedIndex == index ? Colors.white : Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _sidetext[index],
              style: TextStyle(
                  color: _selectedIndex == index ? Colors.white : Colors.grey,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    final List<dynamic> pages = [
      PatientRecords(timeOfDay: _timeOfDay, period: period),
      PatientRecords(timeOfDay: _timeOfDay, period: period),
      PatientRecords(timeOfDay: _timeOfDay, period: period),
      PatientRecords(timeOfDay: _timeOfDay, period: period),
      PatientRecords(timeOfDay: _timeOfDay, period: period),
      UsersPage(timeOfDay: _timeOfDay, period: period),
      UsersPage(timeOfDay: _timeOfDay, period: period)
      // Appointments(
      //   timeOfDay: _timeOfDay,
      //   period: period,
      //   calendarOrList: widget.calendarOrList,
      // ),
      // Inventory(timeOfDay: _timeOfDay, period: period),
      // LogsPage(timeOfDay: _timeOfDay, period: period),
      // ReportPage(timeOfDay: _timeOfDay, period: period),
      // UsersPage(timeOfDay: _timeOfDay, period: period),
      // UsersPage(timeOfDay: _timeOfDay, period: period)
    ];
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xff1B1C1E),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/place.jpg'),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Mont',
                    ),
                  ),
                  shortsizedbox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.circle,
                        color: Colors.green,
                        size: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Health Worker",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  longsizedbox,
                  Column(
                    children: [
                      _sidePanelTextIcons(0),
                      medsizedbox,
                      _sidePanelTextIcons(2),
                      medsizedbox,
                      _sidePanelTextIcons(3),
                      medsizedbox,
                      _sidePanelTextIcons(4),
                      medsizedbox,
                      // _sidePanelTextIcons(5),
                      // medsizedbox,
                      _sidePanelTextIcons(6),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: 200,
                    child: TextButton(
                      onPressed: () => {
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
                        )
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff323335),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 10)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ))),
                      child: Row(
                        children: const [
                          Icon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 18.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Signout",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Mont',
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          pages[pagenum],
        ],
      )),
    );
  }
}
