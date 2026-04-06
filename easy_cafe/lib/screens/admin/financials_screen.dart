import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/sample_data.dart';

class FinancialsScreen extends StatelessWidget {
  const FinancialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header
              Text('FINANCIAL OVERSIGHT',
                  style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text('Bank & Cash',
                  style: GoogleFonts.plusJakartaSans(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5)),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(child: _actionBtn(Icons.file_download, 'Export\nReport', false)),
                  const SizedBox(width: 10),
                  Expanded(child: _actionBtn(Icons.save, 'Submit\nEntry', true)),
                ],
              ),
              const SizedBox(height: 20),

              // Balance Cards
              _balanceCard('Current Bank Balance', '\$42,850.40', Icons.account_balance, AppColors.secondary, 'UPDATED 2H AGO'),
              const SizedBox(height: 12),
              _balanceCard('Petty Cash On Hand', '\$1,245.00', Icons.payments, AppColors.onSecondaryContainer, 'DRAWER 01'),
              const SizedBox(height: 16),

              // Daily Tip
              _buildDailyTip(),
              const SizedBox(height: 20),

              // Daily Entry Manual Log
              _buildEntryForm(),
              const SizedBox(height: 20),

              // Balance History
              _buildBalanceHistory(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, bool isPrimary) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: isPrimary ? AppColors.leatherGradient : null,
        color: isPrimary ? null : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isPrimary
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: isPrimary ? Colors.white : AppColors.primary),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: isPrimary ? Colors.white : AppColors.primary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _balanceCard(String label, String value, IconData icon, Color iconColor, String tag) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: iconColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(tag,
                  style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6), letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('Daily Tip', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"Remember to reconcile digital payments with bank statements before closing the daily ledger to maintain maillard-level precision."',
            style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Text('Daily Entry Manual Log', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 24),

          // Bank Reconciliation
          Text('BANK RECONCILIATION',
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          _inputField('EOD Bank Balance', '\$', '0.00'),
          const SizedBox(height: 12),
          _inputField('Transfer to Savings', '\$', '0.00'),
          const SizedBox(height: 20),

          // Petty Cash
          Text('PETTY CASH CALCULATION',
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _inputFieldSimple('Opening', '500.00')),
              const SizedBox(width: 12),
              Expanded(child: _inputFieldSimple('Closing', '0.00')),
            ],
          ),
          const SizedBox(height: 16),

          // Variance
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CALCULATED VARIANCE',
                        style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text('-\$24.50', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.error, fontSize: 18)),
                  ],
                ),
                Icon(Icons.warning, color: AppColors.error.withValues(alpha: 0.4), size: 24),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notes
          Text('Notes / Discrepancy Reason',
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Explain any cash differences or bank adjustments...',
              fillColor: AppColors.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, String prefix, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Text(prefix, style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _inputFieldSimple(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceHistory() {
    final history = SampleData.balanceHistory;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Previous Balance History',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Row(
                  children: [
                    Icon(Icons.filter_list, color: AppColors.onSurfaceVariant, size: 20),
                    const SizedBox(width: 8),
                    Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
                  ],
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.3),
            child: Row(
              children: [
                _tableHeader('DATE', 2),
                _tableHeader('BANK\nCLOSING', 2),
                _tableHeader('CASH\nOPENING', 2),
              ],
            ),
          ),
          ...history.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(e.date, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    Expanded(flex: 2, child: Text('\$${e.bankClosing.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurface))),
                    Expanded(flex: 2, child: Text('\$${e.cashOpening.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurface))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _tableHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(text,
          style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1)),
    );
  }
}
