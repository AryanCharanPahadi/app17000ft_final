import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaveService {
  final String apiUrl = 'https://mis.17000ft.org/modules/leaveApplication/compoff.php';

  Future<List<String>> fetchLeaveDates(String empId) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'emp_id': empId}, // Sending emp_id as POST data
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a JSON array
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<String>.from(jsonResponse.map((date) => date.toString()));
      } else {
        throw Exception('Failed to load leave dates');
      }
    } catch (e) {
      throw Exception('Error fetching leave dates: $e');
    }
  }
}
