import 'package:flutter/material.dart';

import 'package:reportes_ai/features/home/presentation/screens/home_screen.dart';
import 'package:reportes_ai/features/map/presentation/screens/map_screen.dart';
import 'package:reportes_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:reportes_ai/features/reports/presentation/screens/create_report_screen.dart';
import 'package:reportes_ai/features/reports/presentation/screens/report_list_screen.dart';
import 'package:reportes_ai/shared/widgets/bottom_nav_bar.dart';

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
    Navigator.of(context).push(
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