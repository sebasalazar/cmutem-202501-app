import 'package:hm/model/metrics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  factory DbService() => _instance;

  DbService._internal();

  Database? _db;

  Future<void> _onCreate(Database database, int version) async {
    await database.execute('''
          CREATE TABLE mediciones (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            fecha INTEGER NOT NULL,
            dispositivo INTEGER NOT NULL,
            valor REAL NOT NULL,
            unidad INTEGER NOT NULL,
            creacion INTEGER NOT NULL,
            actualizacion  INTEGER NOT NULL);
          ''');
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'hm.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDatabase();
    return _db!;
  }

  Future<int> insertMetric(Metric metric) async {
    final Database instance = await db;
    return await instance.insert('mediciones', metric.toMapDb());
  }

  Future<List<Metric>> getMetrics() async {
    final Database instance = await db;
    List<Map<String, dynamic>> result = await instance.query('mediciones');
    return result.map((map) => Metric.fromDbMap(map)).toList();
  }
}
