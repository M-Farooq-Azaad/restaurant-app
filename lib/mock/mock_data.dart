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
}
