import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gym_mania/services/database_service.dart';
import 'package:gym_mania/views/dashboard_screen.dart';
import 'package:gym_mania/views/splash_screen.dart';
import 'package:gym_mania/constants/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();

  // Initialize sample data if database is empty
  await databaseService.initializeSampleDataIfEmpty();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Mania',
      theme: AppConstants.lightTheme,
      home: const SplashScreen(),
    );
  }
}

