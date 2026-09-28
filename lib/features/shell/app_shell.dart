import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/arc_bottom_nav.dart';
import '../home/home_screen.dart';
import '../cards/cards_screen.dart';
import '../arcs/arcs_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onNavigateToCards: () => _onTabChanged(1),
            onNavigateToArcs: () => _onTabChanged(2),
          ),
          CardsScreen(
            onStartAnArc: () => _onTabChanged(2),
          ),
          const ArcsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ArcBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
