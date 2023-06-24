import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sinalhan_clinic_system_web/constants.dart';
import 'package:sinalhan_clinic_system_web/pages/patientRecords/forms/individualpatientform.dart';

class categorySelection extends StatefulWidget {
  const categorySelection({Key? key}) : super(key: key);

  @override
  State<categorySelection> createState() => _categorySelectionState();
}

class _categorySelectionState extends State<categorySelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please Select Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ],
          ),
          longsizedbox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualPatientRecordForm(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      // Set the fill color to red
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the border radius
                      border: Border.all(
                        color: secondaryaccent, // Set the border color to blue
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.person,
                          color: secondaryaccent,
                        ),
                        Center(
                          child: Text(
                            "Individual Patient",
                            style: TextStyle(
                                color: secondaryaccent,
                                fontWeight: FontWeight
                                    .bold // Set the font color to white
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualPatientRecordForm(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      // Set the fill color to red
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the border radius
                      border: Border.all(
                        color: secondaryaccent, // Set the border color to blue
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.personPregnant,
                          color: secondaryaccent,
                        ),
                        Center(
                          child: Text(
                            "Pre-Natal",
                            style: TextStyle(
                                color: secondaryaccent,
                                fontWeight: FontWeight
                                    .bold // Set the font color to white
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualPatientRecordForm(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      // Set the fill color to red
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the border radius
                      border: Border.all(
                        color: secondaryaccent, // Set the border color to blue
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.baby,
                          color: secondaryaccent,
                        ),
                        Center(
                          child: Text(
                            "Well-Baby",
                            style: TextStyle(
                                color: secondaryaccent,
                                fontWeight: FontWeight
                                    .bold // Set the font color to white
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
            width: 390,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
