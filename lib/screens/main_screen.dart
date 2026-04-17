import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'reports/report_list_screen.dart';
import 'map/map_screen.dart';
import 'profile/profile_screen.dart';
import 'reports/create_report_screen.dart';

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

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCreateReportTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateReportScreen(),
      ),
    );
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
        onTabSelected: _onTabSelected,
        onCreateTap: _onCreateReportTap,
      ),
    );
  }
}