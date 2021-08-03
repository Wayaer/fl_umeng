import 'package:fl_umeng/fl_umeng.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 注册友盟
  final bool? data = await FlUMeng.instance.init(
      androidAppKey: '5f8fe2abfac90f1c19a8642e',
      iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
      channel: 'channel');
  print('Umeng 初始化成功 = $data');

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMeng example',
      home: _HomePage()));
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('UMeng example')),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () async {
                              final bool data =
                                  await FlUMeng.instance.signIn('userId');
                              text = 'signIn  $data';
                              setState(() {});
                            },
                            child: const Text('signOff')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data =
                                  await FlUMeng.instance.signOff();
                              text = 'signOff  $data';
                              setState(() {});
                            },
                            child: const Text('signOff')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data = await FlUMeng.instance
                                  .setPageCollectionModeManual();
                              text = 'setPageCollectionModeManual  $data';
                              setState(() {});
                            },
                            child: const Text('setPageCollectionModeManual')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data = await FlUMeng.instance
                                  .onPageStart('pageStart');
                              text = 'onPageStart  $data';
                              setState(() {});
                            },
                            child: const Text('onPageStart')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data =
                                  await FlUMeng.instance.onPageEnd('pageEnd');
                              text = 'onPageEnd  $data';
                              setState(() {});
                            },
                            child: const Text('onPageEnd')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data = await FlUMeng.instance
                                  .setPageCollectionModeAuto();
                              text = 'setPageCollectionModeAuto  $data';
                              setState(() {});
                            },
                            child: const Text('setPageCollectionModeAuto')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data = await FlUMeng.instance.onEvent(
                                  'test', <String, String>{'test': 'test'});
                              text = 'onEvent  $data';
                              setState(() {});
                            },
                            child: const Text('onEvent')),
                      ]),
                  const Padding(
                      padding: EdgeInsets.all(15), child: Text('仅支持 Android')),
                  Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () async {
                              final bool data =
                                  await FlUMeng.instance.setLogEnabled(true);
                              text = 'logEnabled  $data';
                              setState(() {});
                            },
                            child: const Text('logEnabled')),
                        ElevatedButton(
                            onPressed: () async {
                              final bool data =
                                  await FlUMeng.instance.reportError('error');
                              text = 'reportError  $data';
                              setState(() {});
                            },
                            child: const Text('reportError')),
                      ])
                ])));
  }
}
