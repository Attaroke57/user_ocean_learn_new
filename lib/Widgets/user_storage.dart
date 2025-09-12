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
  static const String SUBSCRIPTION_KEY = 'subscription_status';
    static const String _subscriptionStatusKey = 'subscription_status';
  static const String _subscriptionExpirationKey = 'subscription_expiration';
  static const String SUBSCRIPTION_DATA_KEY = 'subscription_data';
  static const String AVATAR_URL_KEY = 'avatar';

  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init('user_data');
  }

  // Existing methods
  static String? getName() {
    return _storage.read(NAME_KEY);
  }

  static Future<void> saveName(String name) async {
    await _storage.write(NAME_KEY, name);
  }

  static String? getRole() {
    return _storage.read(ROLE_KEY);
  }

  static bool isFree() {
    return _storage.read(MEMBERSHIP_KEY) == 'free';
  }

  // Save user data
  static Future<void> saveUserData({
    required String token,
    required String email,
    required String name,
    required String role,
    String? subscription,
    String? avatarUrl,
  }) async {
    await _storage.write(TOKEN_KEY, token);
    await _storage.write(EMAIL_KEY, email);
    await _storage.write(NAME_KEY, name);
    await _storage.write(ROLE_KEY, role);
    await _storage.write(SUBSCRIPTION_KEY, subscription);
    await _storage.write(AVATAR_URL_KEY, avatarUrl);
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
  return _storage.read(MEMBERSHIP_KEY) ?? 'free';
}


  static bool isPremiumUser() {
    final membership = getMembershipStatus();
    return membership == 'premium';
  }

  static bool isFreeUser() {
    final membership = getMembershipStatus();
    return membership == 'free';
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
    print(
        'UserStorage: Checking membership expiry. Now: $now, Expiry: $expiry');
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

  // Simpan status kehadiran untuk course tertentu
  static Future<void> saveAttendanceStatus(
      String courseId, bool hasAttended) async {
    await _storage.write('attendance_$courseId', hasAttended);
  }

  // Ambil status kehadiran untuk course tertentu
  static bool getAttendanceStatus(String courseId) {
    return _storage.read('attendance_$courseId') ?? false;
  }

  // Hapus status kehadiran (opsional)
  static Future<void> clearAttendanceStatus(String courseId) async {
    await _storage.remove('attendance_$courseId');
  }

  // Downgrade user (when membership expires or cancelled)
  static Future<void> downgradeToBasic() async {
    await _storage.write(ROLE_KEY, 'basic_user');
    await saveMembershipStatus('basic');
  }
  
  // Set as free
  static Future<void> setAsFree() async {
    await _storage.write(ROLE_KEY, 'Free');
    await saveMembershipStatus('Free');
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

  // Add these methods to your existing UserStorage class:

  // Avatar URL methods
  static Future<void> saveAvatarUrl(String avatarUrl) async {
    await _storage.write(AVATAR_URL_KEY, avatarUrl);
  }

  static String? getAvatarUrl() {
    return _storage.read(AVATAR_URL_KEY);
  }

  static Future<void> saveUserDataWithAvatar({
    required String token,
    required String email,
    required String name,
    required String role,
    String? avatarUrl,
  }) async {
    await _storage.write(TOKEN_KEY, token);
    await _storage.write(EMAIL_KEY, email);
    await _storage.write(NAME_KEY, name);
    await _storage.write(ROLE_KEY, role);
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await _storage.write(AVATAR_URL_KEY, avatarUrl);
    }
  }

  // Get membership info for display
  static Future<Map<String, dynamic>> getMembershipInfo() async {
    final expiry = await getMembershipExpiry();
    final expired = expiry == null ? true : DateTime.now().isAfter(expiry);
    final valid = isPremiumUser() && !expired;

    return {
      'role': getRole() ?? 'free',
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
    final levelStr = prefs.getString('access_level') ?? 'free';

    switch (levelStr) {
      case 'premium':
        return UserAccessLevel.premium;
      default:
        return UserAccessLevel.free;
    }
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    try {
      print('🧹 Starting UserStorage cleanup...');
      
      // Clear GetStorage data
      print('📦 Clearing GetStorage...');
      await _storage.erase();
      
      // Clear SharedPreferences data
      print('🔧 Clearing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      
      // List of specific keys to clear
      final keysToRemove = [
        'membership_expiry',
        'access_level',
        'subscription_status', 
        'subscription_expiration',
        'fcm_token',
        'user_preferences',
        'last_sync',
        'app_settings',
      ];
      
      // Remove specific keys
      for (String key in keysToRemove) {
        await prefs.remove(key);
        print('🗑️ Removed key: $key');
      }
      
      // Clear attendance data (courses with attendance_prefix)
      print('📚 Clearing attendance data...');
      final allKeys = prefs.getKeys();
      final attendanceKeys = allKeys.where((key) => key.startsWith('attendance_'));
      for (String key in attendanceKeys) {
        await prefs.remove(key);
        print('🗑️ Removed attendance key: $key');
      }
      
      // Optional: If you want to clear ALL SharedPreferences (be careful!)
      // await prefs.clear();
      
      print('✅ UserStorage cleanup completed successfully');
      
    } catch (e) {
      print('❌ Error during UserStorage cleanup: $e');
      
      // Try alternative cleanup method
      try {
        print('🔄 Attempting alternative cleanup...');
        await _alternativeClearData();
      } catch (altError) {
        print('❌ Alternative cleanup also failed: $altError');
        rethrow;
      }
    }
  }
  static Future<void> _alternativeClearData() async {
    try {
      // Force clear GetStorage by recreating it
      await GetStorage.init('user_data_backup');
      final backupStorage = GetStorage('user_data_backup');
      await backupStorage.erase();
      
      // Manual key removal for critical data
      final criticalKeys = [
        TOKEN_KEY,
        EMAIL_KEY, 
        NAME_KEY,
        ROLE_KEY,
        MEMBERSHIP_KEY,
        USER_ID_KEY,
        SUBSCRIPTION_DATA_KEY,
        AVATAR_URL_KEY,
      ];
      
      for (String key in criticalKeys) {
        _storage.remove(key);
      }
      
      print('✅ Alternative cleanup completed');
    } catch (e) {
      print('❌ Alternative cleanup failed: $e');
      rethrow;
    }
  }
static Future<bool> verifyDataCleared() async {
    try {
      final token = getToken();
      final email = getEmail();
      final name = getName();
      final role = getRole();
      final membership = getMembershipStatus();
      
      final prefs = await SharedPreferences.getInstance();
      final membershipExpiry = prefs.getString('membership_expiry');
      final accessLevel = prefs.getString('access_level');
      
      final isCleared = token == null && 
                       email == null && 
                       name == null && 
                       role == null &&
                       membership == 'visitor' &&
                       membershipExpiry == null &&
                       accessLevel == null;
      
      print('🔍 Data verification result: ${isCleared ? "CLEARED" : "NOT CLEARED"}');
      print('  - Token: $token');
      print('  - Email: $email');  
      print('  - Name: $name');
      print('  - Role: $role');
      print('  - Membership: $membership');
      print('  - Membership Expiry: $membershipExpiry');
      print('  - Access Level: $accessLevel');
      
      return isCleared;
    } catch (e) {
      print('❌ Error verifying data cleared: $e');
      return false;
    }
  }

  // Force reset method (nuclear option)
  static Future<void> forceReset() async {
    try {
      print('🚨 FORCE RESET initiated...');
      
      // Recreate GetStorage
      await GetStorage.init('user_data_new');
      final newStorage = GetStorage('user_data_new'); 
      await newStorage.erase();
      
      // Clear ALL SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      print('✅ FORCE RESET completed');
    } catch (e) {
      print('❌ FORCE RESET failed: $e');
      rethrow;
    }
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
  free,
  premium,
}

// Extension for easy access level checking
extension UserAccessLevelExtension on UserAccessLevel {
  bool get canAccessPremiumContent {
    return this == UserAccessLevel.premium;
  }

  bool get canAccessFreeContent {
    return this != UserAccessLevel.free;
  }

  String get displayName {
    switch (this) {
      case UserAccessLevel.free:
        return 'free';
      case UserAccessLevel.premium:
        return 'premium';
    }
  }
}

