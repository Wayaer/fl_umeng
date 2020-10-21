import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('UMeng');

///初始化
Future<void> initUM({String androidAppKey, String iosAppKey, String channel}) async {
  if (_supportPlatform()) return;
  if (Platform.isAndroid && androidAppKey == null) return;
  if (Platform.isIOS && iosAppKey == null) return;
  _channel.invokeMethod<dynamic>(
      'init', <String, String>{'androidAppKey': androidAppKey, 'iosAppKey': iosAppKey, 'channel': channel});
}

///是否开启日志
Future<void> setLogEnabledUM(bool logEnabled) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('setLogEnabled', <String, bool>{'logEnabled': logEnabled});
}

/// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
Future<void> onEventUM(String event, Map<String, dynamic> properties) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('onEvent', <String, dynamic>{'event': event, 'properties': properties});
}

/// 设置用户账号
Future<void> onProfileSignInUM(String userID) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('onProfileSignIn', <String, String>{'userID': userID});
}

/// 取消用户账号
Future<void> onProfileSignOffUM() async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('onProfileSignOff');
}

/// 如果需要使用页面统计，则先打开该设置
Future<void> setPageCollectionModeManual() async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('setPageCollectionModeManual');
}

/// 进入页面统计
Future<void> onPageStartUM(String pageName) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('onPageStart', <String, String>{'pageName': pageName});
}

/// 离开页面统计
Future<void> onPageEndUM(String pageName) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('onPageEnd', <String, String>{'pageName': pageName});
}

/// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
Future<void> setPageCollectionModeAutoUM() async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('setPageCollectionModeAuto');
}

/// 错误发送
Future<void> reportErrorUM(String error) async {
  if (_supportPlatform()) return;
  _channel.invokeMethod<dynamic>('reportError', <String, String>{'error': error});
}

bool _supportPlatform() {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    print('fl_umeng is not support ${Platform.operatingSystem}');
    return true;
  }
  return false;
}
