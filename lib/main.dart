import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quetes_js_sql/view/fav_page.dart';

import 'view/details.dart';
import 'view/home_page.dart';
import 'view/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.blueGrey[50],
        ),
        cardColor: Colors.white,
        dividerColor: Colors.blueGrey[200],
      ),
      darkTheme: ThemeData.dark().copyWith(
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.grey[850],
        ),
        cardColor: Colors.grey[800],
        dividerColor: Colors.grey[700],
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/categories', page: () => QuoteCategoriesPage()),
        GetPage(name: '/quotes', page: () => QuotesPage()),
        GetPage(name: '/fav', page: () => const FavPage()),
      ],
    );
  }
}
