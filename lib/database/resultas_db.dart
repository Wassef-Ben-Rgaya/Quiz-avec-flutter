import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ResultatDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<int> insertData(String name, double score) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(
        'INSERT INTO Resultat (Nom, score) VALUES (?, ?)', [name, score]);
    return response;
  }

  Future<List<Map<String, dynamic>>> readData(String query) async {
    Database? mybd = await db;
    List<Map<String, dynamic>> response = await mybd!.rawQuery(query);
    return response;
  }

  Future<void> updateData(int id, String newName, double newScore) async {
    Database? mydb = await db;
    await mydb!.rawUpdate(
      'UPDATE Resultat SET Nom = ?, score = ? WHERE id = ?',
      [newName, newScore, id],
    );
  }

  Future<void> deleteData(int id) async {
    Database? mydb = await db;
    await mydb!.rawDelete('DELETE FROM Resultat WHERE id = ?', [id]);
  }
}

Future<Database> initialDb() async {
  String databasepath = await getDatabasesPath();
  String path = join(databasepath, 'ResultatDB');
  Database mydb = await openDatabase(path,
      onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
  return mydb;
}

void _onUpgrade(Database db, int oldversion, newversion) {}

void _onCreate(Database db, int version) async {
  await db.execute('''
   CREATE TABLE Resultat (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nom TEXT,
    score REAL
  )''');
}
