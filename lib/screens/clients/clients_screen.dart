import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../models/client_model.dart';
import 'client_form_screen.dart';
import 'client_detail_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<ClientProvider>().listenToClients(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('العملاء',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Column(
        children: [
          // ← بطاقتي الإجمالي (له / عليه)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                      'إجمالي لك (له)', provider.totalLahu, AppColors.success),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _summaryCard(
                      'إجمالي عليك', provider.totalAlayhi, AppColors.danger),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ← شريط البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: provider.setSearchQuery,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ابحث عن عميل...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.clients.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                        itemCount: provider.clients.length,
                        itemBuilder: (context, index) =>
                            _clientCard(provider.clients[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ClientFormScreen())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _summaryCard(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.cairo(
                  color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Text('${value.toStringAsFixed(0)} ${AppConstants.currency}',
              style: GoogleFonts.cairo(
                  color: color, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('لا يوجد عملاء بعد',
              style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('اضغط + لإضافة عميل جديد',
              style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _clientCard(ClientModel client) {
    final isPositive = client.balance >= 0;
    final statusColor = client.balance == 0
        ? AppColors.textHint
        : (isPositive ? AppColors.success : AppColors.danger);
    final statusLabel = client.balance == 0
        ? 'لا يوجد رصيد'
        : (isPositive ? 'له عندك' : 'عليه لك');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ClientDetailScreen(client: client)),
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              client.name.isNotEmpty ? client.name.characters.first : '؟',
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
        title: Text(client.name,
            style: GoogleFonts.cairo(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(client.phone.isNotEmpty ? client.phone : 'لا يوجد رقم',
              style: GoogleFonts.cairo(color: AppColors.textHint, fontSize: 12)),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${client.balance.abs().toStringAsFixed(0)} ${AppConstants.currency}',
              style: GoogleFonts.cairo(
                  color: statusColor, fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(statusLabel,
                style: GoogleFonts.cairo(color: statusColor, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}