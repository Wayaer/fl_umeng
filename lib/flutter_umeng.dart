import 'dart:async';

import 'package:flutter/services.dart';

class UMeng {
  static const MethodChannel _channel = const MethodChannel('umeng_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> initCommon(String androidAppkey, String iosAppkey, String channel) async {
    List<dynamic> params = [androidAppkey, iosAppkey, channel];
    final dynamic result = await _channel.invokeMethod('initCommon', params);
    return result;
  }

  /// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
  static void onEvent(String event, Map<String, dynamic> properties) {
    List<dynamic> args = [event, properties];
    _channel.invokeMethod('onEvent', args);
  }

  /// 设置用户账号
  static void onProfileSignIn(String userID) {
    List<dynamic> args = [userID];
    _channel.invokeMethod('onProfileSignIn', args);
  }

  /// 取消用户账号
  static void onProfileSignOff() {
    _channel.invokeMethod('onProfileSignOff');
  }

  /// 如果需要使用页面统计，则先打开该设置
  static void setPageCollectionModeManual() {
    _channel.invokeMethod('setPageCollectionModeManual');
  }

  /// 进入页面统计
  static void onPageStart(String viewName) {
    List<dynamic> args = [viewName];
    _channel.invokeMethod('onPageStart', args);
  }

  /// 离开页面统计
  static void onPageEnd(String viewName) {
    List<dynamic> args = [viewName];
    _channel.invokeMethod('onPageEnd', args);
  }

  /// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
  static void setPageCollectionModeAuto() {
    _channel.invokeMethod('setPageCollectionModeAuto');
  }

  /// 错误发送
  static void reportError(String error) {
    List<dynamic> args = [error];
    _channel.invokeMethod('reportError', args);
  }
}
