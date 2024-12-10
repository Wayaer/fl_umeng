import 'package:fl_umeng/fl_umeng.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:fl_umeng/fl_umeng.dart';

class FlUMengAPM {
  factory FlUMengAPM() => _singleton ??= FlUMengAPM._();

  FlUMengAPM._();

  static FlUMengAPM? _singleton;

  final MethodChannel _channel = const MethodChannel('UMeng.apm');

  /// 初始化
  Future<bool> init([CrashMode crashMode = const CrashMode()]) async {
    if (!_checkUMeng || !_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('init', crashMode.toMap());
    return state ?? false;
  }

  /// 设置app 版本
  /// [version] 1.0.01
  /// [buildId] 1
  /// [subVersion] 1 仅支持android
  Future<bool> setAppVersion(
      String version, String subVersion, String buildId) async {
    if (!_checkUMeng || !_supportPlatform) return false;
    final bool? state = await _channel.invokeMethod<bool?>('setAppVersion',
        {'version': version, 'subVersion': subVersion, 'buildId': buildId});
    return state ?? false;
  }

  /// 获取 Andorid端的 UMAPMFlag
  Future<String?> getUMAPMFlag() async {
    if (!_checkUMeng || !_isAndroid) return null;
    return await _channel.invokeMethod<String?>('getUMAPMFlag');
  }

  /// 设置 Crash debug 模式  only Android
  Future<bool> setDebug(bool isDebug) async {
    if (!_checkUMeng || !_isAndroid) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setUMCrashDebug', isDebug);
    return state ?? false;
  }

  /// 自定义log only Android
  Future<bool> setCustomLog(String key, String type) async {
    if (!_checkUMeng || !_isAndroid) return false;
    final bool? state = await _channel
        .invokeMethod<bool?>('customLog', {'key': key, 'type': type});
    return state ?? false;
  }

  bool get _checkUMeng {
    if (!FlUMeng().isInit) assert(!FlUMeng().isInit, '友盟未初始化');
    return FlUMeng().isInit;
  }
}

class CrashMode {
  const CrashMode({
    this.enableUnExp = true,
    this.enableLaunch = true,
    this.enableMEM = true,
    this.enableJava = true,
    this.enableNative = true,
    this.enablePa = true,
    this.enableAnr = true,
    this.enableCrashAndBlock = true,
    this.enableOOM = true,
    this.networkEnable = true,
    this.enableNetworkForProtocol = true,
  });

  /// Android and IOS
  /// 一级开关优先级高于二级开关，如果一级和二级同时设置则以一级为准，目前仅崩溃类型有二级开关。
  /// 用于关闭启动捕获，默认为true可设置为false进行关闭 一级
  final bool enableLaunch;

  /// 用于关闭内存占用捕获，默认为true可设置为false进行关闭 一级
  final bool enableMEM;

  /// Android only
  ///
  /// 用于关闭java crash捕获，默认为true可设置为false进行关闭 二级
  final bool enableJava;

  /// 用于关闭native crash捕获，默认为true可设置为false进行关闭 二级
  final bool enableNative;

  /// 用于关闭java和native crash捕获，默认为false可设置为true进行关闭 一级
  final bool enableUnExp;

  /// 用于关闭ANR捕获，默认为true可设置为false进行关闭 一级
  final bool enableAnr;

  /// 用于关闭卡顿捕获，默认为true可设置为false进行关闭 一级
  final bool enablePa;

  ///  IOS only
  ///
  final bool enableCrashAndBlock;
  final bool enableOOM;
  final bool networkEnable;

  /// 集成NSURLProtocol和U-APM的网络模块注意事项
  /// 增加网络分析模块在iOS13及以下系统的单独开关，以避免在同时集成NSURLProtocol和U-APM的网络模块的本身冲突引起崩溃，特增加enableNetworkForProtocol函数。
  /// 官方文档 https://developer.umeng.com/docs/193624/detail/291394
  final bool enableNetworkForProtocol;

  Map<String, bool> toMap() => {
        'enableLaunch': enableLaunch,
        'enableMEM': enableMEM,
        'enableJava': enableJava,
        'enableNative': enableNative,
        'enableUnExp': enableUnExp,
        'enableAnr': enableAnr,
        'enablePa': enablePa,
        'enableCrashAndBlock': enableCrashAndBlock,
        'enableOOM': enableOOM,
        'networkEnable': networkEnable,
        'enableNetworkForProtocol': enableNetworkForProtocol,
      };
}

bool get _supportPlatform {
  if (!kIsWeb && (_isAndroid || _isIOS)) return true;
  debugPrint('Not support platform for $defaultTargetPlatform');
  return false;
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
