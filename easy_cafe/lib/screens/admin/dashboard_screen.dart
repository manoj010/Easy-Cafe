import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header
              Text('Daily Performance',
                  style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('Monday, Oct 23rd • Sun-drenched Morning',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  _actionButton(Icons.calendar_today, 'Past 7 Days', false),
                  const SizedBox(width: 10),
                  _actionButton(Icons.add, 'New Entry', true),
                ],
              ),
              const SizedBox(height: 20),

              // Summary Cards Grid
              _buildSummaryGrid(),
              const SizedBox(height: 20),

              // Income vs Expenses Chart
              _buildChartSection(),
              const SizedBox(height: 20),

              // Staff Notes
              _buildStaffNotes(),
              const SizedBox(height: 20),

              // Live Orders
              _buildLiveOrders(),
              const SizedBox(height: 20),

              // Stock Health
              _buildStockHealth(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, bool isPrimary) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: isPrimary ? AppColors.leatherGradient : null,
        color: isPrimary ? null : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isPrimary
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isPrimary ? Colors.white : AppColors.primary),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: isPrimary ? Colors.white : AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _summaryCard('TODAY\'S SALES', '\$1,284.50', Icons.trending_up, const Color(0xFFDCFCE7), const Color(0xFF15803D), '+12.5%')),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard('TODAY\'S EXPENSES', '\$412.00', Icons.shopping_cart_checkout, AppColors.errorContainer.withValues(alpha: 0.4), AppColors.error, '-3.2%')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _summaryCard('NET PROFIT', '\$872.50', Icons.account_balance_wallet, AppColors.secondaryContainer.withValues(alpha: 0.4), AppColors.secondary, null)),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard('ORDERS COUNT', '142', Icons.restaurant, AppColors.primary.withValues(alpha: 0.1), AppColors.primary, null)),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color iconBg, Color iconColor, String? badge) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badge.startsWith('+') ? const Color(0xFFF0FDF4) : AppColors.errorContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badge,
                      style: GoogleFonts.manrope(
                          fontSize: 11, fontWeight: FontWeight.w700, color: badge.startsWith('+') ? const Color(0xFF15803D) : AppColors.error)),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    final barHeights = [0.40, 0.55, 0.45, 0.70, 0.60, 0.85, 0.75];
    final expenseHeights = [0.15, 0.10, 0.25, 0.12, 0.30, 0.15, 0.20];
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.02), blurRadius: 12, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Income vs Expenses',
                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Text('Real-time revenue flow tracking',
                      style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
                ],
              ),
              Row(
                children: [
                  _legendDot(AppColors.primary, 'INCOME'),
                  const SizedBox(width: 12),
                  _legendDot(AppColors.secondaryContainer, 'EXPENSES'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 180 * barHeights[i],
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: 180 * expenseHeights[i],
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((d) => Text(d, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildStaffNotes() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text('Staff Notes', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          _noteCard('Restock Almond Milk by Wednesday. Inventory low.', '08:45 AM', 'INVENTORY', AppColors.secondary),
          const SizedBox(height: 10),
          _noteCard('Espresso machine #2 requires a deep descaling tomorrow.', '10:12 AM', 'MAINTENANCE', AppColors.primary),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text('VIEW ALL NOTES',
                  style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(String text, String time, String tag, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: tagColor.withValues(alpha: 0.4), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
              Text(tag, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: tagColor, letterSpacing: 1.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveOrders() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Orders', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('8 Pending', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _liveOrderTile('#42', '2x Flat White, 1x Croissant', 'Table 05 • 4 mins ago', 'Preparing', AppColors.secondary),
          const SizedBox(height: 8),
          _liveOrderTile('#41', '1x Iced Latte, 1x Avocado Toast', 'Takeaway • 7 mins ago', 'Ready', const Color(0xFF15803D)),
        ],
      ),
    );
  }

  Widget _liveOrderTile(String id, String items, String meta, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
            child: Center(child: Text(id, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(items, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                Text(meta, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHealth() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Health', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 20),
          _stockBar('COFFEE BEANS (ETHIOPIAN GOLD)', '12.5 / 20 kg', 0.625, AppColors.primary),
          const SizedBox(height: 16),
          _stockBar('OAT MILK (BARISTA EDITION)', '4 / 48 units', 0.08, AppColors.error),
          const SizedBox(height: 16),
          _stockBar('DISPOSABLE CUPS (L)', '850 / 1000 units', 0.85, AppColors.primary),
        ],
      ),
    );
  }

  Widget _stockBar(String name, String amount, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
            Text(amount, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: color == AppColors.error ? AppColors.error : AppColors.onSurface)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(4)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ),
      ],
    );
  }
}
