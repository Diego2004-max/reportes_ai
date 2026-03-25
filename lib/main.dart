import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const ReportesIAApp());
}

class ReportesIAApp extends StatelessWidget {
  const ReportesIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reportes IA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}