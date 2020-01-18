import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qr_scanner_app/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  static const routeName = "/map";

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapCtrl = new MapController();
  int mapType = 0;
  @override
  Widget build(BuildContext context) {
    ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _mapCtrl.move(scan.latLong, 13.0),
          )
        ],
      ),
      body: Stack(
        children: [
          _buildFlutterMap(scan),
          _buildTitle(context),
        ],
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          mapType++;
          if (mapType > 4) {
            mapType = 0;
          }
        });
      },
      child: Icon(Icons.ac_unit),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildFlutterMap(ScanModel scan) {
    return FlutterMap(
      options: MapOptions(
        center: scan.latLong,
        zoom: 13.0,
      ),
      layers: [
        _buildMap(),
        _buildMarks(scan),
      ],
      mapController: _mapCtrl,
    );
  }

  _buildTitle(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      child: Text(
        _getMapId(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
            color: _getMapId().contains('dark') ? Colors.white24 : Colors.black45,
            offset: Offset(-1.0, 1.0),
            spreadRadius: 1.0,
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(255, 231, 193, 1),
      ),
    );
  }

  _buildMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken': 'pk.eyJ1IjoiamVyZ2NvZGUiLCJhIjoiY2s1aWZ4ZDJwMGU4NzNrbXNka2lqODZpdyJ9.qbc4nlqw01B3LkHyZs6fkw',
          'id': 'mapbox.${_getMapId()}'
          // tipos de id: streets, dark, light, satellite, outdoors
        });
  }

  String _getMapId() {
    const Map<int, String> mapTypes = {
      0: 'streets',
      1: 'dark',
      2: 'light',
      3: 'satellite',
      4: 'outdoors',
    };
    return mapTypes[this.mapType];
  }

  _buildMarks(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
        width: 100.0,
        height: 100.0,
        point: scan.latLong,
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 35,
          ),
        ),
      )
    ]);
  }
}
