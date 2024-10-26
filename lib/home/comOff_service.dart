import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveController extends GetxController {
  final RxList<String> availableDates = <String>[].obs;
  String? selectedLieuDate;

  // Method to fetch dates based on employee ID
  Future<void> fetchAvailableDates(String empId) async {
    try {
      print('Fetching available dates for emp_id: $empId');

      final requestBody = json.encode({'emp_id': empId});
      print('Request Body: $requestBody');

      final response = await http.post(
        Uri.parse('https://mis.17000ft.org/modules/leaveApplication/compoff.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          print('Received empty response body');
          Get.snackbar('Error', 'No available dates found.');
          return;
        }

        try {
          // Attempt to decode JSON
          final List<dynamic> data = json.decode(response.body);
          print('Decoded data: $data');

          if (data is List<String>) {
            availableDates.assignAll(data);
            print('Available dates fetched: $availableDates');
          } else {
            print('Unexpected response format: $data');
            Get.snackbar('Error', 'Unexpected response format.');
          }
        } catch (e) {
          print('Failed to decode JSON: $e');
          Get.snackbar('Error', 'Failed to decode available dates.');
        }
      } else {
        print('Failed to fetch dates. Response body: ${response.body}');
        throw Exception('Failed to load dates: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Failed to fetch available dates: $e');
    }
  }

}
