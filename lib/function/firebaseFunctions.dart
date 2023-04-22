import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  static saveUser(
      String firstName, lastName, mobileNuber, email, type, uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'first name': firstName,
      'last name': lastName,
      'mobile number': mobileNuber,
      'type': type,
      'uid': uid
    });
  }

  static updateUserField(
      String userId, String firstName, lastName, mobileNuber, email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
          'email': email,
          'first name': firstName,
          'last name': lastName,
          'mobile number': mobileNuber,
        })
        .then((value) => print('User field updated'))
        .catchError((error) => print('Failed to update user field: $error'));
  }

  static addIndividualPatient(
      String firstName, lastName, middleName, email, mobileNumber) async {
    String initials = 'IPR'; // Set the initials to whatever you want.
    String customID =
        '$initials-${FirebaseFirestore.instance.collection('patients').doc().id}';
    await FirebaseFirestore.instance.collection('patients').doc(customID).set({
      'first name': firstName,
      'last name': lastName,
      'middle name': middleName,
      'category': "Individual Patient Record",
      'email': email,
      'contact number': mobileNumber,
      'uid': customID
    });
  }
}
