import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
export 'package:qr_scanner_app/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  static const _TABLE = 'Scans';

  DBProvider._();

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path + 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $_TABLE ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')');
    });
  }

  // ===================================================================================================
  // INSERTS
  // ===================================================================================================
  newScanRow(ScanModel newScan) async {
    final db = await database;
    final res = await db.rawInsert("INSERT INTO $_TABLE (id, type, value) "
        "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}')");
    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;
    final res = db.insert(_TABLE, newScan.toJson());
    return res;
  }

// ===================================================================================================
// SELECTS
// ===================================================================================================
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query(_TABLE, where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    var scans = new List<ScanModel>();
    final db = await database;
    final res = await db.query(_TABLE).catchError((err) => []);
    // final res = [
    //   {'id': 1, 'type': 'http', 'value': 'https://something1'},
    //   {'id': 2, 'type': 'http', 'value': 'https://something2'},
    //   {'id': 3, 'type': 'geo', 'value': 'geo:value1,value2'},
    //   {'id': 4, 'type': 'get', 'value': 'geo:value3,value4'},
    //   {'id': 5, 'type': 'http', 'value': 'https://something3'},
    // ];
    res?.forEach((scan) => scans.add(ScanModel.fromJson(scan)));
    // scans = res.map((scan) => ScanModel.fromJson(scan)).toList();
    return scans;
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    var scans = new List<ScanModel>();
    final db = await database;
    // ============================== POR QUERY ==============================
    // final res = await db.rawQuery("SELECT * FROM $_table WHERE type = '$type'");
    final res = await db.query(_TABLE, where: 'type = ?', whereArgs: [type]);
    res?.forEach((scan) => scans.add(ScanModel.fromJson(scan)));

    return scans;
  }

  // ===================================================================================================
  // UPDATES
  // ===================================================================================================
  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.update(_TABLE, newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);

    return res;
  }

  // ===================================================================================================
  // DELETE
  // ===================================================================================================
  Future<int> deleteScan(int id) async {
    print(id.toString());
    final db = await database;
    final res = await db.delete(_TABLE, where: 'id = ?', whereArgs: [id]);
    print(res);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    // ============================== DELETE MEDIANTE QUERY ==============================
    final res = await db.rawDelete('DELETE FROM $_TABLE');
    // final res = await db.delete(_table);

    return res;
  }
}
