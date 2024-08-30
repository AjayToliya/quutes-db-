import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../model/controller.dart';
import '../utils/color.dart';

class QuoteCategoriesPage extends StatefulWidget {
  @override
  _QuoteCategoriesPageState createState() => _QuoteCategoriesPageState();
}

class _QuoteCategoriesPageState extends State<QuoteCategoriesPage> {
  late Future<Map<String, dynamic>> jsonData;

  @override
  void initState() {
    super.initState();
    jsonData = loadJsonData();
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    String jsonString = await rootBundle.loadString("assets/quotes.json");
    return jsonDecode(jsonString);
  }

  Color getRandomColor() {
    final random = Random();
    return colorList[random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quote Categories"),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed('/fav');
              },
              icon: Icon(Icons.favorite))
        ],
      ),
      drawer: drawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: jsonData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: snapshot.data!.keys.length,
                itemBuilder: (context, index) {
                  String category = snapshot.data!.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          "/quotes",
                          arguments: {
                            'quotes': snapshot.data![category],
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [getRandomColor(), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}

Widget drawer() {
  final QuotesController controller = Get.put(QuotesController());

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('Rachel Frazer'),
          accountEmail: Text('heyfromrachel@gmail.com'),
          currentAccountPicture: CircleAvatar(
            child: FlutterLogo(size: 50),
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text('Inbox'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('Bookmarked'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Messages'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.drafts),
          title: Text('Draft'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Places'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.pie_chart),
          title: Text('Stats'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.archive),
          title: Text('Archived'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favorites'),
          onTap: () {
            Get.toNamed('/fav');
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Read'),
          onTap: () {},
        ),
        const Divider(),
        Obx(
          () => ListTile(
            leading: Icon(
              controller.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
              color: controller.isDarkMode.value
                  ? Colors.amberAccent
                  : Colors.blueAccent,
            ),
            title: Text('Theme'),
            trailing: Switch(
              value: controller.isDarkMode.value,
              onChanged: (value) {
                controller.toggleTheme();
              },
              activeColor: Colors.amber,
            ),
          ),
        ),
      ],
    ),
  );
}
