import 'dart:async';
import 'package:app17000ft_new/helper/shared_prefernce.dart';
import 'package:app17000ft_new/home/home_screen.dart';
import 'package:app17000ft_new/login/login_screen.dart';
import 'package:app17000ft_new/splash/splash_screen.dart';
import 'package:app17000ft_new/utils/dependency_injection.dart';
import 'package:app17000ft_new/version_file/version_controller.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:app17000ft_new/theme/theme_constants.dart';
import 'package:app17000ft_new/theme/theme_manager.dart';

import 'components/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await GetStorage.init(); // Initialize GetStorage
  DependencyInjection.init(); // Initialize any dependencies
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  GetStorage().write('version', version);

  runApp(const MyApp()); // Run the app
}

ThemeManager themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isLoggedIn; // Track the login state

  @override
  void initState() {
    super.initState();
    themeManager.addListener(_themeListener);
    _initializeApp(); // Initialize app on start
  }

  @override
  void dispose() {
    themeManager.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    if (mounted) {
      setState(() {}); // Update theme when it changes
    }
  }

  // Initialize app and check login state
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Delay for splash screen
    _checkLoginState(); // Check if the user is logged in
  }

  // Check the login state and navigate accordingly
  Future<void> _checkLoginState() async {
    bool isLoggedIn = await SharedPreferencesHelper.getLoginState();

    if (_isLoggedIn != isLoggedIn) {
      _isLoggedIn = isLoggedIn; // Update the login state only once

      if (_isLoggedIn!) {
        // Navigate to HomeScreen if logged in
        Get.offAll(() => const HomeScreen());

        // Fetch version after half a second delay
        Future.delayed(const Duration(milliseconds: 500), () {
          VersionController versionController = Get.put(VersionController());
          versionController.fetchVersion();
        });
      } else {
        // Navigate to LoginScreen if not logged in
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode, // Handle dark/light mode
      home: const SplashScreen(), // Show splash screen initially
      debugShowCheckedModeBanner: false,
    );
  }
}
