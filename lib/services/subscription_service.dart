import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/models/subscription.dart';
import 'dart:convert';

class SubscriptionService {
  static const String _currentUserKey = 'current_user';
  static const String _usersDataKey = 'users_data';

  late SharedPreferences _prefs;
  Subscription? _currentSubscription;
  User? _currentUser;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCurrentUser();
    _loadSubscription();
  }

  // User Management
  void _loadCurrentUser() {
    final String? userData = _prefs.getString(_currentUserKey);
    if (userData != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userData));
      } catch (e) {
        _currentUser = null;
      }
    }
  }

  Future<bool> registerUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    // Проверим, не зарегистрирован ли уже пользователь с этим email
    final existingUser = await getUserByEmail(email);
    if (existingUser != null) {
      return false;
    }

    final user = User(
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );

    await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    _currentUser = user;

    // Сохраним в список всех пользователей
    await _saveUserToList(user);

    return true;
  }

  Future<bool> loginUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      _currentUser = user;
      _loadSubscription();
      return true;
    }
    return false;
  }

  Future<void> logoutUser() async {
    await _prefs.remove(_currentUserKey);
    _currentUser = null;
    _currentSubscription = null;
  }

  Future<User?> getUserByEmail(String email) async {
    final String? usersData = _prefs.getString(_usersDataKey);
    if (usersData == null) {
      return null;
    }

    try {
      final List<dynamic> users = jsonDecode(usersData);
      for (var userData in users) {
        if (userData['email'] == email) {
          return User.fromJson(userData);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> _saveUserToList(User user) async {
    List<dynamic> users = [];
    final String? usersData = _prefs.getString(_usersDataKey);

    if (usersData != null) {
      try {
        users = jsonDecode(usersData);
      } catch (e) {
        users = [];
      }
    }

    users.add(user.toJson());
    await _prefs.setString(_usersDataKey, jsonEncode(users));
  }

  // Subscription Management
  void _loadSubscription() {
    if (_currentUser == null) {
      _currentSubscription = null;
      return;
    }

    final String? data = _prefs.getString(
      'subscription_${_currentUser!.email}',
    );
    if (data != null) {
      try {
        _currentSubscription = Subscription.fromJson(jsonDecode(data));
      } catch (e) {
        _currentSubscription = null;
      }
    }
  }

  Future<bool> hasValidSubscription() async {
    _loadSubscription();
    if (_currentSubscription == null) {
      return false;
    }
    return _currentSubscription!.isActive;
  }

  Future<void> purchaseSubscription(SubscriptionPlan plan) async {
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }

    final subscription = Subscription(
      planId: plan.id,
      planName: plan.name,
      period: plan.period,
      purchaseDate: DateTime.now(),
      userEmail: _currentUser!.email,
    );

    await _prefs.setString(
      'subscription_${_currentUser!.email}',
      jsonEncode(subscription.toJson()),
    );
    _currentSubscription = subscription;
  }

  Future<void> clearSubscription() async {
    if (_currentUser != null) {
      await _prefs.remove('subscription_${_currentUser!.email}');
    }
    _currentSubscription = null;
  }

  Subscription? getCurrentSubscription() {
    return _currentSubscription;
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  bool get isLoggedIn => _currentUser != null;
}
