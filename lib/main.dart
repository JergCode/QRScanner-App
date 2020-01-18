import 'package:flutter/material.dart';
import 'package:qr_scanner_app/src/pages/home_page.dart';
import 'package:qr_scanner_app/src/pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Scanner App',
        initialRoute: '/home',
        routes: {
          HomePage.routeName: (_) => HomePage(),
          MapPage.routeName: (_) => MapPage(),
        },
        theme: _buildTheme());
  }

  _buildTheme() {
    return ThemeData(
        primaryColor: Colors.deepPurple,
        splashColor: Colors.green,
        buttonColor: Colors.deepPurple,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurple,
        ));
  }
}
