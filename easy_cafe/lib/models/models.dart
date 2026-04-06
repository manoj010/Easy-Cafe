class MenuItem {
  final String? id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  bool inStock;

  MenuItem({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.inStock = true,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String?,
      name: map['name'] as String? ?? 'Unnamed Item',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Other',
      imageUrl: map['image_url'] as String? ?? '',
      inStock: map['in_stock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'in_stock': inStock,
    };
  }

  MenuItem copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? category,
    String? imageUrl,
    bool? inStock,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      inStock: inStock ?? this.inStock,
    );
  }
}

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final String customization;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.customization = '',
  });

  double get total => menuItem.price * quantity;
}

class Order {
  final int id;
  final String time;
  final String table;
  final List<String> items;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;

  Order({
    required this.id,
    required this.time,
    required this.table,
    required this.items,
    required this.total,
    required this.status,
    required this.paymentStatus,
  });
}

enum OrderStatus { pending, preparing, completed, ready }
enum PaymentStatus { unpaid, paid, qrPaid }

class StockItem {
  final String name;
  final String icon;
  int quantity;
  final int minQuantity;
  final String unit;

  StockItem({
    required this.name,
    required this.icon,
    required this.quantity,
    required this.minQuantity,
    this.unit = 'units',
  });

  bool get isLowStock => quantity <= minQuantity;
}

class Task {
  final String title;
  final String subtitle;
  bool isCompleted;

  Task({
    required this.title,
    this.subtitle = '',
    this.isCompleted = false,
  });
}

class Transaction {
  final String title;
  final double amount;
  final String date;
  final String category;
  final String icon;
  final TransactionStatus status;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.icon,
    required this.status,
  });
}

enum TransactionStatus { verified, pending }

class BalanceEntry {
  final String date;
  final double bankClosing;
  final double cashOpening;
  final double cashClosing;
  final double difference;
  final String status;

  BalanceEntry({
    required this.date,
    required this.bankClosing,
    required this.cashOpening,
    required this.cashClosing,
    required this.difference,
    required this.status,
  });
}
