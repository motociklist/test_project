class SubscriptionPlan {
  final String id;
  final String name;
  final String period; // 'month' or 'year'
  final double price;
  final double? originalPrice;
  final String description;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.period,
    required this.price,
    this.originalPrice,
    required this.description,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).toInt();
  }
}

class User {
  final String email;
  final String password;
  final DateTime createdAt;

  User({required this.email, required this.password, required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Subscription {
  final String planId;
  final String planName;
  final String period;
  final DateTime purchaseDate;
  final String userEmail;

  Subscription({
    required this.planId,
    required this.planName,
    required this.period,
    required this.purchaseDate,
    required this.userEmail,
  });

  bool get isActive {
    if (period == 'month') {
      return DateTime.now().difference(purchaseDate).inDays < 30;
    } else {
      return DateTime.now().difference(purchaseDate).inDays < 365;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'period': period,
      'purchaseDate': purchaseDate.toIso8601String(),
      'userEmail': userEmail,
    };
  }

  static Subscription fromJson(Map<String, dynamic> json) {
    return Subscription(
      planId: json['planId'],
      planName: json['planName'],
      period: json['period'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      userEmail: json['userEmail'],
    );
  }
}
