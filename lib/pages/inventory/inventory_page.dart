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
import '../../models/medicineModel.dart';

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
  late List<Medicine> medicines;

  //Variables
  String dropdownValue = 'Medicine List';

  String? medicineName;
  int? threshold;
  DateTime? expiryDate;
  String? category;
  DateTime? manufacturingDate;
  int? quantity;

  TextEditingController expiryDateController = TextEditingController();
  TextEditingController manufacturingDateController = TextEditingController();

//Functions
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  void uploadMedicineData() async {
    try {
      // Create a new document in the "medicine" collection
      DocumentReference medicineRef =
          FirebaseFirestore.instance.collection('medicine').doc();

      // Set the data for the medicine document
      await medicineRef.set({
        'name': medicineName,
        'threshold': threshold,
        'category': category,
        'medicine id': medicineRef.id,
      });

      // Create a new document in the "details" subcollection of the medicine document
      CollectionReference detailsRef = medicineRef.collection('batches');
      DocumentReference detailsDocRef = detailsRef.doc();

      // Set the data for the details document
      await detailsDocRef.set({
        'expiryDate': expiryDate,
        'manufacturingDate': manufacturingDate,
        'quantity': quantity,
        'batchNumber': 1,
        'batchId': detailsDocRef.id
      });

      print('Medicine data uploaded successfully!');
      setState(() {});
    } catch (error) {
      print('Error uploading medicine data: $error');
    }
  }

  @override
  void initState() {
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
    } else if (dropdownValue == 'Supply Overview') {
      return SupplyOverview();
    }
    //  else if (dropdownValue == 'Medicine Distribution') {
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

  Column SupplyOverview() {
    ScrollController datatable = new ScrollController();
    List<Map<String, dynamic>> _dataList = [];
    String _searchText = '';
    final Stream<QuerySnapshot> _medicineStream =
        FirebaseFirestore.instance.collection('medicine').snapshots();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!,./\0-9]')),
                  LengthLimitingTextInputFormatter(11),
                ],
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
            Spacer(),
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
                      onPressed: () async {
                        await addNewMedicine();
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
        SizedBox(
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

                int rowsPerPage = snapshot.data!.size;
                return LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  double columnspacing = constraints.maxWidth / (3.3 + 1);
                  return PaginatedDataTable(
                    columnSpacing: columnspacing,
                    source: _MyDataTableSource(_dataList, context),
                    rowsPerPage: rowsPerPage > 5 ? 5 : rowsPerPage,
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
                        'Threshold',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  );
                });
              }),
        ),
      ],
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
          ],
        ),
      ],
    );
  }

  addNewMedicine() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Medicine'),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Medicine Name'),
                      onChanged: (value) {
                        setState(() {
                          medicineName = value;
                        });
                      },
                    ),
                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: 'Threshold'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          threshold = int.tryParse(value);
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Expiry Date'),
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
                            expiryDateController.text =
                                '${expiryDate!.day}-${expiryDate!.month}-${expiryDate!.year}';
                          });
                        }
                      },
                      readOnly: true,
                      controller: expiryDateController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Category'),
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Manufacturing Date'),
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
                            manufacturingDateController.text =
                                '${manufacturingDate!.day}-${manufacturingDate!.month}-${manufacturingDate!.year}';
                          });
                        }
                      },
                      readOnly: true,
                      controller: manufacturingDateController,
                    ),
                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: 'Quantity'),
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

                    uploadMedicineData();
                    // Close the dialog
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        });
  }
}

class _MyDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;
  final BuildContext _context;

  _MyDataTableSource(this._dataList, this._context);

  Future<int> calculateTotalQuantity(String medicineId) async {
    int totalQuantity = 0;

    try {
      // Reference to the "batches" subcollection of a medicine document
      CollectionReference batchesRef = FirebaseFirestore.instance
          .collection('medicine')
          .doc(medicineId)
          .collection('batches');

      // Query all documents in the "batches" collection
      QuerySnapshot querySnapshot = await batchesRef.get();

      // Iterate over the documents and calculate the sum of the quantity field
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> batchData =
            documentSnapshot.data() as Map<String, dynamic>;
        int quantity = batchData['quantity'] ?? 0;
        totalQuantity += quantity;
      }

      print('Total quantity: $totalQuantity');
    } catch (error) {
      print('Error calculating total quantity: $error');
    }

    return totalQuantity;
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _dataList.length) {
      return null;
    }
    final Map<String, dynamic> data = _dataList[index];

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['category'].toString())),
      DataCell(Text(data['threshold'].toString())),
      // DataCell(
      //   data['medicine id'] != null
      //       ? FutureBuilder<int>(
      //           future: calculateTotalQuantity(data['medicine id']),
      //           builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return Text("Loading");
      //             } else if (snapshot.hasError) {
      //               return Text('Error: ${snapshot.error}');
      //             } else {
      //               int totalQuantity = snapshot.data ?? 0;
      //               return Text('$totalQuantity');
      //             }
      //           },
      //         )
      //       : Text("N/A"), // Default widget when 'medicine id' is null
      // ),
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  String editedMedicineName = data['name'] ?? '';
                  int? editedThreshold = data['threshold'];
                  String editedCategory = data['category'] ?? '';
                  showDialog(
                    context: _context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Medicine'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Medicine Name'),
                                onChanged: (value) {
                                  editedMedicineName = value;
                                },
                                controller: TextEditingController(
                                    text: editedMedicineName),
                              ),
                              TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:
                                    InputDecoration(labelText: 'Threshold'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  editedThreshold = int.tryParse(value);
                                },
                                controller: TextEditingController(
                                    text: editedThreshold?.toString() ?? ''),
                              ),
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Category'),
                                onChanged: (value) {
                                  editedCategory = value;
                                },
                                controller:
                                    TextEditingController(text: editedCategory),
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
                              if (editedMedicineName != null &&
                                  editedThreshold != null &&
                                  editedCategory != null) {
                                final docRef = FirebaseFirestore.instance
                                    .collection('medicine')
                                    .doc(data['medicine id']);
                                docRef.update({
                                  'name': editedMedicineName,
                                  'threshold': editedThreshold,
                                  'category': editedCategory,
                                  // Add more fields to update if needed
                                });
                              }
                              // Perform the necessary logic to save the edited data
                              // For example, update the data in Firebase or any other data source
                              // using the editedMedicineName, editedThreshold, and editedCategory values

                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
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

