import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/models.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedPeriod = 0;
  final _periods = ['Daily', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header
              Text('Expenses Tracking',
                  style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('Manage and review your daily operating costs.',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 16),

              // Period Filter
              _buildPeriodFilter(),
              const SizedBox(height: 20),

              // Summary Bento
              _buildSummaryBento(),
              const SizedBox(height: 20),

              // Log Expense Form
              _buildLogExpenseForm(),
              const SizedBox(height: 20),

              // Recent Transactions
              _buildRecentTransactions(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_periods.length, (i) {
          final isActive = _selectedPeriod == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedPeriod = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.surfaceContainerLowest : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
              ),
              child: Text(_periods[i],
                  style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryBento() {
    return Column(
      children: [
        // Total Period Outflow
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(28)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL PERIOD OUTFLOW',
                  style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text('\$14,280.00', style: GoogleFonts.plusJakartaSans(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.trending_up, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text('+12% from last month', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Largest Category + Cash Flow
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 140,
                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LARGEST CATEGORY',
                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer, letterSpacing: 1.5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Salaries', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSecondaryContainer)),
                        Text('42% of total expenses', style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSecondaryContainer.withValues(alpha: 0.7))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 140,
                decoration: BoxDecoration(
                  gradient: AppColors.leatherGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AVAILABLE CASH FLOW',
                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.6), letterSpacing: 0.5)),
                    Text('\$5,820.40', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: Text('Add Expense', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white), overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 4),
                          const Icon(Icons.add, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogExpenseForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Expense', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 20),
          Text('TITLE', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          TextField(decoration: InputDecoration(hintText: 'e.g. Arabica Beans Delivery')),
          const SizedBox(height: 16),
          Text('AMOUNT', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text('CATEGORY', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'Supplies',
                isExpanded: true,
                icon: Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
                items: ['Supplies', 'Rent', 'Salaries', 'Utilities', 'Marketing']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.manrope(fontWeight: FontWeight.w500))))
                    .toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.leatherGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Center(child: Text('Save Transaction', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Row(
                  children: [
                    Text('Export CSV', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                    const SizedBox(width: 4),
                    Icon(Icons.download, size: 16, color: AppColors.secondary),
                  ],
                ),
              ],
            ),
          ),
          ...SampleData.transactions.map((t) => _transactionTile(t)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Load older transactions',
                  style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionTile(Transaction t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_getIcon(t.icon), color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.onSurface, fontSize: 14)),
                Text('${t.date} • ${t.category}', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('-\$${t.amount.abs().toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 14)),
              const SizedBox(height: 2),
              t.status == TransactionStatus.verified
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
                      child: Text('VERIFIED', style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: -0.3)),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('PENDING', style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.error, letterSpacing: -0.3)),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'inventory_2': return Icons.inventory_2;
      case 'badge': return Icons.badge;
      case 'apartment': return Icons.apartment;
      case 'bolt': return Icons.bolt;
      case 'local_shipping': return Icons.local_shipping;
      default: return Icons.receipt;
    }
  }
}
