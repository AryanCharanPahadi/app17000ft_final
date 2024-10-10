import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to make responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      title: Text(
        title,
        style: AppStyles.appBarTitle(
          context,
          AppColors.onPrimary,
        ).copyWith(
          fontSize: screenWidth * 0.05, // Adjust font size based on screen width
        ),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(
        color: AppColors.onPrimary,
      ),
      // You can also adjust padding or other properties if needed
      toolbarHeight: screenWidth * 0.15, // Example of adjusting toolbar height
      // If you have any other widgets in the app bar, you can adjust their sizes similarly
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
