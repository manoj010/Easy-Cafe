import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_top_bar.dart';
import 'user/orders_screen.dart';
import 'user/stock_screen.dart';
import 'user/notes_screen.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OrdersScreen(),
    StockScreen(),
    NotesScreen(),
  ];

  final List<CafeNavItem> _navItems = const [
    CafeNavItem(icon: Icons.list_alt, label: 'ORDERS'),
    CafeNavItem(icon: Icons.inventory_2, label: 'STOCK'),
    CafeNavItem(icon: Icons.description, label: 'NOTES'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CafeAppBar(
        profileImageUrl: dotenv.env['USER_PROFILE_IMAGE'],
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
