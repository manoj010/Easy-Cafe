import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_top_bar.dart';
import 'admin/dashboard_screen.dart';
import 'admin/expenses_screen.dart';
import 'admin/financials_screen.dart';
import 'admin/menu_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExpensesScreen(),
    FinancialsScreen(),
    MenuScreen(),
  ];

  final List<CafeNavItem> _navItems = const [
    CafeNavItem(icon: Icons.dashboard, label: 'DASHBOARD'),
    CafeNavItem(icon: Icons.payments, label: 'EXPENSES'),
    CafeNavItem(icon: Icons.account_balance, label: 'FINANCE'),
    CafeNavItem(icon: Icons.restaurant_menu, label: 'MENU'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CafeAppBar(
        profileImageUrl: dotenv.env['ADMIN_PROFILE_IMAGE'],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CafeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}
