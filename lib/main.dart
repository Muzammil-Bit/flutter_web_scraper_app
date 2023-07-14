import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/scrape_controller.dart';
import 'screens/main_app_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ScrapeController());
    return GetMaterialApp(
      home: MainApp(),
    );
  }
}
