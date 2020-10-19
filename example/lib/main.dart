import 'package:flutter/material.dart';
import 'package:flutter_umeng/flutter_umeng.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UMeng.init(androidAppKey: '5f895b5a94846f78a9749090', iosAppKey: '5f89595094846f78a9748eca', channel: "channel");
  UMeng.setLogEnabled(true);
  runApp(MaterialApp(
    title: 'UMeng example',
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
        title: Text('UMeng example'),
      ),
      body: Center(child: Text('UMeng 初始化完成')),
    );
  }
}
