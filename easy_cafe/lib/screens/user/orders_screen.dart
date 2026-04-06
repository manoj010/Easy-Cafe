import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/models.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['Coffee', 'Tea', 'Snacks'];
  late List<CartItem> _cart;
  late List<Order> _orders;

  @override
  void initState() {
    super.initState();
    _cart = List.from(SampleData.demoCart);
    _orders = List.from(SampleData.demoOrders);
  }

  double get _cartTotal => _cart.fold(0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header + Category Pills
              _buildHeader(),
              const SizedBox(height: 16),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: _buildProductGrid(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Current Selection / Cart
              _buildCartSection(),
              const SizedBox(height: 24),
              // Daily Orders
              _buildDailyOrders(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'New Order',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        Row(
          children: List.generate(_categories.length, (index) {
            final isActive = _selectedCategory == index;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isActive
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]
                        : [],
                  ),
                  child: Text(
                    _categories[index],
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    final items = SampleData.coffeeItems;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == items.length) return _buildCustomItem();
          return _buildProductCard(items[index]);
        },
        childCount: items.length + 1,
      ),
    );
  }

  Widget _buildProductCard(MenuItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          final existingIdx = _cart.indexWhere((c) => c.menuItem.name == item.name);
          if (existingIdx >= 0) {
            _cart[existingIdx].quantity++;
          } else {
            _cart.add(CartItem(menuItem: item));
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${item.name} to cart'),
            duration: const Duration(milliseconds: 800),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerHighest,
                    child: const Icon(Icons.coffee, size: 40, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 36, color: AppColors.outlineVariant),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Custom',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: AppColors.outline,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '---',
            style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSection() {
    if (_cart.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Selection',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...(_cart.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.menuItem.name,
                            style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.onSurface),
                          ),
                          if (item.customization.isNotEmpty)
                            Text(
                              item.customization,
                              style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.total.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ))),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL AMOUNT',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_cartTotal.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: AppColors.leatherGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Place Order',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Orders',
              style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              'View History',
              style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._orders.map((order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOrderCard(order),
            )),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    final isPending = order.status == OrderStatus.pending;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPending ? AppColors.surfaceContainer : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: isPending ? Border(left: BorderSide(color: AppColors.secondary, width: 4)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER #${order.id} • ${order.time}',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.table,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusPill(order.status),
                  if (order.paymentStatus == PaymentStatus.qrPaid) ...[
                    const SizedBox(height: 4),
                    Text('QR Paid', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                  ],
                  if (order.paymentStatus == PaymentStatus.unpaid && order.status == OrderStatus.completed) ...[
                    const SizedBox(height: 4),
                    Text('UNPAID', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error)),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isPending) ...[
            Wrap(
              spacing: 8,
              children: order.items.map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(item, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Mark Completed', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text('Mark Paid', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              order.items.join(', '),
              style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            if (order.paymentStatus == PaymentStatus.unpaid)
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Process \$${order.total.toStringAsFixed(2)} Payment',
                    style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer),
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${order.total.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Icon(Icons.more_vert, color: AppColors.outlineVariant),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPill(OrderStatus status) {
    Color bg;
    Color fg;
    String text;
    switch (status) {
      case OrderStatus.pending:
        bg = AppColors.secondary.withValues(alpha: 0.1);
        fg = AppColors.secondary;
        text = 'PENDING';
      case OrderStatus.preparing:
        bg = AppColors.secondary.withValues(alpha: 0.1);
        fg = AppColors.secondary;
        text = 'PREPARING';
      case OrderStatus.ready:
        bg = const Color(0xFFF0FDF4);
        fg = const Color(0xFF15803D);
        text = 'READY';
      case OrderStatus.completed:
        bg = AppColors.onTertiaryContainer.withValues(alpha: 0.1);
        fg = AppColors.tertiary;
        text = 'COMPLETED';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: fg, letterSpacing: 1),
      ),
    );
  }
}
