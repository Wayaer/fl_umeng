import 'package:flutter/material.dart';
import 'package:fl_umeng/fl_umeng.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 注册友盟
  final bool? data = await initWithUM(
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
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
                          final bool data = await signInWithUM('userId');
                          text = 'signInWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('signOffWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data = await signOffWithUM();
                          text = 'signOffWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('signOffWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data =
                              await setPageCollectionModeManualWithUM();
                          text = 'setPageCollectionModeManualWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('setPageCollectionModeManualWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data =
                              await onPageStartWithUM('pageStart');
                          text = 'onPageStartWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('onPageStartWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data = await onPageEndWithUM('pageEnd');
                          text = 'onPageEndWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('onPageEndWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data =
                              await setPageCollectionModeAutoWithUM();
                          text = 'setPageCollectionModeAutoWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('setPageCollectionModeAutoWithUM')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data = await onEventWithUM(
                              'test', <String, String>{'test': 'test'});
                          text = 'onEventWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('onEventWithUM')),
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
                          final bool data = await setUMLogEnabled(true);
                          text = 'LogEnabled  $data';
                          setState(() {});
                        },
                        child: const Text('LogEnabled')),
                    ElevatedButton(
                        onPressed: () async {
                          final bool data = await reportErrorWithUM(
                              <String, String>{'error': 'error'});
                          text = 'reportErrorWithUM  $data';
                          setState(() {});
                        },
                        child: const Text('reportErrorWithUM')),
                  ])
            ])));
  }
}
