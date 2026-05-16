import 'package:flutter/material.dart';

class MockMission {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int current;
  final int target;
  final int rewardPoints;

  const MockMission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.current,
    required this.target,
    required this.rewardPoints,
  });
}

class MockRecentOrder {
  final String id;
  final String orderNumber;
  final List<String> itemNames;
  final double total;
  final int pointsEarned;
  final String dateLabel;
  final String emoji;

  const MockRecentOrder({
    required this.id,
    required this.orderNumber,
    required this.itemNames,
    required this.total,
    required this.pointsEarned,
    required this.dateLabel,
    required this.emoji,
  });
}

class MockCoupon {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final String expiryLabel;
  final Color bgColor;

  const MockCoupon({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.expiryLabel,
    required this.bgColor,
  });
}

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
  const MenuCategory(
      {required this.id, required this.name, required this.emoji});
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

enum PromoPattern { burst, bubbles, diamonds, waves }

class PromoItem {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final Color bgStart;
  final Color bgEnd;
  final String emoji;
  final PromoPattern pattern;

  const PromoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.bgStart,
    required this.bgEnd,
    required this.emoji,
    required this.pattern,
  });
}

class LoyaltyReward {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int pointsCost;

  const LoyaltyReward({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.pointsCost,
  });
}

class LoyaltyTransaction {
  final String id;
  final String title;
  final String subtitle;
  final int points;
  final String dateLabel;
  final bool isEarned;

  const LoyaltyTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.dateLabel,
    required this.isEarned,
  });
}

