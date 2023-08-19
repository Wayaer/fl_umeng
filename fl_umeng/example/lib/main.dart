import 'package:fl_umeng/fl_umeng.dart';
import 'package:flutter/foundation.dart';
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
    final bool data = await FlUMeng().init(
        androidAppKey: '5f8fe2abfac90f1c19a8642e',
        iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
        channel: 'channel');
    debugPrint('Umeng 初始化成功 = $data');
    await FlUMeng().setLogEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 140,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(6)),
          child: SingleChildScrollView(
              child: Text(text, textAlign: TextAlign.center))),
      Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().signIn('userId');
                  text = 'signIn  $data';
                  setState(() {});
                },
                child: const Text('signIn')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().signOff();
                  text = 'signOff  $data';
                  setState(() {});
                },
                child: const Text('signOff')),
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
                  final bool data = await FlUMeng()
                      .onEvent('test', <String, String>{'test': 'test'});
                  text = 'onEvent  $data';
                  setState(() {});
                },
                child: const Text('onEvent')),
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
                  final bool data = await FlUMeng().setPageCollectionModeAuto();
                  text = 'setPageCollectionModeAuto  $data';
                  setState(() {});
                },
                child: const Text('setPageCollectionModeAuto')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().setLogEnabled(true);
                  text = 'logEnabled  $data';
                  setState(() {});
                },
                child: const Text('logEnabled')),
            ElevatedButton(
                onPressed: () async {
                  final String? data = await FlUMeng().getTestDeviceInfo();
                  text = 'getTestDeviceInfo  $data';
                  setState(() {});
                },
                child: const Text('getTestDeviceInfo')),
            ElevatedButton(
                onPressed: () async {
                  final bool data = await FlUMeng().setEncryptEnabled(false);
                  text = 'setEncryptEnabled  $data';
                  setState(() {});
                },
                child: const Text('setEncryptEnabled')),
            ElevatedButton(
                onPressed: () async {
                  final UMengDeviceInfo? data = await FlUMeng().getDeviceInfo();
                  Map<String, dynamic> map = {};
                  if (defaultTargetPlatform == TargetPlatform.android) {
                    map = (data as DeviceAndroidInfo).toMap();
                  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                    map = (data as DeviceIOSInfo).toMap();
                  }
                  text = 'getDeviceInfo  $map';
                  setState(() {});
                },
                child: const Text('getDeviceInfo')),
            ElevatedButton(
                onPressed: () async {
                  final UMengID? data = await FlUMeng().getUMId();
                  text = 'getUMId  umid:${data?.umid} umzid:${data?.umzid}';
                  setState(() {});
                },
                child: const Text('getUMId')),
          ]),
      if (defaultTargetPlatform == TargetPlatform.android) ...[
        const Padding(padding: EdgeInsets.all(5), child: Text('仅支持 Android')),
        Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    final bool data = await FlUMeng().reportError('error');
                    text = 'reportError  $data';
                    setState(() {});
                  },
                  child: const Text('reportError')),
            ])
      ]
    ]);
  }
}
