import 'package:flutter/material.dart';
import 'package:lima_soko/pages/farmer/farmer_home_page.dart';
import 'package:lima_soko/pages/home_page.dart';
import 'package:lima_soko/pages/product_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lima Soko',
      theme: ThemeData(       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FarmerHomePage(),
    );
  }
}


