import 'package:flutter/material.dart';
import 'package:matchmake/screens/home.dart';
import 'package:matchmake/screens/match_home.dart';
import 'package:matchmake/screens/member_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const MatchHomePage(),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
    );
  }
}
