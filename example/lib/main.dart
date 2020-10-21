import 'package:flutter/material.dart';
import 'package:fl_umeng/fl_umeng.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ///注册友盟
  initUM(androidAppKey: '5f8fe2abfac90f1c19a8642e', iosAppKey: '5f8fe4d4c1122b44acfc7aa7', channel: 'channel');

  ///是否开启log
  setLogEnabledUM(true);
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
    return Scaffold(appBar: AppBar(title: const Text('UMeng example')), body: const Center(child: Text('UMeng 初始化完成')));
  }
}
