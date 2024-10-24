
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _userDataKey = 'userData';
  static const String _isLoggedInKey = 'isLoggedIn';

  // Method to store user data
  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    String userDataJson = json.encode(userData);
    await prefs.setString(_userDataKey, userDataJson);
    await setLoginState(true); // Ensure login state is set to true
    print('User data stored: $userData');
  }

  // Method to retrieve user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString(_userDataKey);

    if (userDataJson != null) {
      return json.decode(userDataJson);
    }
    return null;
  }

  // Method to remove user data
  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    print('User data removed.');
  }

  // Method to log out (clears user data and sets login state to false)
  static Future<void> logout() async {
    await removeUserData();
    await setLoginState(false);
    print('User logged out.');
  }

  // Method to set login state
  static Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    print('Login state set to: $isLoggedIn');
  }

  // Method to get login state
  static Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false; // Default to false if not set
  }
}
