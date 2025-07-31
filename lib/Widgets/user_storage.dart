import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static final _storage = GetStorage('user_data');

  // Keys
  static const String REMEMBER_ME_KEY = 'remember_me';
  static const String TOKEN_KEY = 'token';
  static const String EMAIL_KEY = 'email';
  static const String NAME_KEY = 'name';
  static const String ROLE_KEY = 'role';
  static const String _accountInfoKey = 'account_info';
  static const String MEMBERSHIP_KEY = 'membership_status';
  static const String MEMBERSHIP_EXPIRY_KEY = 'membership_expiry';
  static const String USER_ID_KEY = 'user_id';
  static const String _subscriptionStatusKey = 'subscription_status';
  static const String _subscriptionExpirationKey = 'subscription_expiration';
  static const String SUBSCRIPTION_DATA_KEY = 'subscription_data';

  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init('user_data');
  }

  // Existing methods
  static String? getName() {
    return _storage.read(NAME_KEY);
  }

  static String? getRole() {
    return _storage.read(ROLE_KEY);
  }

  static bool isVisitor() {
    return _storage.read(MEMBERSHIP_KEY) == 'visitor';
  }

  // Save user data
  static Future<void> saveUserData({
    required String token,
    required String email,
    required String name,
    required String role,
  }) async {
    await _storage.write(TOKEN_KEY, token);
    await _storage.write(EMAIL_KEY, email);
    await _storage.write(NAME_KEY, name);
    await _storage.write(ROLE_KEY, role);
  }

  // Get token
  static String? getToken() {
    return _storage.read(TOKEN_KEY);
  }

  // Get email
  static String? getEmail() {
    return _storage.read(EMAIL_KEY);
  }

  // Enhanced membership methods
  static Future<void> saveMembershipStatus(String status) async {
    await _storage.write(MEMBERSHIP_KEY, status);
  }

  static String getMembershipStatus() {
    return _storage.read(MEMBERSHIP_KEY) ?? 'visitor';
  }

  static bool isPremiumUser() {
    final membership = getMembershipStatus();
    return membership == 'premium' ||
        membership == 'pro' ||
        membership == 'member';
  }

  static bool isBasicUser() {
    final membership = getMembershipStatus();
    return membership == 'basic';
  }

  static Future<void> setMembershipExpiry(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('membership_expiry', date.toIso8601String());
  }

  static Future<DateTime?> getMembershipExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString('membership_expiry');
    if (expiryString == null) return null;

    try {
      final expiryDate = DateTime.parse(expiryString);
      print('UserStorage: Parsed membership expiry date: $expiryDate');
      return expiryDate;
    } catch (e) {
      print('UserStorage: Error parsing membership expiry date: $e');
      return null;
    }
  }

  static Future<bool> isMembershipExpired() async {
    final expiry = await getMembershipExpiry();
    if (expiry == null) {
      print('UserStorage: Membership expiry is null, considered expired');
      return true;
    }
    final now = DateTime.now();
    print('UserStorage: Checking membership expiry. Now: $now, Expiry: $expiry');
    return now.isAfter(expiry);
  }

  static Future<bool> hasValidMembership() async {
    return isPremiumUser() && !(await isMembershipExpired());
  }

  static Future<void> setUserId(String userId) async {
    await _storage.write(USER_ID_KEY, userId);
  }

  static String? getUserId() {
    return _storage.read(USER_ID_KEY);
  }

  // Simpan data subscription (dalam bentuk Map)
  static Future<void> saveSubscription(Map<String, dynamic> data) async {
  final jsonStr = jsonEncode(data);
  await _storage.write(SUBSCRIPTION_DATA_KEY, jsonStr);
}

// Ambil data subscription (return Map)
  static Map<String, dynamic>? getSubscription() {
  final jsonStr = _storage.read(SUBSCRIPTION_DATA_KEY);
  if (jsonStr != null) {
    try {
      return jsonDecode(jsonStr);
    } catch (e) {
      print('❌ Error parsing subscription JSON: $e');
      return null;
    }
  }
  return null;
}

  // Upgrade user to premium
  static Future<void> upgradeToPremium({
    required DateTime expiryDate,
    String membershipType = 'premium',
  }) async {
    await _storage.write(ROLE_KEY, 'premium_user');
    await saveMembershipStatus(membershipType);
    await setMembershipExpiry(expiryDate);
  }

  // Downgrade user (when membership expires or cancelled)
  static Future<void> downgradeToBasic() async {
    await _storage.write(ROLE_KEY, 'basic_user');
    await saveMembershipStatus('basic');
  }

  // Set as visitor
  static Future<void> setAsVisitor() async {
    await _storage.write(ROLE_KEY, 'visitor');
    await saveMembershipStatus('visitor');
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _storage.hasData(TOKEN_KEY) && getToken() != null;
  }

  // Save rememberMe
  static Future<void> saveRememberMe(bool value) async {
    await _storage.write(REMEMBER_ME_KEY, value);
  }

  // Get rememberMe
  static bool isRememberMeEnabled() {
    return _storage.read(REMEMBER_ME_KEY) ?? false;
  }

  // Get user access level
  static Future<UserAccessLevel> getUserAccessLevel() async {
    if (isVisitor()) return UserAccessLevel.visitor;
    if (await hasValidMembership()) return UserAccessLevel.premium;
    return UserAccessLevel.basic;
  }

  // Get membership info for display
  static Future<Map<String, dynamic>> getMembershipInfo() async {
    final expiry = await getMembershipExpiry();
    final expired = expiry == null ? true : DateTime.now().isAfter(expiry);
    final valid = isPremiumUser() && !expired;

    return {
      'role': getRole() ?? 'visitor',
      'membership': getMembershipStatus(),
      'isPremium': isPremiumUser(),
      'isExpired': expired,
      'expiry': expiry,
      'hasValidMembership': valid,
      'accessLevel': (await getUserAccessLevelAsync()).toString(),
    };
  }

  static Future<void> saveUserAccessLevel(UserAccessLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_level', level.name); // simpan 'premium'
  }

  static Future<UserAccessLevel> getUserAccessLevelAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final levelStr = prefs.getString('access_level') ?? 'visitor';

    switch (levelStr) {
      case 'premium':
        return UserAccessLevel.premium;
      case 'basic':
        return UserAccessLevel.basic;
      default:
        return UserAccessLevel.visitor;
    }
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    await _storage.erase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('membership_expiry');
    await prefs.remove('access_level');
  }

  // For debugging (optional)
  static void printStorageData() {
    print('Token: ${getToken()}');
    print('Email: ${getEmail()}');
    print('Name: ${getName()}');
    print('Role: ${getRole()}');
    print('Membership: ${getMembershipStatus()}');
  }
}

enum UserAccessLevel {
  visitor,
  basic,
  premium,
}

// Extension for easy access level checking
extension UserAccessLevelExtension on UserAccessLevel {
  bool get canAccessPremiumContent {
    return this == UserAccessLevel.premium;
  }

  bool get canAccessBasicContent {
    return this != UserAccessLevel.visitor;
  }

  String get displayName {
    switch (this) {
      case UserAccessLevel.visitor:
        return 'Visitor';
      case UserAccessLevel.basic:
        return 'Basic User';
      case UserAccessLevel.premium:
        return 'Premium User';
    }
  }
}