class MockData {
  static const currentUser = MockUser(
    id: 'user_001',
    fullName: 'Farooq Jutt',
    username: 'mfajutt',
    email: 'mr.farooq2066@gmail.com',
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
    // ── Burgers ────────────────────────────────────────────────────────────
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
    MenuItem(
      id: 'item_101',
      name: 'Mushroom Swiss Burger',
      description: 'Sautéed mushrooms, Swiss cheese, garlic aioli',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 17.99,
      rating: 4.6,
      reviewCount: 198,
      prepTimeMinutes: 14,
    ),
    MenuItem(
      id: 'item_102',
      name: 'Spicy Jalapeño Burger',
      description: 'Fresh jalapeños, pepper jack, chipotle mayo',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 16.99,
      rating: 4.5,
      reviewCount: 145,
      prepTimeMinutes: 13,
    ),
    MenuItem(
      id: 'item_103',
      name: 'BBQ Bacon Burger',
      description: 'Crispy bacon, smoky BBQ sauce, cheddar',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 19.99,
      rating: 4.7,
      reviewCount: 267,
      isBestSeller: true,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'item_104',
      name: 'Classic Cheeseburger',
      description: 'American cheese, pickles, yellow mustard',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 13.99,
      rating: 4.4,
      reviewCount: 312,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'item_105',
      name: 'Crispy Chicken Burger',
      description: 'Buttermilk fried chicken, coleslaw, honey mustard',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 15.99,
      rating: 4.6,
      reviewCount: 221,
      isPopular: true,
      prepTimeMinutes: 16,
    ),
    MenuItem(
      id: 'item_106',
      name: 'Veggie Black Bean Burger',
      description: 'Spiced black bean patty, avocado, lime slaw',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 14.99,
      rating: 4.3,
      reviewCount: 89,
      isNew: true,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'item_107',
      name: 'Wagyu Beef Burger',
      description: 'Premium wagyu patty, foie gras butter, caramelised onions',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 34.99,
      rating: 4.9,
      reviewCount: 156,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_108',
      name: 'Truffle Cheese Burger',
      description: 'Black truffle aioli, aged cheddar, rocket',
      categoryId: 'cat_burgers',
      emoji: '🍔',
      price: 22.99,
      rating: 4.8,
      reviewCount: 178,
      isPopular: true,
      prepTimeMinutes: 15,
    ),
    // ── Pizza ──────────────────────────────────────────────────────────────
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
      id: 'item_201',
      name: 'Classic Pepperoni',
      description: 'San Marzano tomato, mozzarella, aged pepperoni',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 19.99,
      rating: 4.7,
      reviewCount: 445,
      isBestSeller: true,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_202',
      name: 'Four Cheese',
      description: 'Mozzarella, gorgonzola, taleggio, parmigiano',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 21.99,
      rating: 4.8,
      reviewCount: 289,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_203',
      name: 'Veggie Garden',
      description: 'Roasted peppers, courgette, aubergine, olives',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 17.99,
      rating: 4.4,
      reviewCount: 134,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_204',
      name: 'Prosciutto & Arugula',
      description: 'San Daniele prosciutto, fresh rocket, parmesan',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 24.99,
      rating: 4.9,
      reviewCount: 201,
      isPopular: true,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_205',
      name: 'Spicy Diavola',
      description: "N'duja sausage, chilli flakes, honey drizzle",
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 20.99,
      rating: 4.7,
      reviewCount: 167,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_206',
      name: 'Mushroom White',
      description: 'Truffle crème, mixed mushrooms, thyme, fontina',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 22.50,
      rating: 4.8,
      reviewCount: 143,
      isNew: true,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_207',
      name: 'Hawaiian',
      description: 'Smoked ham, pineapple, jalapeños, mozzarella',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 18.99,
      rating: 4.3,
      reviewCount: 198,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_208',
      name: 'Seafood Marinara',
      description: 'Prawns, calamari, mussels, cherry tomato',
      categoryId: 'cat_pizza',
      emoji: '🍕',
      price: 26.99,
      rating: 4.6,
      reviewCount: 112,
      prepTimeMinutes: 22,
    ),
    // ── Pasta ──────────────────────────────────────────────────────────────
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
      id: 'item_301',
      name: 'Penne Arrabbiata',
      description: 'Spicy San Marzano tomato, garlic, fresh basil',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 13.99,
      rating: 4.5,
      reviewCount: 234,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'item_302',
      name: 'Pesto Tagliatelle',
      description: 'Basil pesto, cherry tomatoes, pine nuts, parmesan',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 15.99,
      rating: 4.6,
      reviewCount: 178,
      isPopular: true,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'item_303',
      name: 'Seafood Linguine',
      description: 'King prawns, clams, white wine, cherry tomato',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 24.99,
      rating: 4.8,
      reviewCount: 189,
      isBestSeller: true,
      prepTimeMinutes: 20,
    ),
    MenuItem(
      id: 'item_304',
      name: 'Lasagna Al Forno',
      description: 'Slow-cooked bolognese, béchamel, egg pasta sheets',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 18.99,
      rating: 4.7,
      reviewCount: 312,
      prepTimeMinutes: 25,
    ),
    MenuItem(
      id: 'item_305',
      name: 'Cacio e Pepe',
      description: 'Tonnarelli, aged pecorino, cracked black pepper',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 14.99,
      rating: 4.8,
      reviewCount: 267,
      isPopular: true,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'item_306',
      name: 'Truffle Tagliatelle',
      description: 'Black truffle, butter, parmigiano reggiano',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 27.99,
      rating: 4.9,
      reviewCount: 145,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_307',
      name: 'Vodka Rigatoni',
      description: 'Spicy tomato cream, pancetta, fresh parsley',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 16.99,
      rating: 4.6,
      reviewCount: 198,
      isNew: true,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'item_308',
      name: 'Mushroom Risotto',
      description: 'Arborio rice, porcini, white wine, mascarpone',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 19.99,
      rating: 4.7,
      reviewCount: 223,
      prepTimeMinutes: 22,
    ),
    MenuItem(
      id: 'item_309',
      name: 'Gnocchi Sorrentina',
      description: 'Potato gnocchi, pomodoro, buffalo mozzarella, basil',
      categoryId: 'cat_pasta',
      emoji: '🍝',
      price: 17.99,
      rating: 4.6,
      reviewCount: 167,
      prepTimeMinutes: 20,
    ),
    // ── Salads ─────────────────────────────────────────────────────────────
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
      id: 'item_401',
      name: 'Classic Caesar',
      description: 'Romaine, house caesar dressing, anchovies, croutons',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 14.99,
      rating: 4.6,
      reviewCount: 345,
      isBestSeller: true,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'item_402',
      name: 'Greek Village Salad',
      description: 'Heirloom tomatoes, Kalamata olives, barrel-aged feta',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 13.99,
      rating: 4.5,
      reviewCount: 198,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'item_403',
      name: 'Quinoa Power Bowl',
      description: 'Tri-colour quinoa, roasted veg, tahini dressing',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 16.99,
      rating: 4.6,
      reviewCount: 167,
      isNew: true,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'item_404',
      name: 'Caprese',
      description: 'Buffalo mozzarella, heirloom tomato, aged balsamic',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 15.99,
      rating: 4.7,
      reviewCount: 213,
      isPopular: true,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'item_405',
      name: 'Tuna Niçoise',
      description: 'Seared tuna, haricots verts, soft egg, olives',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 19.99,
      rating: 4.7,
      reviewCount: 134,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'item_406',
      name: 'Chicken Avocado',
      description: 'Grilled chicken breast, avocado, citrus dressing',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 17.99,
      rating: 4.5,
      reviewCount: 189,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'item_407',
      name: 'Watermelon & Feta',
      description: 'Seedless watermelon, barrel feta, fresh mint',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 12.99,
      rating: 4.4,
      reviewCount: 98,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'item_408',
      name: 'Burrata & Heirloom',
      description: 'Stracciatella burrata, heirloom tomato, pistou',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 18.99,
      rating: 4.8,
      reviewCount: 156,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'item_409',
      name: 'Kale & Pomegranate',
      description: 'Tuscan kale, pomegranate, candied walnuts, lemon',
      categoryId: 'cat_salads',
      emoji: '🥗',
      price: 14.99,
      rating: 4.3,
      reviewCount: 78,
      isNew: true,
      prepTimeMinutes: 10,
    ),
    // ── Desserts ───────────────────────────────────────────────────────────
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
      id: 'item_501',
      name: 'Crème Brûlée',
      description: 'Classic vanilla custard, caramelised sugar crust',
      categoryId: 'cat_desserts',
      emoji: '🍮',
      price: 9.99,
      rating: 4.8,
      reviewCount: 312,
      isPopular: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_502',
      name: 'Tiramisu',
      description: 'Espresso-soaked ladyfingers, mascarpone, cocoa',
      categoryId: 'cat_desserts',
      emoji: '🍰',
      price: 10.99,
      rating: 4.9,
      reviewCount: 445,
      isBestSeller: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_503',
      name: 'New York Cheesecake',
      description: 'Creamy vanilla cheesecake, raspberry coulis',
      categoryId: 'cat_desserts',
      emoji: '🍰',
      price: 9.99,
      rating: 4.7,
      reviewCount: 267,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_504',
      name: 'Panna Cotta',
      description: 'Vanilla bean panna cotta, passion fruit gel',
      categoryId: 'cat_desserts',
      emoji: '🍮',
      price: 8.99,
      rating: 4.6,
      reviewCount: 189,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_505',
      name: 'Berry Pavlova',
      description: 'Crisp meringue, whipped cream, seasonal berries',
      categoryId: 'cat_desserts',
      emoji: '🍰',
      price: 11.99,
      rating: 4.7,
      reviewCount: 134,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_506',
      name: 'Mango Sorbet',
      description: 'Alphonso mango, lime zest, served tableside',
      categoryId: 'cat_desserts',
      emoji: '🍧',
      price: 7.99,
      rating: 4.5,
      reviewCount: 178,
      isNew: true,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'item_507',
      name: 'Profiteroles',
      description: 'Choux pastry, chantilly cream, dark chocolate sauce',
      categoryId: 'cat_desserts',
      emoji: '🍫',
      price: 10.99,
      rating: 4.7,
      reviewCount: 201,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_508',
      name: 'Affogato',
      description: 'Vanilla gelato, double espresso shot, amaretti',
      categoryId: 'cat_desserts',
      emoji: '🍦',
      price: 8.99,
      rating: 4.8,
      reviewCount: 223,
      isPopular: true,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'item_509',
      name: 'Baklava',
      description: 'Layered filo, pistachios, rose water honey syrup',
      categoryId: 'cat_desserts',
      emoji: '🍮',
      price: 8.99,
      rating: 4.6,
      reviewCount: 145,
      prepTimeMinutes: 5,
    ),
    // ── Drinks ─────────────────────────────────────────────────────────────
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
      id: 'item_601',
      name: 'Espresso Martini',
      description: 'Vodka, fresh espresso, coffee liqueur, sugar syrup',
      categoryId: 'cat_drinks',
      emoji: '🍹',
      price: 12.99,
      rating: 4.8,
      reviewCount: 312,
      isBestSeller: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_602',
      name: 'Fresh Lemonade',
      description: 'Hand-squeezed lemons, mint, sparkling water',
      categoryId: 'cat_drinks',
      emoji: '🥤',
      price: 5.99,
      rating: 4.6,
      reviewCount: 234,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_603',
      name: 'Matcha Latte',
      description: 'Ceremonial grade matcha, oat milk, light honey',
      categoryId: 'cat_drinks',
      emoji: '🍵',
      price: 6.99,
      rating: 4.7,
      reviewCount: 198,
      isPopular: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_604',
      name: 'Berry Blast Smoothie',
      description: 'Mixed berries, banana, almond milk, chia seeds',
      categoryId: 'cat_drinks',
      emoji: '🥤',
      price: 8.99,
      rating: 4.6,
      reviewCount: 167,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_605',
      name: 'Virgin Mojito',
      description: 'Fresh mint, lime, ginger ale, cane sugar',
      categoryId: 'cat_drinks',
      emoji: '🥤',
      price: 7.99,
      rating: 4.5,
      reviewCount: 145,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_606',
      name: 'Cold Brew Coffee',
      description: '18-hour cold brew, oat milk, brown sugar syrup',
      categoryId: 'cat_drinks',
      emoji: '☕',
      price: 6.99,
      rating: 4.7,
      reviewCount: 189,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'item_607',
      name: 'Watermelon Juice',
      description: 'Fresh watermelon, basil, pinch of sea salt',
      categoryId: 'cat_drinks',
      emoji: '🥤',
      price: 6.99,
      rating: 4.5,
      reviewCount: 123,
      isNew: true,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'item_608',
      name: 'Ginger Turmeric Shot',
      description: 'Cold-pressed ginger, turmeric, lemon, black pepper',
      categoryId: 'cat_drinks',
      emoji: '🥤',
      price: 4.99,
      rating: 4.4,
      reviewCount: 89,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: 'item_609',
      name: 'Rose Lychee Spritz',
      description: 'Rose syrup, lychee juice, elderflower tonic',
      categoryId: 'cat_drinks',
      emoji: '🍹',
      price: 9.99,
      rating: 4.7,
      reviewCount: 134,
      isNew: true,
      prepTimeMinutes: 5,
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
      pattern: PromoPattern.burst,
    ),
    PromoItem(
      id: 'promo_002',
      title: 'Free Dessert',
      subtitle: 'On orders above \$40',
      tag: 'LOYALTY PERK',
      bgStart: Color(0xFF1C2A3A),
      bgEnd: Color(0xFF2D4A68),
      emoji: '🍰',
      pattern: PromoPattern.bubbles,
    ),
    PromoItem(
      id: 'promo_003',
      title: 'Double Points',
      subtitle: 'This weekend on all orders',
      tag: '2× POINTS',
      bgStart: Color(0xFF1A3A2A),
      bgEnd: Color(0xFF2D6A4F),
      emoji: '⭐',
      pattern: PromoPattern.diamonds,
    ),
    PromoItem(
      id: 'promo_004',
      title: 'New: Truffle Menu',
      subtitle: 'Explore our premium truffle collection',
      tag: 'NEW ARRIVAL',
      bgStart: Color(0xFF3D2B1F),
      bgEnd: Color(0xFF6B4226),
      emoji: '🍽️',
      pattern: PromoPattern.waves,
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

  static const List<LoyaltyReward> loyaltyRewards = [
    LoyaltyReward(
      id: 'rew_001',
      title: 'Free Main Course',
      subtitle: 'Any main dish of your choice',
      emoji: '🍽️',
      pointsCost: 1000,
    ),
    LoyaltyReward(
      id: 'rew_002',
      title: 'Free Dessert',
      subtitle: 'Any dessert from the menu',
      emoji: '🍰',
      pointsCost: 500,
    ),
    LoyaltyReward(
      id: 'rew_003',
      title: 'Free Delivery',
      subtitle: 'On your next order',
      emoji: '🛵',
      pointsCost: 300,
    ),
    LoyaltyReward(
      id: 'rew_004',
      title: '\$5 Off Your Order',
      subtitle: 'Minimum order \$20',
      emoji: '💰',
      pointsCost: 250,
    ),
    LoyaltyReward(
      id: 'rew_005',
      title: 'Free Side Dish',
      subtitle: 'Choose any side from the menu',
      emoji: '🥗',
      pointsCost: 200,
    ),
    LoyaltyReward(
      id: 'rew_006',
      title: 'Free Drink',
      subtitle: 'Any drink up to \$8',
      emoji: '🥤',
      pointsCost: 150,
    ),
  ];

  static const List<MockMission> missions = [
    MockMission(
      id: 'mission_001',
      title: 'Order 2 Burgers',
      subtitle: 'Daily challenge',
      emoji: '🍔',
      current: 1,
      target: 2,
      rewardPoints: 200,
    ),
    MockMission(
      id: 'mission_002',
      title: 'Spend \$50 This Week',
      subtitle: 'Weekly challenge',
      emoji: '💰',
      current: 28,
      target: 50,
      rewardPoints: 500,
    ),
    MockMission(
      id: 'mission_003',
      title: 'Try 3 New Items',
      subtitle: 'Explorer challenge',
      emoji: '🌟',
      current: 2,
      target: 3,
      rewardPoints: 300,
    ),
  ];

  static const List<MockRecentOrder> recentOrders = [
    MockRecentOrder(
      id: 'order_001',
      orderNumber: '#4821',
      itemNames: ['Signature Beef Burger', 'Mango Passion Smoothie'],
      total: 27.98,
      pointsEarned: 189,
      dateLabel: 'Today, 2:30 PM',
      emoji: '🍔',
    ),
    MockRecentOrder(
      id: 'order_002',
      orderNumber: '#4756',
      itemNames: ['Truffle Margherita', 'Fresh Lemonade'],
      total: 28.49,
      pointsEarned: 225,
      dateLabel: 'Yesterday',
      emoji: '🍕',
    ),
    MockRecentOrder(
      id: 'order_003',
      orderNumber: '#4701',
      itemNames: ['Creamy Carbonara', 'Tiramisu'],
      total: 27.98,
      pointsEarned: 210,
      dateLabel: 'May 12',
      emoji: '🍝',
    ),
  ];

  static const List<MockCoupon> coupons = [
    MockCoupon(
      id: 'coupon_001',
      code: 'GOLD20',
      title: '20% Off',
      subtitle: 'On your next burger order',
      expiryLabel: 'Expires in 2 days',
      bgColor: Color(0xFF0F2A1A),
    ),
    MockCoupon(
      id: 'coupon_002',
      code: 'FREEDRINK',
      title: 'Free Drink',
      subtitle: 'With any main course',
      expiryLabel: 'Expires today',
      bgColor: Color(0xFF0A1A2A),
    ),
    MockCoupon(
      id: 'coupon_003',
      code: 'LOYALTY50',
      title: '+50 Pts',
      subtitle: 'Bonus on your next order',
      expiryLabel: 'Expires in 5 days',
      bgColor: Color(0xFF2A1A0A),
    ),
  ];

  static const List<LoyaltyTransaction> loyaltyHistory = [
    LoyaltyTransaction(
      id: 'tx_001',
      title: 'Order #4821',
      subtitle: 'Signature Beef Burger + Drinks',
      points: 189,
      dateLabel: 'Today, 2:30 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_002',
      title: 'Redeemed Reward',
      subtitle: 'Free Dessert',
      points: -500,
      dateLabel: 'Yesterday, 7:15 PM',
      isEarned: false,
    ),
    LoyaltyTransaction(
      id: 'tx_003',
      title: 'Order #4756',
      subtitle: 'Truffle Margherita + Drinks',
      points: 225,
      dateLabel: 'May 14, 12:00 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_004',
      title: 'Referral Bonus',
      subtitle: 'Ahmed joined via your code',
      points: 500,
      dateLabel: 'May 13, 9:20 AM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_005',
      title: 'Order #4701',
      subtitle: 'BBQ Chicken Pizza',
      points: 210,
      dateLabel: 'May 12, 8:45 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_006',
      title: 'Redeemed Reward',
      subtitle: 'Free Delivery',
      points: -300,
      dateLabel: 'May 11, 1:30 PM',
      isEarned: false,
    ),
    LoyaltyTransaction(
      id: 'tx_007',
      title: 'Review Bonus',
      subtitle: 'Reviewed Creamy Carbonara',
      points: 50,
      dateLabel: 'May 10, 6:00 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_008',
      title: 'Order #4633',
      subtitle: 'Seafood Linguine + Wine',
      points: 300,
      dateLabel: 'May 9, 7:30 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_009',
      title: 'Double Points Weekend',
      subtitle: 'Weekend bonus applied to order #4633',
      points: 300,
      dateLabel: 'May 9, 7:30 PM',
      isEarned: true,
    ),
    LoyaltyTransaction(
      id: 'tx_010',
      title: 'Order #4580',
      subtitle: 'Lava Chocolate Cake + Coffee',
      points: 110,
      dateLabel: 'May 7, 3:15 PM',
      isEarned: true,
    ),
  ];
}
