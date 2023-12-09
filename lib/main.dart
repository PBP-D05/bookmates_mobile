import 'package:bookmates_mobile/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(248, 197, 55, 0)),
        useMaterial3: true,
        fontFamily: 'Kavoon',
      ),
      home: DashboardPage(),
    );
  }
}