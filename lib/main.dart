import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sinalhan_clinic_system_web/home.dart';
import 'package:sinalhan_clinic_system_web/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC40tdyqJHY2401tvUyOhHgOFJrMuEMYbE",
          appId: "1:495983995990:web:715279e358d706489d1ff7",
          messagingSenderId: "495983995990",
          projectId: "sinalhan-clinic-system"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return Home();
      //     } else {
      //       return LoginPage();
      //     }
      //   },
      // ),
    );
  }
}
