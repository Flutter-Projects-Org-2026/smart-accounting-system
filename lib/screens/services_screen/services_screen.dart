import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';
import 'service_form_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<ServiceProvider>().listenToServices(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الخدمات',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          // ← شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: provider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          // ← فلتر الفئات
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('الكل', provider),
                ...AppConstants.serviceCategories
                    .map((cat) => _buildCategoryChip(cat, provider)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ← إحصائيات سريعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _statCard('إجمالي الخدمات', '${provider.totalServices}',
                    AppColors.primary, Icons.design_services_rounded),
                const SizedBox(width: 12),
                _statCard('الخدمات النشطة', '${provider.activeServices}',
                    AppColors.success, Icons.check_circle_rounded),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ← القائمة
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.services.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.services.length,
                        itemBuilder: (context, index) =>
                            _serviceCard(provider.services[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ServiceFormScreen())),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('إضافة خدمة',
            style: GoogleFonts.cairo(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildCategoryChip(String label, ServiceProvider provider) {
    final isSelected = provider.selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label, style: GoogleFonts.cairo(fontSize: 13)),
        selected: isSelected,
        onSelected: (_) => provider.setCategory(label),
        selectedColor: AppColors.primaryLight,
        labelStyle: GoogleFonts.cairo(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        backgroundColor: AppColors.surface,
        side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: GoogleFonts.cairo(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(label,
                      style: GoogleFonts.cairo(
                          fontSize: 11, color: AppColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.design_services_outlined,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('لا توجد خدمات بعد',
              style: GoogleFonts.cairo(
                  fontSize: 16, fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('اضغط + لإضافة خدمة جديدة',
              style: GoogleFonts.cairo(
                  fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _serviceCard(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => ServiceFormScreen(service: service))),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: service.isActive
                ? AppColors.successLight
                : AppColors.dangerLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.design_services_rounded,
            color: service.isActive ? AppColors.success : AppColors.danger,
          ),
        ),
        title: Text(service.name,
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(service.category,
                    style: GoogleFonts.cairo(
                        fontSize: 11, color: AppColors.primary)),
              ),
            ],
          ),
        ),
        trailing: Text(
          '${service.price.toStringAsFixed(0)} ${AppConstants.currency}',
          style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.primary),
        ),
      ),
    );
  }
}