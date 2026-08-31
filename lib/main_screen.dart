import 'package:flutter/material.dart';
import 'sales_screen.dart';
import 'products_screen.dart';
import 'invoices_screen.dart';

/// ============================================================
/// الشاشة الرئيسية للتطبيق (تتحكم بالتنقل بين الشاشات عبر BottomNavigationBar)
/// ============================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // الفهرس الحالي للشاشة المعروضة
  int _currentIndex = 0;

  // قائمة الشاشات الفرعية للتطبيق
  final List<Widget> _screens = const [
    SalesScreen(),     // شاشة المبيعات (الرئيسية/الكاشير)
    ProductsScreen(),  // شاشة إدارة المنتجات والرمز الشريط
    InvoicesScreen(),  // شاشة سجل الفواتير والتقارير
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // عرض الشاشة المحددة بناءً على الفهرس الحالي
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'المبيعات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'المنتجات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'الفواتير',
          ),
        ],
      ),
    );
  }
}
