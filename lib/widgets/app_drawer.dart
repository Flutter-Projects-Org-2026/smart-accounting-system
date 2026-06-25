import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../screens/ai_assistant/ai_assistant_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Drawer(
      backgroundColor: AppColors.surface,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        (auth.user?.name.isNotEmpty == true)
                            ? auth.user!.name.characters.first
                            : 'A',
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auth.user?.name ?? 'مستخدم',
                            style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                        Text('مدير الحساب',
                            style: GoogleFonts.cairo(
                                color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),

            _drawerItem(context, Icons.home_rounded, 'الرئيسية',
                selected: true),
            _drawerItem(context, Icons.receipt_long_rounded, 'الفواتير'),
            _drawerItem(
                context, Icons.account_balance_wallet_rounded, 'المصروفات'),
            _drawerItem(context, Icons.people_alt_rounded, 'العملاء'),
            _drawerItem(context, Icons.local_shipping_rounded, 'الموردين'),
            _drawerItem(
                context, Icons.design_services_rounded, 'المنتجات والخدمات'),

            // إضافة زر المساعد الذكي مع دالة الانتقال الخاصة به هنا 👇
            _drawerItem(context, Icons.auto_awesome, 'المساعد الذكي',
                onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AiAssistantScreen()));
            }),

            _drawerItem(context, Icons.bar_chart_rounded, 'التقارير'),
            _drawerItem(context, Icons.settings_rounded, 'الإعدادات'),

            const Spacer(),
            Divider(color: AppColors.border, height: 1),
            ListTile(
              leading:
                  const Icon(Icons.logout_rounded, color: AppColors.danger),
              title: Text('تسجيل الخروج',
                  style: GoogleFonts.cairo(
                      color: AppColors.danger, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().signOut();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // قمنا بتحديث الدالة هنا لاستقبال معامل onTap اختياري
  Widget _drawerItem(BuildContext context, IconData icon, String label,
      {bool selected = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon,
            color: selected ? Colors.white : AppColors.textSecondary, size: 22),
        title: Text(label,
            style: GoogleFonts.cairo(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14)),
        // إذا تم تمرير وظيفة معينة سينفذها، وإلا سيقوم فقط بإغلاق القائمة كالمعتاد
        onTap: onTap ?? () => Navigator.pop(context),
      ),
    );
  }
}
