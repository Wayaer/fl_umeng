import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('UMeng');

class UMeng {
  static Future<void> init({String androidAppKey, String iosAppKey, String channel}) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>(
        'init', <String, String>{'androidAppKey': androidAppKey, 'iosAppKey': iosAppKey, 'channel': channel});
  }

  /// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
  static Future<void> onEvent(String event, Map<String, dynamic> properties) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('onEvent', <String, dynamic>{'event': event, 'properties': properties});
  }

  /// 设置用户账号
  static Future<void> onProfileSignIn(String userID) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('onProfileSignIn', <String, String>{'userID': userID});
  }

  /// 取消用户账号
  static Future<void> onProfileSignOff() async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('onProfileSignOff');
  }

  /// 如果需要使用页面统计，则先打开该设置
  static Future<void> setPageCollectionModeManual() async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('setPageCollectionModeManual');
  }

  /// 进入页面统计
  static Future<void> onPageStart(String pageName) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('onPageStart', <String, String>{'pageName': pageName});
  }

  /// 离开页面统计
  static Future<void> onPageEnd(String pageName) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('onPageEnd', <String, String>{'pageName': pageName});
  }

  /// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
  static Future<void> setPageCollectionModeAuto() async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('setPageCollectionModeAuto');
  }

  /// 错误发送
  static Future<void> reportError(String error) async {
    if (_supportPlatform()) return;
    _channel.invokeMethod<dynamic>('reportError', <String, String>{'error': error});
  }
}

bool _supportPlatform() {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    print('flutter_umeng  is not support ${Platform.operatingSystem}');
    return true;
  }
  return false;
}
