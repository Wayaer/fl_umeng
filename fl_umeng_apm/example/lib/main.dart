import 'package:fl_umeng_apm/fl_umeng_apm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'UMeng APM Example',
      home: Scaffold(
          appBar: AppBar(title: const Text('UMeng APM Example')),
          body: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const _HomePage()))));
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  String text = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  /// 注册友盟性能检测
  Future<void> init() async {
    /// 注册友盟
    debugPrint('注册友盟');
    final bool data = await FlUMeng().init(
        androidAppKey: '5f8fe2abfac90f1c19a8642e',
        iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
        channel: 'channel');
    debugPrint('Umeng 初始化成功 = $data');
    await FlUMeng().setLogEnabled(true);

    debugPrint('注册友盟性能检测');
    final bool value = await FlUMengAPM().init();
    debugPrint('Umeng apm 初始化成功 = $value');
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
      ElevatedButton(
          onPressed: () async {
            final bool data =
                await FlUMengAPM().setAppVersion('1.0.0', '1', '20');
            text = 'setAppVersion  $data';
            setState(() {});
          },
          child: const Text('setAppVersion')),
      if (defaultTargetPlatform == TargetPlatform.android) ...[
        const Padding(padding: EdgeInsets.all(5), child: Text('仅支持 Android')),
        Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    final bool data =
                        await FlUMengAPM().setCustomLog('key', 'type');
                    text = 'setCustomLog  $data';
                    setState(() {});
                  },
                  child: const Text('setCustomLog')),
              ElevatedButton(
                  onPressed: () async {
                    final String? data = await FlUMengAPM().getUMAPMFlag();
                    text = 'getUMAPMFlag  $data';
                    setState(() {});
                  },
                  child: const Text('getUMAPMFlag')),
            ])
      ]
    ]);
  }
}
