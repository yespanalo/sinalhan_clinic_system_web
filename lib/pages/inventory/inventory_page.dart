import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? recipientName;
  String? recipientContactNumber;

  TextEditingController expiryDateController = TextEditingController();
  TextEditingController manufacturingDateController = TextEditingController();

  List<Map<String, dynamic>> releaseList = [];
//Functions
  void showReleaseListDialog(
      BuildContext context, List<Map<String, dynamic>> releaseList) {
    String? medId;
    String? bchId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Release List'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Medicine Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(), // Empty container for spacing
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ...releaseList.map((release) {
                      String medicineName = release['medicineName'] +
                          "-" +
                          release['batchNumber'].toString();
                      int quantity = release['quantity'];
                      medId = release['medicineId'];
                      bchId = release['bchId'];

                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(medicineName),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Text(quantity.toString()),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Medicine'),
                                    content: Text(
                                      'Are you sure you want to delete this medicine from the release list?',
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
                                          setState(() {
                                            releaseList.remove(release);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    Text(
                      'Recipient Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Recipient Name',
                      ),
                      onChanged: (value) {
                        // Update the recipient name
                        recipientName = value;
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Recipient Contact Number',
                      ),
                      onChanged: (value) {
                        // Update the recipient contact number
                        recipientContactNumber = value;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                  ],
                );
              },
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
              onPressed: () async {
                // Perform any necessary logic with the updated release list
                print(releaseList);
                if (recipientName == null || recipientContactNumber == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Recipient name and contact number are required.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return; // Stop further execution
                }

                // Get the currently logged-in user's UID
                String? uid = FirebaseAuth.instance.currentUser?.uid;

                if (uid != null) {
                  // Retrieve the user's information from the "users" collection
                  DocumentSnapshot userSnapshot = await FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(uid)
                      .get();

                  // Get the first name and last name from the user's document
                  String firstName = userSnapshot.get('first name');
                  String lastName = userSnapshot.get('last name');

                  // Construct the "releasedBy" field value
                  String releasedBy = '$firstName $lastName';

                  // Construct the released medicines list with batch numbers
                  List<Map<String, dynamic>> releasedMedicineList =
                      releaseList.map((release) {
                    String medicineName = release['medicineName'];
                    int quantity = release['quantity'];
                    int batchNumber = release['batchNumber'];

                    return {
                      'medicineName': medicineName,
                      'quantity': quantity,
                      'batchNumber': batchNumber,
                    };
                  }).toList();

                  // Upload release information to Firestore
                  FirebaseFirestore.instance
                      .collection('released medicine')
                      .add({
                    'timestamp': DateTime.now(),
                    'recipientName': recipientName,
                    'recipientContactNumber': recipientContactNumber,
                    'releasedBy': releasedBy,
                    'releasedMedicine': releasedMedicineList,
                  }).then((value) {
                    // Document added successfully

                    print('Release information uploaded: ${value.id}');
                  }).catchError((error) {
                    // Error occurred while uploading document
                    print('Error uploading release information: $error');
                  });
                }
                for (var release in releaseList) {
                  String batchId = release['batchId'];
                  String medicineId = release['medicineId'];
                  int quantity = release['quantity'];

                  // Get the reference to the batch document within the "batches" subcollection
                  DocumentReference batchRef = FirebaseFirestore.instance
                      .collection('medicine')
                      .doc(medicineId)
                      .collection('batches')
                      .doc(batchId);

                  // Update the quantity field in the batch document
                  try {
                    await FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot batchSnapshot =
                          await transaction.get(batchRef);
                      if (batchSnapshot.exists) {
                        int oldQuantity = batchSnapshot.get('quantity');
                        int updatedQuantity = oldQuantity - quantity;

                        // Update the quantity field in the batch document
                        transaction
                            .update(batchRef, {'quantity': updatedQuantity});
                      }
                    });
                  } catch (e) {
                    // Handle any errors that occur during the transaction
                    print('Error updating quantity: $e');
                  }
                }
                recipientName = null;
                recipientContactNumber = null;
                releaseList.clear();

                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  List<String> toReleaseList = [];
  void addItemToReleaseList(String newItem) {
    setState(() {
      toReleaseList.add(newItem);
    });
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
        'batchNumber': 1,
        'batchId': detailsDocRef.id,
        'medicineName': medicineName,
        'medicineId': medicineRef.id,
        'quantity': quantity
      });

      print('Medicine data uploaded successfully!');
      setState(() {});
    } catch (error) {
      print('Error uploading medicine data: $error');
    }
  }

  void uploadnewBatchData(medicineId, medName) async {
    try {
      // Create a new document in the "medicine" collection
      DocumentReference medicineRef = FirebaseFirestore.instance
          .collection('medicine')
          .doc(medicineId)
          .collection('batches')
          .doc();
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('medicine')
          .doc(medicineId)
          .collection('batches');

      int batchNumber = await countDocuments(collectionRef);

      // Set the data for the medicine document
      await medicineRef.set({
        'expiryDate': expiryDate,
        'manufacturingDate': manufacturingDate,
        'batchNumber': batchNumber,
        'batchId': medicineRef.id,
        'medicineName': medName,
        'medicineId': medicineId,
        'quantity': quantity
      });

      print('Medicine data uploaded successfully!');
      setState(() {});
    } catch (error) {
      print('Error uploading medicine data: $error');
    }
  }

  Future<int> countDocuments(CollectionReference collectionRef) async {
    QuerySnapshot snapshot = await collectionRef.get();
    int count = snapshot.size;
    return count + 1;
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
  }

  void addNewBatch(medicineId, medName) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add new batch'),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
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
                onPressed: () async {
                  if (expiryDate != null &&
                      manufacturingDate != null &&
                      quantity != null) {
                    // Perform any necessary logic with the entered data

                    uploadnewBatchData(medicineId, medName);
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
                  double columnspacing = constraints.maxWidth / (5.5 + 1);
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor:
                          Colors.transparent, // Remove the lines between rows
                    ),
                    child: PaginatedDataTable(
                      columnSpacing: columnspacing,
                      source:
                          _MyDataTableSource(_dataList, context, addNewBatch),
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
                          'Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
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
    final Stream<QuerySnapshot> _batchesStream =
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
            Spacer(),
            SizedBox(
              width: 100,
              child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(15)),
                    // foregroundColor:
                    //     MaterialStateProperty.all<Color>(Colors.red),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryaccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: primaryaccent),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showReleaseListDialog(context, releaseList);
                  },
                  child: Text("Release",
                      style: TextStyle(fontSize: 16, color: Colors.white))),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        SizedBox(
            child: StreamBuilder<QuerySnapshot>(
          stream: _batchesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            List<QueryDocumentSnapshot> medicineDocs = snapshot.data!.docs;

            List<Future<List<QueryDocumentSnapshot>>> batchFutures = [];

            for (QueryDocumentSnapshot medicineDoc in medicineDocs) {
              CollectionReference batchesRef = FirebaseFirestore.instance
                  .collection('medicine')
                  .doc(medicineDoc.id)
                  .collection('batches');

              Future<List<QueryDocumentSnapshot>> batchQuery = batchesRef
                  .where('quantity',
                      isGreaterThan: 0) // Filter batches with quantity > 0
                  .get()
                  .then((QuerySnapshot batchSnapshot) => batchSnapshot.docs);

              batchFutures.add(batchQuery);
            }

            return FutureBuilder<List<List<QueryDocumentSnapshot>>>(
              future: Future.wait(batchFutures),
              builder: (BuildContext context,
                  AsyncSnapshot<List<List<QueryDocumentSnapshot>>>
                      batchSnapshot) {
                if (batchSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (batchSnapshot.hasError) {
                  return Text('Error: ${batchSnapshot.error}');
                }

                List<List<QueryDocumentSnapshot>> allBatches =
                    batchSnapshot.data!;
                List<DataRow> dataRows = [];
                int totalBatchCount = allBatches.fold<int>(
                  0,
                  (count, batchList) => count + batchList.length,
                );

                int rowsPerPage = totalBatchCount < 5 ? totalBatchCount : 5;
                return SingleChildScrollView(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor:
                          Colors.transparent, // Remove the lines between rows
                    ),
                    child: PaginatedDataTable(
                      columnSpacing:
                          MediaQuery.of(context).size.width / (8.5 + 1),
                      rowsPerPage: rowsPerPage,
                      columns: [
                        DataColumn(label: Text('Medicine Name')),
                        DataColumn(label: Text('Expiration Date')),
                        DataColumn(label: Text('Manufacturing Date')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text(''))
                      ],
                      source: BatchDataTableSource(
                          releaseList: releaseList,
                          context: context,
                          batches: batchSnapshot.data!
                              .expand((batchList) => batchList)
                              .toList()),
                    ),
                  ),
                );
              },
            );
          },
        ))
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

