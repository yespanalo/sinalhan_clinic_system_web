import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class Inventory_Page extends StatefulWidget {
  const Inventory_Page({
    super.key,
    required TimeOfDay timeOfDay,
    required this.period,
  }) : _timeOfDay = timeOfDay;
  final TimeOfDay _timeOfDay;
  final String period;
  @override
  State<Inventory_Page> createState() => _Inventory_PageState();
}

class _Inventory_PageState extends State<Inventory_Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //Variables
  String dropdownValue = 'Medicine List';
  String? medicineName;
  int? threshold;
  DateTime? expiryDate;
  String? category;
  DateTime? manufacturingDate;
  int? quantity;

//Functions
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  dynamic returnRecord() {
    if (dropdownValue == 'Medicine List') {
      return MedicineSupply();
    }
    // else if (dropdownValue == 'Supply Overview') {
    //   return SupplyOverview();
    // } else if (dropdownValue == 'Medicine Distribution') {
    //   return MedicineDistribution();
    // }
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
                        "Inventory",
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
                      DropdownButton(
                          value: dropdownValue,
                          underline: Container(
                            color: Colors.white,
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mont',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Medicine List',
                            'Supply Overview',
                            'Medicine Distribution'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList()),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      returnRecord()
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

  Column MedicineSupply() {
    ScrollController datatable = new ScrollController();
    List<Map<String, dynamic>> _dataList = [];
    String _searchText = '';
    final Stream<QuerySnapshot> _medicineStream =
        FirebaseFirestore.instance.collection('medicine').snapshots();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!,./\0-9]')),
                  LengthLimitingTextInputFormatter(11),
                ],
                // controller: searchController,
                // onChanged: (value) {
                //   setState(() {
                //     if (searchController.text.length == 0) {
                //       medicine = getMedicineList();
                //     } else {
                //       medicine = filterTableByDate();
                //     }
                //   });
                // },
                decoration: InputDecoration(
                  prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xffF7F7F7),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(15)),
                        // foregroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.red),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(secondaryaccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: secondaryaccent),
                          ),
                        ),
                      ),
                      onPressed: () {
                        AlertDialog(
                          title: Text('Add Medicine'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Medicine Name'),
                                  onChanged: (value) {
                                    setState(() {
                                      medicineName = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Threshold'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      threshold = int.tryParse(value);
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Expiry Date'),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        expiryDate = pickedDate;
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: expiryDate != null
                                        ? '${expiryDate!.day}-${expiryDate!.month}-${expiryDate!.year}'
                                        : '',
                                  ),
                                ),
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Category'),
                                  onChanged: (value) {
                                    setState(() {
                                      category = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Manufacturing Date'),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        manufacturingDate = pickedDate;
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: manufacturingDate != null
                                        ? '${manufacturingDate!.day}-${manufacturingDate!.month}-${manufacturingDate!.year}'
                                        : '',
                                  ),
                                ),
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Quantity'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      quantity = int.tryParse(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (medicineName != null &&
                                    threshold != null &&
                                    expiryDate != null &&
                                    category != null &&
                                    manufacturingDate != null &&
                                    quantity != null) {
                                  // Perform any necessary logic with the entered data
                                  print('Medicine Name: $medicineName');
                                  print('Threshold: $threshold');
                                  print('Expiry Date: $expiryDate');
                                  print('Category: $category');
                                  print(
                                      'Manufacturing Date: $manufacturingDate');
                                  print('Quantity: $quantity');

                                  // Close the dialog
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                      child: Text("Add",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 5),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<String>(
        //       value: filterDropdownValue,
        //       icon: null,
        //       style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        //       elevation: 16,
        //       onChanged: (String? value) {
        //         setState(() {
        //           filterDropdownValue = value!;
        //         });
        //       },
        //       items: filterList.map<DropdownMenuItem<String>>((String value) {
        //         return DropdownMenuItem<String>(
        //           child: Text(value),
        //           value: value,
        //         );
        //       }).toList(),
        //     ),
        //   ),
        // ),
        SizedBox(
          // height: 360,
          child: StreamBuilder<QuerySnapshot>(
              stream: _medicineStream,
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

                // if (_searchText.isNotEmpty) {
                //   _dataList = _dataList.where((row) {
                //     return row['email'].toString().contains(_searchText) ||
                //         row['first name'].toString().contains(_searchText) ||
                //         row['last name'].toString().contains(_searchText) ||
                //         row['mobile number'].toString().contains(_searchText) ||
                //         row['type'].toString().contains(_searchText);
                //   }).toList();
                // }

                int rowsPerPage = snapshot.data!.size;

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double columnSpacing = constraints.maxWidth /
                        (3 + 1); // add 1 for the action column

                    return PaginatedDataTable(
                      columnSpacing: columnSpacing,
                      columns: [
                        DataColumn(
                            label: Text(
                          'Medicine name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Category',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Stock',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                      source: _MyDataTableSource(_dataList, context),
                      rowsPerPage: rowsPerPage > 5 ? 5 : rowsPerPage,
                    );
                  },
                );
              }),
        )
      ],
    );
  }
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
      DataCell(Text(data['medicine name'].toString())),
      DataCell(Text(data['category'].toString())),
      DataCell(Text(data['stock in'].toString())),
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigator.of(_context).push(
                  //   new MaterialPageRoute(
                  //     builder: (_) => UpdateUser(
                  //         firstName: data['first name'].toString(),
                  //         lastName: data['last name'].toString(),
                  //         email: data['email'],
                  //         mobileNumber: data['mobile number'].toString(),
                  //         uid: data['uid'].toString()),
                  //   ),
                  // );
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
