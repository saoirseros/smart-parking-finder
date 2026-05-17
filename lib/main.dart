import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  
  FirebaseDatabase.instance.databaseURL =
      "https://smart-parking-finder-mshrums-default-rtdb.asia-southeast1.firebasedatabase.app";


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Parking Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapScreen(),
    );
  }
}