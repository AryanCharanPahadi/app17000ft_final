import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';
import '../helper/shared_prefernce.dart';
import 'custom_confirmation.dart';

class UserController extends GetxController {
  var username = ''.obs;
  var officeName = ''.obs;
  var offlineVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Load user data on initialization
  }

  // Method to load user data from shared preferences
  Future<void> loadUserData() async {
    print("Loading user data...");
    var userData = await SharedPreferencesHelper.getUserData();
    if (userData != null && userData['user'] != null) {
      username.value = userData['user']['username'] ?? '';
      officeName.value = userData['user']['office_name'] ?? '';
      offlineVersion.value = userData['user']['offline_version'] ?? '';

      // Print loaded user data
      print("Username: ${username.value}");
      print("Office Name: ${officeName.value}");
      print("Offline Version: ${offlineVersion.value}");
    } else {
      print("No user data found.");
    }
  }

  // Method to clear user data on logout
  void clearUserData() {
    print("Clearing user data...");
    username.value = '';
    officeName.value = '';
    offlineVersion.value = '';
    print("User data cleared.");
    update(); // Notify the UI that data has been updated
  }

  // Method to check app version and show prompt
  Future<void> checkForVersionUpgrade() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    // Print current app version
    print("Current app version: $currentVersion");

    // Compare the versions
    if (offlineVersion.value.isNotEmpty &&
        _compareVersions(currentVersion, offlineVersion.value) > 0) { // Change to < 0
      print("A new version is available. Offline version: ${offlineVersion.value}");
      // Add a slight delay to ensure the dialog appears correctly
      Future.delayed(Duration(milliseconds: 100), () {
        _showUpgradePrompt();
      });
    } else {
      print("No upgrade available. Current version is up to date.");
    }
  }

  // Compare version strings
  int _compareVersions(String current, String offline) {
    List<String> currentParts = current.split('.');
    List<String> offlineParts = offline.split('.');
    int length = currentParts.length > offlineParts.length ? currentParts.length : offlineParts.length;

    for (int i = 0; i < length; i++) {
      int currentPart = (i < currentParts.length) ? int.parse(currentParts[i]) : 0;
      int offlinePart = (i < offlineParts.length) ? int.parse(offlineParts[i]) : 0;
      if (currentPart != offlinePart) {
        return currentPart - offlinePart;
      }
    }
    return 0; // Versions are equal
  }

  void _showUpgradePrompt() {
    print("Showing upgrade prompt...");
    Get.dialog(
      Confirmation(
        title: "Update Available",
        desc: "A new version of the app is available. Please update to the latest version.",
        onPressed: () {
          // Logic to navigate to the app store or update mechanism can be added here
          print("Navigating to update...");
        },
        yes: "OK",
        iconname: Icons.update, // You can choose any relevant icon
      ),
    );
  }

}
