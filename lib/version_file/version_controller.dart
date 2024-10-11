import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../components/custom_confirmation.dart';
import '../home/home_screen.dart';

class VersionController extends GetxController {
  var version = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVersion();

  }

  // Fetch version from API
// Fetch version from API
  Future<void> fetchVersion() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://mis.17000ft.org/apis/fast_apis/version.php'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');  // Print the full response body for debugging
        var data = json.decode(response.body);
        version.value = data['version'] ?? '';
        print('Version from API: ${version.value}');  // Debug: Check the version returned from the API

        // Convert version to int for comparison
        int apiVersion = int.tryParse(version.value) ?? 0;
        print('Parsed version as integer: $apiVersion');  // Debug: Check the integer conversion

        // Check if the version is not equal to 4
        if (apiVersion != 4) {
          showUpgradePrompt();
        } else {
          print('Version is 4, no upgrade prompt needed.');  // Debug: Version matches, no prompt.
        }
      } else {
        print('Error: Failed to fetch version, Status code: ${response.statusCode}');
        // Handle errors
        // Get.snackbar('Error', 'Failed to fetch version');
      }
    } catch (e) {
      print('Exception: $e');  // Print the error for debugging
      // Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void showUpgradePrompt() {
    if (Get.isDialogOpen != true) {  // Ensure only one dialog is open
      Get.dialog(
        Confirmation(
          title: "Update Available",
          desc: "A new version of the app is available. Please update to the latest version.",
          onPressed: () {
            print("Navigating to update...");

          },
          yes: "OK",
          iconname: Icons.update, // You can choose any relevant icon
        ),
      );
    }
  }

}
