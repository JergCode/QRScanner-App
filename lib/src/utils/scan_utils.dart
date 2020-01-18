import 'package:flutter/widgets.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:qr_scanner_app/src/pages/map_page.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ScanUtils {
  static launchURL({ScanModel scan, BuildContext context}) async {
    if (scan.type.contains('http')) {
      if (await launcher.canLaunch(scan.value)) {
        await launcher.launch(scan.value);
      } else {
        throw 'Could not launch ${scan.value}';
      }
    } else {
      Navigator.pushNamed(context, MapPage.routeName, arguments: scan);
    }
  }
}
