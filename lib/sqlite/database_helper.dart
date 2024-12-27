import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../user_model.dart';

class UserDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicjalizacja bazy danych
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath(); // Ścieżka do baz danych
    final path = join(dbPath, 'user_database.db'); // Pełna ścieżka do bazy

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tworzenie tabeli przy inicjalizacji bazy
        await createTableIfNotExists(db);
      },
      onOpen: (db) async {
        // Tworzenie tabeli, jeśli jej nie ma, podczas otwierania bazy
        await createTableIfNotExists(db);
      },
    );
  }

  // Metoda do tworzenia tabeli, jeśli jej nie ma
  Future<void> createTableIfNotExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        pictureUrl TEXT,
        age INTEGER,
        gender TEXT,
        city TEXT,
        country TEXT,
        postcode INTEGER
      )
    ''');
  }

  // Metoda do dodawania użytkownika do bazy
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(), // Konwertujemy obiekt UserModel na Mapę
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Nadpisuje, jeśli istnieje konflikt
    );
  }

  // Metoda do pobierania wszystkich użytkowników z bazy
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('users'); // Pobiera dane z tabeli `users`

    // Mapowanie danych z SQLite na listę obiektów UserModel
    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  // Metoda do usuwania użytkownika z bazy danych
  Future<void> deleteUser(int id) async {
    final db = await database;

    // Usuwanie użytkownika na podstawie jego id
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
