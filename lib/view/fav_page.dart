import 'dart:math';

import 'package:flutter/material.dart';

import '../hepler/hepler.dart';
import '../model/model.dart';
import '../utils/color.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> with TickerProviderStateMixin {
  DatabaseHelper databaseHelper = DatabaseHelper.databaseHelper;
  List<Quote> quotes = [];
  String searchTerm = '';
  TextEditingController searchController = TextEditingController();

  void showAddQuoteModalBottomSheet() {
    final categoryController = TextEditingController();
    final quoteController = TextEditingController();
    final authorController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Quote',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFCB6CFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: quoteController,
                    decoration: InputDecoration(
                      labelText: 'Quote',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: authorController,
                    decoration: InputDecoration(
                      labelText: 'Author',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String category = categoryController.text.trim();
                        String quote = quoteController.text.trim();
                        String author = authorController.text.trim();

                        if (category.isNotEmpty &&
                            quote.isNotEmpty &&
                            author.isNotEmpty) {
                          await databaseHelper.insertQuote(
                            quote: Quote(
                              id: 0,
                              category: category,
                              quote: quote,
                              author: author,
                            ),
                          );
                          loadQuotes();
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xFFCB6CFF),
                        shadowColor: Color(0xFFCB6CFF).withOpacity(0.4),
                        elevation: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    quotes = await databaseHelper.fetchAllQuotes();
    setState(() {});
  }

  Future<void> searchQuotes(String term) async {
    quotes = await databaseHelper.searchQuotes(searchTerm: term);
    setState(() {});
  }

  Future<void> deleteQuote(int id) async {
    await databaseHelper.deleteQuote(id: id);
    loadQuotes(); // Refresh the list after deletion
  }

  Future<void> deleteAllQuotes() async {
    await databaseHelper.deleteAllQuotes();
    loadQuotes(); // Refresh the list after deletion
  }

  void confirmDeleteAllQuotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Quotes'),
        content: Text(
            'Are you sure you want to delete all quotes? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await deleteAllQuotes();
              Navigator.of(context).pop();
            },
            child: Text('Delete All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void confirmDeleteQuote(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Quote'),
        content: Text('Are you sure you want to delete this quote?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await deleteQuote(id);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search quotes or authors...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                searchTerm = value;
                if (searchTerm.isNotEmpty) {
                  searchQuotes(searchTerm);
                } else {
                  loadQuotes();
                }
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: confirmDeleteAllQuotes,
            tooltip: 'Delete All Quotes',
          ),
        ],
        elevation: 0,
      ),
      body: quotes.isEmpty
          ? Center(
              child: Text(
                'No quotes available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final randomColor =
                      colorList[Random().nextInt(colorList.length)];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: randomColor,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          quotes[index].quote,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ${quotes[index].author}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Category: ${quotes[index].category}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDeleteQuote(quotes[index].id),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddQuoteModalBottomSheet,
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Color(0xFFCB6CFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
