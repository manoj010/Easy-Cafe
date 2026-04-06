class MenuItem {
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  bool inStock;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.inStock = true,
  });
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