class _MedicineList extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;
  final BuildContext _context;

  _MedicineList(this._dataList, this._context);

  Future<int> calculateTotalQuantity(String medicineId) async {
    int totalQuantity = 0;

    try {
      // Reference to the "batches" subcollection of a medicine document
      CollectionReference batchesRef = FirebaseFirestore.instance
          .collection('medicine')
          .doc(medicineId)
          .collection('batches');

      // Query all documents in the "batches" collection
      QuerySnapshot querySnapshot = await batchesRef.get();

      // Iterate over the documents and calculate the sum of the quantity field
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> batchData =
            documentSnapshot.data() as Map<String, dynamic>;
        int quantity = batchData['quantity'] ?? 0;
        totalQuantity += quantity;
      }

      print('Total quantity: $totalQuantity');
    } catch (error) {
      print('Error calculating total quantity: $error');
    }

    return totalQuantity;
  }

  Future<void> fetchBatches(String medicineId) async {
    try {
      CollectionReference batchesRef = FirebaseFirestore.instance
          .collection('medicine')
          .doc(medicineId)
          .collection('batches');

      QuerySnapshot querySnapshot = await batchesRef.get();

      List<DocumentSnapshot> batches = querySnapshot.docs;
      for (DocumentSnapshot batch in batches) {
        // Access fields within the batch document
        String batchNumber = batch['batchNumber'];
        int quantity = batch['quantity'];
      }
    } catch (error) {
      print('Error fetching batches: $error');
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _dataList.length) {
      return null;
    }
    final Map<String, dynamic> data = _dataList[index];

    return DataRow.byIndex(index: index, cells: <DataCell>[
      // DataCell(FutureBuilder<void>(
      //   future: fetchBatches(data['medicine id']),
      //   builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       // While waiting for the future to complete, show a loading indicator
      //       return Text("Loading");
      //     } else if (snapshot.hasError) {
      //       // If an error occurred, display an error message
      //       return Text('Error: ${snapshot.error}');
      //     } else {
      //       // Return the desired widget with the fetched batch data
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text('Batch Number: ${batchNumber ?? "N/A"}'),
      //           Text('Quantity: ${quantity ?? "N/A"}'),
      //         ],
      //       );
      //     }
      //   },
      // )),
      DataCell(Text(data['category'].toString())),
      DataCell(Text(data['threshold'].toString())),
      // DataCell(
      //   data['medicine id'] != null
      //       ? FutureBuilder<int>(
      //           future: calculateTotalQuantity(data['medicine id']),
      //           builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return Text("Loading");
      //             } else if (snapshot.hasError) {
      //               return Text('Error: ${snapshot.error}');
      //             } else {
      //               int totalQuantity = snapshot.data ?? 0;
      //               return Text('$totalQuantity');
      //             }
      //           },
      //         )
      //       : Text("N/A"), // Default widget when 'medicine id' is null
      // ),
      DataCell(
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  String editedMedicineName = data['name'] ?? '';
                  int? editedThreshold = data['threshold'];
                  String editedCategory = data['category'] ?? '';
                  showDialog(
                    context: _context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Medicine'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Medicine Name'),
                                onChanged: (value) {
                                  editedMedicineName = value;
                                },
                                controller: TextEditingController(
                                    text: editedMedicineName),
                              ),
                              TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:
                                    InputDecoration(labelText: 'Threshold'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  editedThreshold = int.tryParse(value);
                                },
                                controller: TextEditingController(
                                    text: editedThreshold?.toString() ?? ''),
                              ),
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Category'),
                                onChanged: (value) {
                                  editedCategory = value;
                                },
                                controller:
                                    TextEditingController(text: editedCategory),
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
                              if (editedMedicineName != null &&
                                  editedThreshold != null &&
                                  editedCategory != null) {
                                final docRef = FirebaseFirestore.instance
                                    .collection('medicine')
                                    .doc(data['medicine id']);
                                docRef.update({
                                  'name': editedMedicineName,
                                  'threshold': editedThreshold,
                                  'category': editedCategory,
                                  // Add more fields to update if needed
                                });
                              }
                              // Perform the necessary logic to save the edited data
                              // For example, update the data in Firebase or any other data source
                              // using the editedMedicineName, editedThreshold, and editedCategory values

                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
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
