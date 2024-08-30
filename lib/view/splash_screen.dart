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
        child: Image.asset(
          'assets/images/1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
