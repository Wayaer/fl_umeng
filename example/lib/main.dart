import 'package:flutter/material.dart';
import 'package:fl_umeng/fl_umeng.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// 注册友盟
  initWithUM(
      androidAppKey: '5f8fe2abfac90f1c19a8642e',
      iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
      channel: 'channel');

  /// 是否开启log
  setUMLogEnabled(true);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMeng example',
      home: HomePage()));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('UMeng example')),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    signInWithUM('userId');
                  },
                  child: const Text('设置用户账号')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    signOffWithUM();
                  },
                  child: const Text('取消用户账号')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    setPageCollectionModeManualWithUM();
                  },
                  child: const Text('开启页面统计')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    onPageStartWithUM('pageStart');
                  },
                  child: const Text('进入页面统计')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    onPageEndWithUM('pageEnd');
                  },
                  child: const Text('离开页面统计')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    setPageCollectionModeAutoWithUM();
                  },
                  child: const Text('关闭页面统计')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    onEventWithUM('test', <String, dynamic>{'test': 'test'});
                  },
                  child: const Text('发送自定义事件')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    reportErrorWithUM('error');
                  },
                  child: const Text('错误发送')),
              const SizedBox(height: 10),
            ])));
  }
}
