import 'package:fl_umeng/fl_umeng.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMeng Example',
      home: Scaffold(
          appBar: AppBar(title: const Text('UMeng Example')),
          body: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _HomePage()))));
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  String text = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  /// 注册友盟
  Future<void> init() async {
    debugPrint('注册友盟');
    final bool? data = await FlUMeng().init(
        preInit: true,
        androidAppKey: '5f8fe2abfac90f1c19a8642e',
        iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
        channel: 'channel');
    debugPrint('Umeng 初始化成功 = $data');
    final bool? crash = await FlUMeng().setConfigWithCrash();
    debugPrint('UmengCrash 初始化成功 = $crash');
    await FlUMeng().setConfigWithCrash();
    await FlUMeng().setLogEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      Text(text, textAlign: TextAlign.center),
      const SizedBox(height: 20),
      Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().signIn('userId');
                  text = 'signIn  $data';
                  setState(() {});
                },
                child: const Text('signOff')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().signOff();
                  text = 'signOff  $data';
                  setState(() {});
                },
                child: const Text('signOff')),
            ElevatedButton(
                onPressed: () async {
                  final bool data =
                      await FlUMeng().setPageCollectionModeManual();
                  text = 'setPageCollectionModeManual  $data';
                  setState(() {});
                },
                child: const Text('setPageCollectionModeManual')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().onPageStart('pageStart');
                  text = 'onPageStart  $data';
                  setState(() {});
                },
                child: const Text('onPageStart')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().onPageEnd('pageEnd');
                  text = 'onPageEnd  $data';
                  setState(() {});
                },
                child: const Text('onPageEnd')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().setPageCollectionModeAuto();
                  text = 'setPageCollectionModeAuto  $data';
                  setState(() {});
                },
                child: const Text('setPageCollectionModeAuto')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng()
                      .onEvent('test', <String, String>{'test': 'test'});
                  text = 'onEvent  $data';
                  setState(() {});
                },
                child: const Text('onEvent')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().setLogEnabled(true);
                  text = 'logEnabled  $data';
                  setState(() {});
                },
                child: const Text('logEnabled')),
          ]),
      const Padding(padding: EdgeInsets.all(15), child: Text('仅支持 Android')),
      Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  final bool data =
                      await FlUMeng().setCustomLogWithCrash('key', 'type');
                  text = 'setCustomLogWithCrash  $data';
                  setState(() {});
                },
                child: const Text('setCustomLogWithCrash')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().reportError('error');
                  text = 'reportError  $data';
                  setState(() {});
                },
                child: const Text('reportError')),
          ])
    ]);
  }
}
