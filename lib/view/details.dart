import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/controller.dart';
import '../utils/color.dart';

class QuotesPage extends StatefulWidget {
  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final QuotesController controller = Get.put(QuotesController());
  late Map<String, dynamic> data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  Color getRandomColor() {
    final random = Random();
    return colorList[random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    List quotes = data['quotes'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quotes',
          style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 28),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: quotes.isEmpty
          ? Center(
              child: Text("No quotes available",
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Column(
              children: [
                Expanded(
                  child: CarouselSlider.builder(
                    itemCount: quotes.length,
                    itemBuilder: (context, index, realIndex) {
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.black12, width: 1),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [getRandomColor(), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    quotes[index]['quote'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 20.0,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '- ${quotes[index]['author']}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.6,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 1200),
                      viewportFraction: 0.85,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Swipe for more quotes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.share),
        backgroundColor: getRandomColor(),
      ),
    );
  }
}
