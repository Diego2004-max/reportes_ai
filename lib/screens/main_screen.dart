import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'reports/report_list_screen.dart';
import 'map/map_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    ReportListScreen(),
    ProfileScreen(),
  ];

  void _handleNavigation(int index) {
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aquí irá crear reporte'),
        ),
      );
      return;
    }

    setState(() {
      if (index == 0) {
        _currentIndex = 0; // Inicio
      } else if (index == 1) {
        _currentIndex = 1; // Mapa
      } else if (index == 3) {
        _currentIndex = 2; // Reportes
      } else if (index == 4) {
        _currentIndex = 3; // Perfil
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }
}