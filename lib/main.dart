import 'package:flutter/material.dart';
import 'package:interview_task/views/bottom_bar/bottom_bar_screen.dart';

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
        fontFamily: 'Mulish', 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomBottomNavigationBar(),
    );
  }
}