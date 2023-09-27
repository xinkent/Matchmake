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
      darkTheme: ThemeData(
        primaryColor: Colors.indigo, // よりダークなプライマリカラー
        accentColor: Colors.amberAccent, // アクセントカラー
        fontFamily: 'Montserrat', // フォントファミリー
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo, // よりダークなAppBarの背景色
          titleTextStyle:
              TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          toolbarTextStyle:
              TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.amberAccent, // ElevatedButtonの背景色
        //     foregroundColor: Colors.indigo, // テキスト色
        //     textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        //   ),
        // ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amberAccent, // FloatingActionButtonの背景色
          foregroundColor: Colors.indigo, // アイコンの色
        ),
        iconTheme: const IconThemeData(
          color: Colors.indigo, // よりダークなアイコンの色
          size: 32.0,
        ),
      ),
      // theme: ThemeData.dark(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      themeMode: ThemeMode.dark,
      home: const MatchHomePage(),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
    );
  }
}
