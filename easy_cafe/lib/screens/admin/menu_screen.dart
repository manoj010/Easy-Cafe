import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../models/models.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _supabase = Supabase.instance.client;
  late Stream<List<MenuItem>> _menuStream;

  @override
  void initState() {
    super.initState();
    debugPrint('MenuScreen: Initializing Supabase stream...');
    _menuStream = _supabase
        .from('menu_items')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) {
          debugPrint('MenuScreen: Received data from Supabase: ${data.length} items');
          return data.map((map) => MenuItem.fromMap(map)).toList();
        });
  }

  Future<void> _addMenuItem(MenuItem item) async {
    try {
      await _supabase.from('menu_items').insert(item.toMap());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _toggleInStock(MenuItem item) async {
    try {
      await _supabase.from('menu_items').update({'in_stock': !item.inStock}).eq('id', item.id!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating item: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteMenuItem(MenuItem item) async {
    try {
      await _supabase.from('menu_items').delete().eq('id', item.id!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting item: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Menu Item', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final item = MenuItem(
                name: nameController.text,
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 1.99,
                category: categoryController.text,
                imageUrl: imageUrlController.text,
              );
              _addMenuItem(item);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header
              Text('Menu Management',
                  style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('Curate your cafe\'s seasonal offerings and prices.',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Filter', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _showAddItemDialog,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: AppColors.leatherGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Add Item', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Bento
              _buildStatsBento(),
              const SizedBox(height: 20),

              // Menu Items
                  StreamBuilder<List<MenuItem>>(
                    stream: _menuStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        debugPrint('MenuScreen: StreamBuilder Error (Menu Items): ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Error: ${snapshot.error}')));
                      }
                      final items = snapshot.data ?? [];
                      if (items.isEmpty) {
                        return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('No menu items found. Add some!', style: GoogleFonts.manrope())));
                      }
                      return Column(
                        children: items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildMenuCard(item),
                        )).toList(),
                      );
                    },
                  ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBento() {
    return Column(
      children: [
        // Active Menu Items
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INVENTORY OVERVIEW',
                  style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary.withValues(alpha: 0.7), letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text('Active Menu Items', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stacked avatars
                  Row(
                    children: [
                      ...List.generate(3, (i) {
                        return StreamBuilder<List<MenuItem>>(
                          stream: _menuStream,
                          builder: (context, snapshot) {
                            final urls = (snapshot.data ?? []).map((m) => m.imageUrl).toList();
                            if (urls.length <= i) return const SizedBox.shrink();
                            return Container(
                              margin: EdgeInsets.only(left: i == 0 ? 0 : 0),
                              transform: Matrix4.translationValues(i * -12.0, 0, 0),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.surfaceContainerLow, width: 3),
                                ),
                                child: ClipOval(
                                  child: Image.network(urls[i], fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest)),
                                ),
                              ),
                            );
                          }
                        );
                      }),
                      Transform.translate(
                        offset: const Offset(-36, 0),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surfaceContainerLow, width: 3),
                          ),
                          child: Center(
                            child: Text('+42', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer)),
                          ),
                        ),
                      ),
                    ],
                  ),
                      StreamBuilder<List<MenuItem>>(
                        stream: _menuStream,
                        builder: (context, snapshot) {
                          final count = snapshot.data?.length ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('$count', style: GoogleFonts.plusJakartaSans(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              Text('Live across categories', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                            ],
                          );
                        }
                      ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 120,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Best Seller This Week', style: GoogleFonts.manrope(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                    Text('Caramel Macchiato', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 120,
                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.warning, color: AppColors.onSecondaryContainer.withValues(alpha: 0.5), size: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Low Stock Alert', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSecondaryContainer.withValues(alpha: 0.8))),
                        Text('Oat Milk Base', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer)),
                      ],
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

  Widget _buildMenuCard(MenuItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: item.inStock
                      ? Image.network(item.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest))
                      : ColorFiltered(
                          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.network(item.imageUrl, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest)),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.inStock ? Colors.white.withValues(alpha: 0.9) : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.inStock ? item.category.toUpperCase() : 'UNAVAILABLE',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item.inStock ? AppColors.primary : Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.secondary, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(item.description, style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),

          // Action Bar
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.1)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _iconBtn(Icons.edit, AppColors.onSurfaceVariant),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _deleteMenuItem(item),
                      child: _iconBtn(Icons.delete, AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleInStock(item),
                      child: Container(
                        width: 44,
                        height: 24,
                        decoration: BoxDecoration(
                          color: item.inStock ? AppColors.secondary : AppColors.surfaceDim,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: item.inStock ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.inStock ? 'IN STOCK' : 'SOLD OUT',
                      style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 20, color: color),
    );
  }
}
