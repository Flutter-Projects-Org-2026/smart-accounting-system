import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'dashboard_screen.dart';
import '../services_screen/services_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    _PlaceholderScreen(title: 'الفواتير', icon: Icons.receipt_long_rounded),
    _PlaceholderScreen(title: 'المصروفات', icon: Icons.account_balance_wallet_rounded),
    ServicesScreen(),
    _PlaceholderScreen(title: 'التقارير', icon: Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: Container(
        width: 58,
        height: 58,
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 18,
                offset: const Offset(0, 8)),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.bar_chart_rounded, 'التقارير', 4),
            _navItem(Icons.account_balance_wallet_rounded, 'المصروفات', 2),
            const SizedBox(width: 50),
            _navItem(Icons.receipt_long_rounded, 'الفواتير', 1),
            _navItem(Icons.home_rounded, 'الرئيسية', 0),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: selected ? AppColors.primaryLight : AppColors.textHint,
                size: 22),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.cairo(
                    color: selected ? AppColors.primaryLight : AppColors.textHint,
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title,
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: AppColors.textHint),
            const SizedBox(height: 14),
            Text('قريباً...',
                style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}