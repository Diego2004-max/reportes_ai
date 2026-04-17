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

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const MapScreen();
      case 2:
        return const ReportListScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _buildCurrentScreen(),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        onCreateTap: _onCreateReportTap,
      ),
    );
  }
}