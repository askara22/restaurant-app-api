import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavRest = 'restaurants';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavRest (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             city TEXT,
             pictureId TEXT,
             rating DOUBLE
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertBookmark(RestaurantList restaurant) async {
    final db = await database;
    await db!.insert(_tblFavRest, restaurant.toJson());
  }

  Future<List<RestaurantList>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavRest);

    return results.map((res) => RestaurantList.fromJson(res)).toList();
  }

  Future<Map> getBookmarkByUrl(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavRest,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBookmark(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavRest,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
