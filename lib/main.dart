import 'package:flutter/material.dart';
import 'package:map_test/real_map_test_api/app/controllers/map_controller.dart';
import 'package:map_test/real_map_test_api/app/views/map_screen.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    Get.put(MapController());

    return GetMaterialApp(
      // Use GetMaterialApp instead of MaterialApp
      title: 'Route Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapScreen(),

    );
  }
}