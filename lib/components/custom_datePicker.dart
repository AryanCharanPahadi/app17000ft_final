import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final Function(DateTime) onDateChanged;
  final bool isStartDate;
  final String? errorText; // Added error text parameter

  const CustomDatePicker({
    Key? key,
    required this.selectedDate,
    required this.label,
    required this.onDateChanged,
    this.isStartDate = true,
    this.errorText, // Initialize errorText
  }) : super(key: key);

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: isStartDate ? DateTime(2000) : selectedDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      onDateChanged(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: errorText != null ? Colors.red : Colors.grey), // Change border color on error
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!) // Format the date as dd/mm/yyyy
                      : "Select $label",
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? Colors.black : Colors.black54,
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        if (errorText != null) // Show error text if it exists
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
