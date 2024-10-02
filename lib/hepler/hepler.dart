import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? database;

  Future<void> initDataBase() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, 'quotes.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String query =
            "CREATE TABLE IF NOT EXISTS quotes (id INTEGER PRIMARY KEY AUTOINCREMENT,category TEXT NOT NULL,quote TEXT NOT NULL,author TEXT NOT NULL);";
        await db.execute(query);
      },
    );
  }

  Future<int> insertQuote({required Quote quote}) async {
    if (database == null) {
      await initDataBase();
    }
    String query = '''
CREATE TABLE IF NOT EXISTS quotes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT NOT NULL,
  quote TEXT NOT NULL,
  author TEXT NOT NULL
);
''';
    List<dynamic> args = [quote.category, quote.quote, quote.author];

    int id = await database!.rawInsert(query, args);
    return id;
  }

  Future<List<Quote>> fetchAllQuotes() async {
    if (database == null) {
      await initDataBase();
    }
    String query = "SELECT * FROM quotes;";

    List<Map<String, dynamic>> allRecords = await database!.rawQuery(query);

    List<Quote> allQuotes =
        allRecords.map((Map<String, dynamic> e) => Quote.fromMap(e)).toList();

    return allQuotes;
  }

  Future<int> updateQuote({required Quote quote, required int id}) async {
    if (database == null) {
      await initDataBase();
    }

    String query =
        "UPDATE quotes SET category = ?, quote = ?, author = ? WHERE id = ?";
    List<dynamic> args = [quote.category, quote.quote, quote.author, id];

    int result = await database!.rawUpdate(query, args);

    return result;
  }

  Future<int> deleteQuote({required int id}) async {
    if (database == null) {
      await initDataBase();
    }
    String query = "DELETE FROM quotes WHERE id = ?;";
    List<dynamic> args = [id];

    int res = await database!.rawDelete(query, args);

    return res;
  }

  Future<int> deleteAllQuotes() async {
    if (database == null) {
      await initDataBase();
    }
    String query = "DELETE FROM quotes;";

    int res = await database!.rawDelete(query);

    return res;
  }

  Future<List<Quote>> searchQuotes({required String searchTerm}) async {
    if (database == null) {
      await initDataBase();
    }

    String query = "SELECT * FROM quotesWHERE quote LIKE ? OR author LIKE ?";
    List<Map<String, dynamic>> searchResults =
        await database!.rawQuery(query, ['%$searchTerm%', '%$searchTerm%']);

    List<Quote> allSearchResults =
        searchResults.map((e) => Quote.fromMap(e)).toList();
    return allSearchResults;
  }
}
