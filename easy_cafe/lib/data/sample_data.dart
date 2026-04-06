import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/models.dart';

class SampleData {
  // === MENU ITEMS ===
  static List<MenuItem> coffeeItems = [
    MenuItem(
      name: 'Latte',
      price: 4.50,
      description: 'Creamy caffe latte with heart latte art',
      category: 'Coffee',
      imageUrl: dotenv.env['IMAGE_LATTE'] ?? '',
    ),
    MenuItem(
      name: 'Espresso',
      price: 3.00,
      description: 'Rich dark espresso with golden crema',
      category: 'Coffee',
      imageUrl: dotenv.env['IMAGE_ESPRESSO'] ?? '',
    ),
    MenuItem(
      name: 'Iced Mocha',
      price: 5.25,
      description: 'Iced coffee with swirling milk',
      category: 'Coffee',
      imageUrl: dotenv.env['IMAGE_ICED_MOCHA'] ?? '',
    ),
    MenuItem(
      name: 'Flat White',
      price: 4.25,
      description: 'Flat white with delicate rosetta latte art',
      category: 'Coffee',
      imageUrl: dotenv.env['IMAGE_FLAT_WHITE'] ?? '',
    ),
    MenuItem(
      name: 'Croissant',
      price: 3.75,
      description: 'Fresh butter croissant',
      category: 'Snacks',
      imageUrl: dotenv.env['IMAGE_CROISSANT'] ?? '',
    ),
  ];

  // === CART ITEMS (Demo) ===
  static List<CartItem> demoCart = [
    CartItem(
      menuItem: MenuItem(name: 'Oat Milk Latte', price: 4.50, description: '', category: 'Coffee', imageUrl: ''),
      quantity: 2,
      customization: 'Extra Hot, No Sugar',
    ),
    CartItem(
      menuItem: MenuItem(name: 'Blueberry Muffin', price: 4.50, description: '', category: 'Snacks', imageUrl: ''),
      quantity: 1,
      customization: 'Warm',
    ),
  ];

  // === ORDERS ===
  static List<Order> demoOrders = [
    Order(
      id: 842,
      time: '10:45 AM',
      table: 'Table 04',
      items: ['2x Latte', '1x Croissant'],
      total: 12.75,
      status: OrderStatus.pending,
      paymentStatus: PaymentStatus.unpaid,
    ),
    Order(
      id: 841,
      time: '10:30 AM',
      table: 'Takeaway',
      items: ['1x Espresso', '1x Iced Tea'],
      total: 8.25,
      status: OrderStatus.completed,
      paymentStatus: PaymentStatus.qrPaid,
    ),
    Order(
      id: 840,
      time: '10:15 AM',
      table: 'Table 12',
      items: ['4x Flat White', '2x Cookie'],
      total: 22.50,
      status: OrderStatus.completed,
      paymentStatus: PaymentStatus.unpaid,
    ),
  ];

  // === STOCK ITEMS ===
  static List<StockItem> stockItems = [
    StockItem(name: 'Oat Milk\n(Barista Ed.)', icon: 'opacity', quantity: 4, minQuantity: 12, unit: 'units'),
    StockItem(name: 'Organic\nCroissants', icon: 'egg', quantity: 8, minQuantity: 20, unit: 'units'),
    StockItem(name: 'Ethiopian Whole\nBean', icon: 'filter_vintage', quantity: 42, minQuantity: 10, unit: 'kg'),
    StockItem(name: 'Choco-Chip\nCookies', icon: 'cookie', quantity: 15, minQuantity: 5, unit: 'units'),
    StockItem(name: 'Salted Caramel\nSyrup', icon: 'icecream', quantity: 12, minQuantity: 5, unit: 'bottles'),
  ];

  // === TASKS ===
  static List<Task> pendingTasks = [
    Task(title: 'Buy milk', subtitle: '3L Whole Milk, 2L Oat Milk'),
    Task(title: 'Clean counter', subtitle: 'Use the espresso machine sanitizer'),
    Task(title: 'Update daily specials', subtitle: 'Chalkboard near the entrance'),
  ];

  static List<Task> completedTasks = [
    Task(title: 'Restock coffee beans', isCompleted: true),
    Task(title: 'Sanitize portafilters', isCompleted: true),
  ];

