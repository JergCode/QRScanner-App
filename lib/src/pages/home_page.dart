import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart' as qrScanner;
import 'package:qr_scanner_app/src/bloc/scans_bloc.dart';
import 'package:qr_scanner_app/src/enums/qr_types_enum.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';

import 'package:qr_scanner_app/src/pages/links_page.dart';
import 'package:qr_scanner_app/src/pages/maps_page.dart';
import 'package:qr_scanner_app/src/utils/scan_utils.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentPage = 0;
  final ScansBloc scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _loadPage(_currentPage),
      bottomNavigationBar: _buildBNB(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  _buildBNB() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (index) => setState(() {
        _currentPage = index;
      }),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.link),
          title: Text('Links'),
        ),
      ],
    );
  }

  _loadPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return LinksPage(type: QRtypes.geo);
      case 1:
        return LinksPage(type: QRtypes.http);
    }
  }

  _scanQR() {
    // value = 'https://fernando-herrera.com';
    // value = 'geo:40.67113311224576,-73.94551649531253';

    qrScanner.BarcodeScanner.scan().then((qrText) {
      var scan = ScanModel(value: qrText);
      scansBloc.addScan(scan);
      ScanUtils.launchURL(scan: scan, context: context);
    }).catchError((onError) {
      print(onError);
    });
  }
}
