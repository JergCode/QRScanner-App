import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }) {
    this.type = this.value.contains('http') ? 'http' : 'geo';
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  LatLng get latLong {
    if (!this.type.startsWith('geo')) {
      print('returning null');
      return null;
    }

    final latLon = this.value.replaceFirst('geo:', '').split(',');
    print(latLon);
    final lat = double.parse(latLon[0]);
    final lng = double.parse(latLon[1]);
    return LatLng(lat, lng);
  }
}
