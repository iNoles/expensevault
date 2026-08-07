import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/receipts/receipt_list_screen.dart';
import '../features/dashboard/category_chart_screen.dart';
import 'expressive_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  final screens = const [
    DashboardScreen(),
    ReceiptListScreen(),
    CategoryChartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: ExpressiveBottomNav(
        index: index,
        onIndexChanged: (i) => setState(() => index = i),
      ),
    );
  }
}
