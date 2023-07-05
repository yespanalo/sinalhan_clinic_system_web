import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:sinalhan_clinic_system_web/categorySelection.dart';
import 'package:sinalhan_clinic_system_web/constants.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/patientProfilePreNatal.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/patientProfileWellbaby.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/patientProfile_page.dart';

import 'forms/individualpatientform.dart';

class PatientRecords extends StatefulWidget {
  const PatientRecords({
    Key? key,
    required TimeOfDay timeOfDay,
    required this.period,
  })  : _timeOfDay = timeOfDay,
        super(key: key);

  final TimeOfDay _timeOfDay;
  final String period;
  @override
  State<PatientRecords> createState() => _PatientRecordsState();
}

class _PatientRecordsState extends State<PatientRecords> {
  //Variables
  String dropdownValue = 'Individual Profile Record';

//Functions
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
                        "Patient Records",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),

                  width: 1200,
                  // color: Colors.white,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patients",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      IndividualPatientRecord(context),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Container IndividualPatientRecord(BuildContext context) {
  List<Map<String, dynamic>> _dataList = [];
  String _searchText = '';
  final Stream<QuerySnapshot> _patientsStream =
      FirebaseFirestore.instance.collection('patients').snapshots();
  return Container(
    child: Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     SizedBox(
        //       width: 300,
        //       child: TextField(
        //         inputFormatters: <TextInputFormatter>[
        //           FilteringTextInputFormatter.deny(
        //               RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!,./\0-9]')),
        //           LengthLimitingTextInputFormatter(11),
        //         ],
        //         // controller: searchController,
        //         // onChanged: (value) {
        //         //   setState(() {
        //         //     if (searchController.text.length == 0) {
        //         //       patients = getPatientList();
        //         //     } else {
        //         //       patients = filterTableByDate();
        //         //     }
        //         //   });
        //         // },
        //         decoration: InputDecoration(
        //           prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
        //           hintText: 'Search',
        //           hintStyle: const TextStyle(color: Colors.grey),
        //           filled: true,
        //           fillColor: const Color(0xffF7F7F7),
        //           focusedBorder: OutlineInputBorder(
        //             borderSide: const BorderSide(color: Colors.white),
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //           enabledBorder: UnderlineInputBorder(
        //             borderSide: const BorderSide(color: Colors.white),
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ),
        //       ),
        //     ),
        //     // SizedBox(
        //     //   width: 100,
        //     //   child: TextButton(
        //     //       style: ButtonStyle(
        //     //         padding: MaterialStateProperty.all<EdgeInsets>(
        //     //             const EdgeInsets.all(15)),
        //     //         // foregroundColor:
        //     //         //     MaterialStateProperty.all<Color>(Colors.red),
        //     //         backgroundColor:
        //     //             MaterialStateProperty.all<Color>(secondaryaccent),
        //     //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     //           RoundedRectangleBorder(
        //     //             borderRadius: BorderRadius.circular(18.0),
        //     //             side: BorderSide(color: secondaryaccent),
        //     //           ),
        //     //         ),
        //     //       ),
        //     //       onPressed: () {
        //     //         Navigator.of(context).push(
        //     //           new MaterialPageRoute(
        //     //               builder: (_) => new categorySelection()),
        //     //         );
        //     //       },
        //     //       child: Text("Add",
        //     //           style: TextStyle(fontSize: 16, color: Colors.white))),
        //     // )

        //     // )
        //   ],
        // ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        SizedBox(
          // height: 360,
          child: StreamBuilder<QuerySnapshot>(
              stream: _patientsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                _dataList =
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return data;
                }).toList();

                if (_searchText.isNotEmpty) {
                  _dataList = _dataList.where((row) {
                    return row['email'].toString().contains(_searchText) ||
                        row['first name'].toString().contains(_searchText) ||
                        row['last name'].toString().contains(_searchText) ||
                        row['mobile number'].toString().contains(_searchText) ||
                        row['type'].toString().contains(_searchText);
                  }).toList();
                }

                int rowsPerPage = snapshot.data!.size;

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double columnSpacing = constraints.maxWidth /
                        (10 + 1); // add 1 for the action column

                    return PaginatedDataTable(
                      columnSpacing: columnSpacing,
                      columns: [
                        DataColumn(
                            label: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Mobile Number',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Category',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(label: Text('')),
                      ],
                      source: _MyDataTableSource(_dataList, context),
                      rowsPerPage: rowsPerPage > 5 ? 5 : rowsPerPage,
                    );
                  },
                );
              }),
        )
      ],
    ),
  );
}

class _MyDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;
  final BuildContext _context;

  _MyDataTableSource(this._dataList, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _dataList.length) {
      return null;
    }
    final Map<String, dynamic> data = _dataList[index];

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
          data['first name'].toString() + " " + data['last name'].toString())),
      DataCell(Text(data['email'].toString())),
      DataCell(Text(data['contact number'].toString())),
      DataCell(Text(data['category'].toString())),
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: secondaryaccent,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 2.0, color: secondaryaccent),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  if (data['category'] == "Individual Patient Record") {
                    Navigator.of(_context).push(
                      MaterialPageRoute(
                          builder: (_) => PatientProfiel(
                                uid: data['uid'].toString(),
                              )),
                    );
                  } else if (data['category'] == "Well-Baby Record") {
                    Navigator.of(_context).push(
                      MaterialPageRoute(
                          builder: (_) => patientProfileWellbaby(
                                uid: data['uid'].toString(),
                              )),
                    );
                  } else if (data['category'] == "Pre-Natal Record") {
                    Navigator.of(_context).push(
                      MaterialPageRoute(
                          builder: (_) => PatientProfilePreNatal(
                                uid: data['uid'].toString(),
                              )),
                    );
                  }

                  // Edit user logic
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  int get rowCount => _dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
