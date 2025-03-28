import 'dart:async';

import 'package:fl_umeng_link/fl_umeng_link.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMeng Link Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('UMeng Link Example')),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const _HomePage(),
        ),
      ),
    ),
  );
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

  /// 注册友盟
  Future<void> init() async {
    /// 注册友盟
    debugPrint('注册友盟');
    final bool data = await FlUMeng().init(
      androidAppKey: '6248116b6adb343c47eff1a4',
      iosAppKey: '6203785ce014255fcb18fcad',
      channel: 'channel',
    );
    debugPrint('Umeng 初始化成功 = $data');
    await FlUMeng().setLogEnabled(true);

    debugPrint('监听友盟超链安装参数回调');
    final value = await FlUMengLink().getInstallParams();
    debugPrint('getInstallParams 初始化成功 = $value');

    final handler = FlUMengLink().addMethodCallHandler(
      onLink: (UMLinkResult? result) {
        text = 'onLink\n${result?.toMap()}';
        debugPrint(text);
        setState(() {});
      },
      onInstall: (UMLinkResult? result) {
        text = 'onInstall\n${result?.toMap()}';
        debugPrint(text);
        setState(() {});
      },
      onError: (String? error) {
        text = 'onError\n$error';
        debugPrint(text);
        setState(() {});
      },
    );
    debugPrint('addMethodCallHandler 初始化成功 = $handler');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 140,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Text(text, textAlign: TextAlign.center),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await FlUMengLink().getLaunchParams();
            text = 'getLaunchParams  ${result?.toMap()}';
            setState(() {});
          },
          child: const Text('getLaunchParams'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await FlUMengLink().getInstallParams();
            text = 'getInstallParams $result';
            setState(() {});
          },
          child: const Text('getInstallParams'),
        ),
      ],
    );
  }
}
