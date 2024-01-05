// ignore_for_file: prefer_const_constructors

import 'package:ecommerce/app-color.dart';
import 'package:ecommerce/categories.dart';
import 'package:ecommerce/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Commerce',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
           centerTitle: true, // Başlığı ortala
           backgroundColor: AppColors.lightCoral,
        ),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

