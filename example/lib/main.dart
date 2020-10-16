import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter UMeng',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter UMeng example'),
      ),
      body: Center(
        child: null,
      ),
    );
  }
}
