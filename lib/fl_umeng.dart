import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('UMeng');

/// 初始化
Future<bool?> initWithUM(
    {required String androidAppKey,
    required String iosAppKey,
    String channel = ''}) async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>('init', <String, String?>{
    'appKey': Platform.isAndroid ? androidAppKey : iosAppKey,
    'channel': channel
  });
}

/// 设置用户账号
/// provider 账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节
Future<bool?> signInWithUM(String userID, {String? provider}) async {
  if (_supportPlatform()) return false;
  final Map<String, String> map = <String, String>{'userID': userID};
  if (provider != null) map['provider'] = provider;
  return await _channel.invokeMethod<bool?>('onProfileSignIn', map);
}

/// 取消用户账号
Future<bool?> signOffWithUM() async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>('onProfileSignOff');
}

/// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
Future<bool?> onEventWithUM(
    String event, Map<String, dynamic> properties) async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>(
      'onEvent', <String, dynamic>{'event': event, 'properties': properties});
}

/// 如果需要使用页面统计，则先打开该设置
Future<bool?> setPageCollectionModeManualWithUM() async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>('setPageCollectionModeManual');
}

/// 进入页面统计
Future<bool?> onPageStartWithUM(String pageName) async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>(
      'onPageStart', <String, String>{'pageName': pageName});
}

/// 离开页面统计
Future<bool?> onPageEndWithUM(String pageName) async {
  if (_supportPlatform()) return false;
  return await _channel
      .invokeMethod<bool?>('onPageEnd', <String, String>{'pageName': pageName});
}

/// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
Future<bool?> setPageCollectionModeAutoWithUM() async {
  if (_supportPlatform()) return false;
  return await _channel.invokeMethod<bool?>('setPageCollectionModeAuto');
}

/// 是否开启日志
/// 仅支持android
Future<bool?> setUMLogEnabled(bool logEnabled) async {
  if (!Platform.isAndroid) return false;
  return await _channel.invokeMethod<bool?>(
      'setLogEnabled', <String, bool>{'logEnabled': logEnabled});
}

/// 错误上报
/// 仅支持android
Future<bool?> reportErrorWithUM(Map<String, String> error) async {
  if (!Platform.isAndroid) return false;
  return await _channel.invokeMethod<bool?>('reportError', error);
}

bool _supportPlatform() {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    print('fl_umeng is not support ${Platform.operatingSystem}');
    return true;
  }
  return false;
}
