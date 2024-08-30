import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotesController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode(!isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
