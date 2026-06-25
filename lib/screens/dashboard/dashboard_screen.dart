import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final firstName = (auth.user?.name.isNotEmpty == true)
        ? auth.user!.name.split(' ').first
        : '';
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.notifications_outlined,
                  color: AppColors.textSecondary, size: 18),
            ),
            onPressed: () {},
          ),
        ),
        title: Column(
          children: [
            Text('مرحباً، $firstName 👋',
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('نظرة سريعة على نشاطك اليوم',
                style: GoogleFonts.cairo(
                    fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 80 + bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ← بطاقة الرصيد الإجمالي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إجمالي الرصيد',
                          style: GoogleFonts.cairo(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('125,750.50',
                          style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('ريال سعودي',
                          style: GoogleFonts.cairo(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12)),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ← الإحصائيات الثلاثة
            Row(
              children: [
                Expanded(
                    child: _statCard(
                        'المصروفات', '24,850', '8.5%', false, AppColors.danger)),
                const SizedBox(width: 10),
                Expanded(
                    child: _statCard(
                        'الإيرادات', '68,950', '12.5%', true, AppColors.success)),
                const SizedBox(width: 10),
                Expanded(
                    child: _statCard(
                        'الأرباح', '44,100', '7.3%', true, AppColors.info)),
              ],
            ),

            const SizedBox(height: 18),

            // ← نظرة عامة (الرسم الدائري)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('نظرة عامة',
                          style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Text('هذا الشهر',
                              style: GoogleFonts.cairo(
                                  color: AppColors.textHint, fontSize: 12)),
                          const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.textHint, size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(110, 110),
                              painter: _DonutPainter(),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('68,950',
                                    style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                                Text('إجمالي الإيرادات',
                                    style: GoogleFonts.cairo(
                                        color: AppColors.textHint,
                                        fontSize: 9)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _legendRow(AppColors.chartBlue, 'المبيعات', '60%'),
                            const SizedBox(height: 10),
                            _legendRow(AppColors.chartGreen, 'الخدمات', '25%'),
                            const SizedBox(height: 10),
                            _legendRow(AppColors.chartOrange, 'منتجات', '10%'),
                            const SizedBox(height: 10),
                            _legendRow(AppColors.textHint, 'أخرى', '5%'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الفواتير الأخيرة',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text('عرض الكل',
                    style: GoogleFonts.cairo(
                        color: AppColors.primaryLight, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),

            _invoiceTile('#INV-2024-015', 'عميل: شركة النور', '5,250.00',
                'مدفوعة', AppColors.success),
            _invoiceTile('#INV-2024-014', 'عميل: مؤسسة الإبداع', '3,750.00',
                'معلقة', AppColors.warning),
            _invoiceTile('#INV-2024-013', 'عميل: محمد أحمد', '2,980.00',
                'مدفوعة', AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, String percent, bool isUp, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.cairo(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color, size: 11),
              const SizedBox(width: 2),
              Text(percent,
                  style: GoogleFonts.cairo(color: color, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.cairo(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        Text(value,
            style: GoogleFonts.cairo(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _invoiceTile(String id, String client, String amount, String status,
      Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.info, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id,
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(client,
                    style:
                        GoogleFonts.cairo(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(status,
                  style: GoogleFonts.cairo(color: statusColor, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 10.0;

    final segments = [
      {'value': 0.60, 'color': AppColors.chartBlue},
      {'value': 0.25, 'color': AppColors.chartGreen},
      {'value': 0.10, 'color': AppColors.chartOrange},
      {'value': 0.05, 'color': AppColors.textHint},
    ];

    double startAngle = -1.5708;
    for (final seg in segments) {
      final sweep = 6.2832 * (seg['value'] as double);
      final paint = Paint()
        ..color = seg['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweep - 0.05, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}