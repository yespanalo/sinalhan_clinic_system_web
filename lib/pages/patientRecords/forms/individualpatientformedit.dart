import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../../constants copy.dart';

class IndividualPatientEditForm extends StatefulWidget {
  const IndividualPatientEditForm({required this.uid, Key? key})
      : super(key: key);

  final String uid;
  @override
  State<IndividualPatientEditForm> createState() =>
      _IndividualPatientEditFormState();
}

class _IndividualPatientEditFormState extends State<IndividualPatientEditForm> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference patientsCollection = firestore.collection('patients');

    return FutureBuilder<DocumentSnapshot>(
      future: patientsCollection.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Handle case where the form doesn't exist
          return Text('Form not found.');
        }

        // Form data exists, populate the form fields with the retrieved values
        var formData = snapshot.data!.data() as Map<String, dynamic>;

        TextEditingController firstname = new TextEditingController()
          ..text = formData['first name'];
        TextEditingController middlename = new TextEditingController()
          ..text = formData['middle name'];
        TextEditingController lastname = new TextEditingController()
          ..text = formData['last name'];
        TextEditingController birthdateController = new TextEditingController()
          ..text = formData['birthdate'];
        TextEditingController contactNumber = new TextEditingController()
          ..text = formData['contact number'];
        TextEditingController streetController = new TextEditingController()
          ..text = formData['address'];
        TextEditingController cityController = new TextEditingController()
          ..text = formData['address'];
        TextEditingController provinceController = new TextEditingController()
          ..text = formData['address'];
        TextEditingController emailController = new TextEditingController()
          ..text = formData['email'];
        TextEditingController religionController = new TextEditingController()
          ..text = formData['religion'];
        TextEditingController occupationController = new TextEditingController()
          ..text = formData['occupation'];
        TextEditingController motherName = new TextEditingController()
          ..text = formData['mothers name'];
        TextEditingController fatherName = new TextEditingController()
          ..text = formData['fathers name'];

        // TextEditingController lastMensController = new TextEditingController()
        //   ..text = formData['last mens'];

        var _text;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "PHILIPPINE HEALTH INSURANCE CORPORATION",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                                Text(
                                  "SANTA ROSA CITY HEALTH OFFICE 1",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  "INDIVIDUAL HEALTH PROFILE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(),
                              ],
                            ),
                            Header(
                              text: "General Patient Information",
                            ),
                            Header(text: "Sign up with email"),
                            email(
                              emailController,
                            ),
                            NameWidget(firstname, middlename, lastname),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 30, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Patient Birthdate",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 330,
                                    child: TextField(
                                      readOnly: true,
                                      onChanged: (text) =>
                                          setState(() => _text),
                                      controller: birthdateController,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 0.5, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 0.5, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      onTap: () async {
                                        DateTime date = DateTime(1900);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        date = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime(2021),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100)))!;
                                        birthdateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(date);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Address(streetController, cityController,
                                provinceController),
                            phoneNumber(contactNumber),
                            religion(religionController),
                            occupation(occupationController),
                            mothersName(motherName),
                            fathersName(fatherName),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 10, left: 20, right: 20),
                                  width: 400,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      addIndividualPatient();
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              secondaryaccent),
                                    ),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 10, left: 20, right: 20),
                                  width: 400,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // LastMens(lastMensController),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container fathersName(TextEditingController fatherName) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Father's Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: fatherName,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container mothersName(TextEditingController motherName) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mother's Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: motherName,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ],
      ),
    );
  }
  // Container LastMens(TextEditingController lastMensController) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Text(
  //         "Last Menstruation Period",
  //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
  //       ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         height: 40,
  //         width: 330,
  //         child: TextField(
  //           readOnly: true,
  //           controller: lastMensController,
  //           decoration: InputDecoration(
  //               hintText: "Please enter last menstruation period",
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: const BorderSide(width: 0.5, color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderSide: const BorderSide(width: 0.5, color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(5),
  //               )),
  //           onTap: () async {
  //             DateTime date = DateTime(1900);
  //             FocusScope.of(context).requestFocus(new FocusNode());
  //             date = (await showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime(2021),
  //                 firstDate: DateTime(1900),
  //                 lastDate: DateTime(2100)))!;
  //             lastMensController.text = DateFormat('yyy-MM-dd').format(date);
  //           },
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  // Container patiendMedicalHistory(
  //     TextEditingController controller, String heading) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "$heading",
  //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(
  //           height: 100,
  //           width: double.infinity,
  //           child: TextField(
  //             controller: controller,
  //             textAlignVertical: TextAlignVertical.top,
  //             expands: true,
  //             keyboardType: TextInputType.multiline,
  //             maxLines: null,
  //             decoration: InputDecoration(
  //                 contentPadding: EdgeInsets.only(left: 5, top: 2, bottom: 2),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide:
  //                       const BorderSide(width: 0.5, color: Colors.grey),
  //                   borderRadius: BorderRadius.circular(5),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide:
  //                       const BorderSide(width: 0.5, color: Colors.grey),
  //                   borderRadius: BorderRadius.circular(5),
  //                 )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Container occupation(TextEditingController occupationController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Occupation",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: occupationController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container religion(TextEditingController religionController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Religion",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: religionController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container email(TextEditingController emailController) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter email ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "example@example.com",
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "example@example.com",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container phoneNumber(TextEditingController contactNumber) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phone Number",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 330,
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
              ],
              controller: contactNumber,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please enter a valid phone number.",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Container Address(
      TextEditingController streetController,
      TextEditingController cityController,
      TextEditingController provinceController) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                child: TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Street Address",
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 330,
                        height: 40,
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "City",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 330,
                        height: 40,
                        child: TextField(
                          controller: provinceController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 0.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Province",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container NameWidget(TextEditingController firstname,
      TextEditingController middlename, TextEditingController lastname) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: firstname,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "First Name",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: middlename,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Middle Name",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 215,
                    height: 40,
                    child: TextField(
                      controller: lastname,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void addIndividualPatient() {}

class Header extends StatelessWidget {
  const Header({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "$text",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
        ],
      ),
    );
  }
}
