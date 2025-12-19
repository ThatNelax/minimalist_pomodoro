import 'package:minimalist_pomodoro/timerPreset.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static Database? _db;

  static Future<void> turnOnDatabase() async {
    if (_db != null) return;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'timerPreset.db');
    print(path);

    _db = await openDatabase(path,
        version: 1,
        onCreate: (db, int version) async {
          await db.execute("""
              CREATE TABLE TimerTable(
              timerName TEXT PRIMARY KEY, 
              focusTime INTEGER NOT NULL, 
              shortBreak INTEGER NOT NULL, 
              longBreak INTEGER NOT NULL 
              )
          """);
        });
  }

  static Database get db {
    if (_db == null) {
      throw Exception("Database not initialized! Call turnOnDatabase() first.");
    }
    return _db!;
  }

  static Future<bool> addEntry({required String timerName, required int focusTime, required int shortBreak, required int longBreak}) async {
    var existsQuery = await db.rawQuery('SELECT timerName FROM TimerTable WHERE timerName = ?', [timerName]);
    if(existsQuery.isNotEmpty) return false;

    await db.transaction((txn) async {
      await txn.insert(
        'TimerTable',
        {
          'timerName': timerName,
          'focusTime': focusTime,
          'shortBreak': shortBreak,
          'longBreak': longBreak,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    return true;
  }

  static Future<List<TimerPreset>> getAllEntries() async {
    var queryResult = await db.rawQuery('SELECT * FROM TimerTable');

    print('Raw Query Result (Count: ${queryResult.length}): $queryResult');

    List<TimerPreset> entries = queryResult
        .map((resultMap) => TimerPreset.fromMap(resultMap))
        .toList();

    return entries;
  }

  static Future<List<String>> getAllEntryName() async {
    var queryResult = await db.rawQuery('SELECT timerName FROM TimerTable');

    List<String> entries = queryResult.map((resultMap) => resultMap['timerName'] as String).toList();

    return entries;
  }

  static Future<List<TimerPreset>> searchEntriesByBarcodePrefix(String barcodePrefix) async {
    String searchPattern = '$barcodePrefix%';

    var queryResult = await db.query(
      'ProductTable',
      where: 'barcodeNo LIKE ?',
      whereArgs: [searchPattern],
    );

    List<TimerPreset> entries = queryResult
        .map((resultMap) => TimerPreset.fromMap(resultMap))
        .toList();

    return entries;
  }

  static Future<void> deleteWithName(String timerName) async {
    print("Entered timer name : " + timerName);
    await db.rawQuery('DELETE FROM TimerTable WHERE timerName = \'$timerName\'' );
  }

  static Future<void> editEntry({
    required String oldTimerName,
    required String timerName,
    required int focusTime,
    required int shortBreak,
    required int longBreak
  }) async {
    await db.update(
      'TimerTable',
      {
        'timerName': timerName,
        'focusTime': focusTime,
        'shortBreak': shortBreak,
        'longBreak': longBreak,
      },
      where: 'timerName = ?',
      whereArgs: [oldTimerName],
    );
  }
}