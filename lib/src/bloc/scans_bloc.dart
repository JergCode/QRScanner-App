import 'dart:async';

import 'package:qr_scanner_app/src/bloc/validator.dart';
import 'package:qr_scanner_app/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() => _singleton;

  ScansBloc._internal() {
    getScans();
  }

  final _scansStremController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansStremController.stream.transform(geoValidator);
  Stream<List<ScanModel>> get scansStreamHttp => _scansStremController.stream.transform(httpValidator);

  dispose() {
    _scansStremController.close();
  }

  getScans() async {
    _scansStremController.sink.add(await DBProvider.db.getAllScans());
  }

  getScansByType(String type) async {
    _scansStremController.sink.add(await DBProvider.db.getScansByType(type));
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }
}
