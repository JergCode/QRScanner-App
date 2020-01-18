import 'dart:async';

import 'package:qr_scanner_app/src/models/scan_model.dart';

class Validators {
  final geoValidator = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(handleData: (scans, sink) {
    final geoScans = scans.where((s) => s.type.contains('geo')).toList();
    sink.add(geoScans);
  });

  final httpValidator = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(handleData: (scans, sink) {
    final geoScans = scans.where((s) => s.type.contains('http')).toList();
    sink.add(geoScans);
  });
}