class BatchDataTableSource extends DataTableSource {
  final List<QueryDocumentSnapshot> batches;
  final BuildContext context;
  List<Map<String, dynamic>> releaseList;

  BatchDataTableSource(
      {required this.batches,
      required this.context,
      required this.releaseList});

  @override
  DataRow getRow(int index) {
    final batch = batches[index].data() as Map<String, dynamic>;
    final medicineName = batch['medicineName'];
    final batchNumber = batch['batchNumber'];
    final expiryDate = batch['expiryDate'].toDate();
    final expiryDateFormatted = DateFormat('MMMM d, y').format(expiryDate);
    final manufacturingDate = batch['manufacturingDate'].toDate();
    final manufacturingDateFormatted =
        DateFormat('MMMM d, y').format(manufacturingDate);

    final quantity = batch['quantity'];

    return DataRow(cells: [
      // DataCell(Text(medicineName)),
      DataCell(Text(medicineName.toString() + "-" + batchNumber.toString())),
      DataCell(Text(expiryDateFormatted.toString())),
      DataCell(Text(manufacturingDateFormatted.toString())),
      DataCell(Text(quantity.toString())),
      DataCell(
        Tooltip(
          message: 'Add to Release List',
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: secondaryaccent,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 2.0, color: secondaryaccent),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 15,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String medicineName =
                        ''; // Variable to store the selected medicine name
                    int quantity = 0; // Variable to store the selected quantity

                    return AlertDialog(
                      title: Text('Add to Release List'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text('Enter the quantity:'),
                            TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(5),
                              ],
                              onChanged: (value) {
                                quantity = int.tryParse(value) ?? 0;
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
                            // Add the selected medicine name and quantity to the release list
                            if (quantity > 0 && quantity <= batch['quantity']) {
                              // Add the medicine to the release list
                              releaseList.add({
                                'medicineName': batch['medicineName'],
                                'quantity': quantity,
                                'batchNumber': batchNumber,
                                'batchId': batch['batchId'],
                                'medicineId': batch['medicineId']
                              });

                              Navigator.of(context).pop();
                            } else {
                              // Show an error message or alert
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Invalid Quantity'),
                                    content:
                                        Text('Please enter a valid quantity.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  int get rowCount => batches.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class _MyDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;
  final BuildContext _context;
  Function(String, String) addnewBatchCallback;

  _MyDataTableSource(this._dataList, this._context, this.addnewBatchCallback);

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
    int quantity = 0;

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['category'].toString())),
      DataCell(Text(data['threshold'].toString())),
      DataCell(
        data['medicine id'] != null
            ? FutureBuilder<int>(
                future: calculateTotalQuantity(data['medicine id']),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int totalQuantity = snapshot.data ?? 0;
                    if (totalQuantity < data['threshold']) {
                      return Tooltip(
                        message: 'Low on Stocks!',
                        child: Text('$totalQuantity',
                            style: TextStyle(color: Colors.red)),
                      );
                    }
                    return Text('$totalQuantity');
                  }
                },
              )
            : Text("N/A"), // Default widget when 'medicine id' is null
      ),
      DataCell(
        Row(
          children: [
            Tooltip(
              message: 'Edit',
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 2.0, color: Colors.grey),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 15,
                    color: Colors.white,
                  ),
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
                                  decoration: InputDecoration(
                                      labelText: 'Medicine Name'),
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
                                  controller: TextEditingController(
                                      text: editedCategory),
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
            ),
            SizedBox(
              width: 10,
            ),
            Tooltip(
              message: 'Replenish Stocks',
              child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: secondaryaccent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 2.0, color: secondaryaccent),
                  ),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.box,
                      color: Colors.white,
                    ),
                    iconSize: 15,
                    onPressed: () async {
                      addnewBatchCallback(data['medicine id'], data['name']);
                    },
                  )),
            )
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
