import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.off(QuoteCategoriesPage());
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Quotes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
