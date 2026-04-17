import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const ReportesIAApp());
}

class ReportesIAApp extends StatelessWidget {
  const ReportesIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reportes AI',
      theme: AppTheme.light,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}