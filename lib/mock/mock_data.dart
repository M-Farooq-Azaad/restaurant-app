import 'package:flutter/material.dart';

class MockUser {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String tierId;
  final int totalPoints;

  const MockUser({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.tierId,
    required this.totalPoints,
  });
}

class MenuCategory {
  final String id;
  final String name;
  final String emoji;
  const MenuCategory({required this.id, required this.name, required this.emoji});
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String emoji;
  final double price;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isBestSeller;
  final bool isNew;
  final int prepTimeMinutes;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.emoji,
    required this.price,
    required this.rating,
    required this.reviewCount,
    this.isPopular = false,
    this.isBestSeller = false,
    this.isNew = false,
    required this.prepTimeMinutes,
  });
}

class PromoItem {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final Color bgStart;
  final Color bgEnd;
  final String emoji;

  const PromoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.bgStart,
    required this.bgEnd,
    required this.emoji,
  });
}

class MockData {
  static const currentUser = MockUser(
    id: 'user_001',
    fullName: 'Hassan Ali',
    username: 'hassan.ali',
    email: 'hassan@example.com',
    phone: '+923001234567',
    tierId: 'tier_gold',
    totalPoints: 2400,
  );

  static const List<MenuCategory> categories = [
    MenuCategory(id: 'cat_burgers', name: 'Burgers', emoji: '🍔'),
    MenuCategory(id: 'cat_pizza', name: 'Pizza', emoji: '🍕'),
    MenuCategory(id: 'cat_pasta', name: 'Pasta', emoji: '🍝'),
    MenuCategory(id: 'cat_salads', name: 'Salads', emoji: '🥗'),
    MenuCategory(id: 'cat_desserts', name: 'Desserts', emoji: '🍰'),
    MenuCategory(id: 'cat_drinks', name: 'Drinks', emoji: '🥤'),
  ];

  static const List<MenuItem> menuItems = [
    MenuItem(
      id: 'item_001',
      name: 'Signature Beef Burger',
      description: 'Aged beef patty, truffle mayo, crispy onions',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 18.99,
      rating: 4.8,
      reviewCount: 324,
      isPopular: true,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'item_002',
      name: 'Truffle Margherita',
      description: 'Fresh mozzarella, truffle oil, basil',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 22.50,
      rating: 4.7,
      reviewCount: 218,
      isNew: true,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_003',
      name: 'Creamy Carbonara',
      description: 'Guanciale, egg yolk, pecorino romano',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 16.99,
      rating: 4.9,
      reviewCount: 456,
      isBestSeller: true,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_004',
      name: 'Grilled Salmon Bowl',
      description: 'Atlantic salmon, quinoa, lemon dressing',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 24.99,
      rating: 4.6,
      reviewCount: 189,
      isPopular: true,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'item_005',
      name: 'Lava Chocolate Cake',
      description: 'Warm dark chocolate, vanilla ice cream',
      categoryId: 'cat_desserts',
      emoji: '🍫',
      price: 10.99,
      rating: 4.9,
      reviewCount: 512,
      isBestSeller: true,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'item_006',
      name: 'Mango Passion Smoothie',
      description: 'Fresh mango, passion fruit, coconut milk',
      categoryId: 'cat_drinks',
      emoji: '🥭',
      price: 8.99,
      rating: 4.7,
      reviewCount: 167,
      isNew: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_007',
      name: 'BBQ Chicken Pizza',
      description: 'Smoky BBQ sauce, pulled chicken, red onion',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 20.99,
      rating: 4.8,
      reviewCount: 290,
      isBestSeller: true,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_008',
      name: 'Double Smash Burger',
      description: 'Two smashed patties, American cheese, special sauce',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 21.99,
      rating: 4.9,
      reviewCount: 401,
      isBestSeller: true,
      prepTimeMinutes: 12,
    ),
  ];

  static List<MenuItem> get todaysPicks =>
      menuItems.where((i) => i.isPopular || i.isNew).toList();

  static List<MenuItem> get bestSellers =>
      menuItems.where((i) => i.isBestSeller).toList();

  static const List<PromoItem> promos = [
    PromoItem(
      id: 'promo_001',
      title: '30% Off Burgers',
      subtitle: 'Every Thursday — limited time',
      tag: 'HOT DEAL',
      bgStart: Color(0xFF7B1E1E),
      bgEnd: Color(0xFFB83232),
      emoji: '🍔',
    ),
    PromoItem(
      id: 'promo_002',
      title: 'Free Dessert',
      subtitle: 'On orders above \$40',
      tag: 'LOYALTY PERK',
      bgStart: Color(0xFF1C2A3A),
      bgEnd: Color(0xFF2D4A68),
      emoji: '🍰',
    ),
    PromoItem(
      id: 'promo_003',
      title: 'Double Points',
      subtitle: 'This weekend on all orders',
      tag: '2× POINTS',
      bgStart: Color(0xFF1A3A2A),
      bgEnd: Color(0xFF2D6A4F),
      emoji: '⭐',
    ),
    PromoItem(
      id: 'promo_004',
      title: 'New: Truffle Menu',
      subtitle: 'Explore our premium truffle collection',
      tag: 'NEW ARRIVAL',
      bgStart: Color(0xFF3D2B1F),
      bgEnd: Color(0xFF6B4226),
      emoji: '🍽️',
    ),
  ];

  static const Map<String, int> tierThresholds = {
    'tier_bronze': 0,
    'tier_silver': 1000,
    'tier_gold': 2000,
    'tier_platinum': 4000,
  };

  static const Map<String, String> tierNames = {
    'tier_bronze': 'Bronze',
    'tier_silver': 'Silver',
    'tier_gold': 'Gold',
    'tier_platinum': 'Platinum',
  };
}