  // === TRANSACTIONS ===
  static List<Transaction> transactions = [
    Transaction(title: 'Whole Bean Coffee (10kg)', amount: -450.00, date: 'Today', category: 'Supplies', icon: 'inventory_2', status: TransactionStatus.verified),
    Transaction(title: 'Staff Weekly Payout', amount: -3200.00, date: 'Yesterday', category: 'Salaries', icon: 'badge', status: TransactionStatus.verified),
    Transaction(title: 'Monthly Store Lease', amount: -8500.00, date: 'Oct 01', category: 'Rent', icon: 'apartment', status: TransactionStatus.verified),
    Transaction(title: 'Electricity & Water', amount: -1120.50, date: 'Sep 28', category: 'Utilities', icon: 'bolt', status: TransactionStatus.pending),
    Transaction(title: 'Fresh Dairy Supply', amount: -315.00, date: 'Sep 25', category: 'Supplies', icon: 'local_shipping', status: TransactionStatus.verified),
  ];

  // === BALANCE HISTORY ===
  static List<BalanceEntry> balanceHistory = [
    BalanceEntry(date: 'Oct 24, 2023', bankClosing: 41920.00, cashOpening: 500.00, cashClosing: 1245.00, difference: 745.00, status: 'Matched'),
    BalanceEntry(date: 'Oct 23, 2023', bankClosing: 40350.50, cashOpening: 500.00, cashClosing: 1110.00, difference: -10.00, status: 'Variance'),
    BalanceEntry(date: 'Oct 22, 2023', bankClosing: 39800.00, cashOpening: 500.00, cashClosing: 1350.25, difference: 850.25, status: 'Matched'),
  ];

  // === ADMIN MENU ITEMS ===
  static List<MenuItem> adminMenuItems = [
    MenuItem(
      name: 'Signature Cold Brew',
      price: 5.50,
      description: 'Slow-steeped for 24 hours in small batches for a smooth, chocolatey finish.',
      category: 'Cold Brew',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrzvzwxDLmmKT-pCDOZ47wK3MJlTHd9ZkIyyZybATFzASCoJDIF56-jTh1A7uys5sDK2awUeaOcVQa4692r984RsY-g0_-SxLokMYXyjV5Q1foP3OoxGnzgvTwJEXnNg610ePtXVf_RgUHzOpf6apBhYjXMU4YKPjJdBLNly1hgoYWInhwr8qqmcIgOWlk-Dxswd8WOYaAJVd6uAgH9tNwGmxjdP1hQkJx407NaqqKHgJEvtPFnW2SBy0vHPy-cDtil6jIYlwUOJC6',
    ),
    MenuItem(
      name: 'Avocado Smash',
      price: 12.00,
      description: 'Artisan sourdough topped with heirloom tomatoes, radish, and chili flakes.',
      category: 'Breakfast',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkrrkx-KUN8ZVOHqDj45Wc3BfRqYc1znlt5fKmWrBWSGMXhBexmtdAqyndkistkUv647tb78uZvynv0ahPdTJxPxIp8H-uhUWzL4Xq0sWlFNLFhHLg0U0XXbT0IGRS71COUSymAuSBXEo8_dGKgBDkHfKsD2qDE6XL4mYAazeunpo0HQy6FadtNFz9BXGOjRPLyQQB2WHZbWn4MB7hSMiW7_TF3E1Z99MzQBzp0OIUzE8za3eabOPqNL7HqqRU04XzfaB1ut64pSk0',
    ),
    MenuItem(
      name: 'Blueberry Muffin',
      price: 4.25,
      description: 'Freshly baked every morning with locally sourced organic blueberries.',
      category: 'Pastries',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBrF_J-Lm27FeI00yAt3FeDU9yxesL01m9VWDzp_tEr9QJk0OMnSn165-WYO6Ejz15eYerblZyG6sZQYgMpp_iZ1uj1i3AWCeLXm0DGWeDUumQE6pNyp3ajERCOwSnjOiiqtoQHWFmdxfUDabP8KEoRlj0or0PhzOwA90EdlY8Z4tC6ENPKgsjcPEjw-uANcbvKkbKDveWYf7_H1XRAW6ZkKTWghfjAnEe-KWTVONePEOPMwIp0AQPtDfdNM2ifdBDDRbjmmpR2B4cQ',
      inStock: false,
    ),
    MenuItem(
      name: 'Ceremonial Matcha',
      price: 6.50,
      description: 'Stone-ground Uji matcha whisked with steamed oat milk for an earthy umami.',
      category: 'Hot Teas',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuADmsuIK5yHCa1LSE62STDX6MquBMRV-JLnFuANpSHN7wKk9Yq2YcJ6XcxzgaZLPSD6zb2gsbC9b8vC01Drb2HGE6NsnqqoQnFMThSsY-NIXieU59UMQznGg5Ip3gJE1N_AwZ-VqRNolCg4plZSfJMJX3q4YzLIfBTMBjlD7RHeKaeSPyBz278qCAAu1xlTWpExdInLUecPDUkBneQH6E_ebL2GEFc1oXwDNWUW5ELvnmtOVHVAZJ_VwCSUmgxU47gKamS6qb3xARK1',
    ),
  ];
}
