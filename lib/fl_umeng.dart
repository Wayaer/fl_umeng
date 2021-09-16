import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('UMeng');

class FlUMeng {
  factory FlUMeng() => _singleton ??= FlUMeng._();

  FlUMeng._();

  static FlUMeng? _singleton;

  /// 初始化
  /// [preInit] 是否预加载 仅支持android
  Future<bool> init(
      {required String androidAppKey,
      required String iosAppKey,
      bool preInit = false,
      String channel = ''}) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('init', <String, dynamic>{
      'appKey': _isAndroid ? androidAppKey : iosAppKey,
      'channel': channel,
      'preInit': preInit
    });
    return state ?? false;
  }

  /// android 退出app 时 保存统计数据
  Future<bool> onKillProcess(String key, String type) async {
    if (!_isAndroid) return false;
    final bool? state = await _channel.invokeMethod<bool?>('onKillProcess');
    return state ?? false;
  }

  /// 设置用户账号
  /// provider 账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节
  Future<bool> signIn(String userID, {String? provider}) async {
    if (!_supportPlatform) return false;
    final Map<String, String> map = <String, String>{'userID': userID};
    if (provider != null) map['provider'] = provider;
    final bool? state =
        await _channel.invokeMethod<bool?>('onProfileSignIn', map);
    return state ?? false;
  }

  /// 取消用户账号
  Future<bool> signOff() async {
    if (!_supportPlatform) return false;
    final bool? state = await _channel.invokeMethod<bool?>('onProfileSignOff');
    return state ?? false;
  }

  /// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
  Future<bool> onEvent(String event, Map<String, dynamic> properties) async {
    if (!_supportPlatform) return false;
    final bool? state = await _channel.invokeMethod<bool?>(
        'onEvent', <String, dynamic>{'event': event, 'properties': properties});
    return state ?? false;
  }

  /// 如果需要使用页面统计，则先打开该设置
  Future<bool> setPageCollectionModeManual() async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setPageCollectionModeManual');
    return state ?? false;
  }

  /// 进入页面统计
  Future<bool> onPageStart(String pageName) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('onPageStart', pageName);
    return state ?? false;
  }

  /// 离开页面统计
  Future<bool> onPageEnd(String pageName) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('onPageEnd', pageName);
    return state ?? false;
  }

  /// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
  Future<bool> setPageCollectionModeAuto() async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setPageCollectionModeAuto');
    return state ?? false;
  }

  /// 是否开启日志
  Future<bool> setLogEnabled(bool enabled) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setLogEnabled', enabled);
    return state ?? false;
  }

  /// 错误上报
  /// 仅支持android
  Future<bool> reportError(String error) async {
    if (!_isAndroid) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('reportError', error);
    return state ?? false;
  }

  /// 设置app 版本
  /// [version] 1.0.01
  /// [buildId] 1
  Future<bool> setAppVersionWithCrash(
      String version, String subVersion, String buildId) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setAppVersion', <String, dynamic>{
      'version': version,
      'subVersion': subVersion,
      'buildId': buildId,
    });
    return state ?? false;
  }

  /// 初始化 Crash
  Future<bool> setConfigWithCrash({CrashMode? crashMode}) async {
    if (!_supportPlatform) return false;
    crashMode ??= CrashMode();
    final bool? state =
        await _channel.invokeMethod<bool?>('setCrashConfig', crashMode.toMap());
    return state ?? false;
  }

  /// 设置 Crash debug 模式  only Android
  Future<bool> setDebugWithCrash(bool isDebug) async {
    if (!_isAndroid) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setUMCrashDebug', isDebug);
    return state ?? false;
  }

  /// 自定义log only Android
  Future<bool> setCustomLogWithCrash(String key, String type) async {
    if (!_isAndroid) return false;
    final bool? state = await _channel.invokeMethod<bool?>(
        'customLog', <String, dynamic>{'key': key, 'type': type});
    return state ?? false;
  }
}

class CrashMode {
  CrashMode({
    this.enableUnExp = false,
    this.enableLaunch = true,
    this.enableMEM = true,
    this.enableJava = true,
    this.enableNative = true,
    this.enablePa = true,
    this.enableAnr = true,
    this.enableCrashAndBlock = true,
    this.enableOOM = true,
  });

  /// Android and IOS
  /// 一级开关优先级高于二级开关，如果一级和二级同时设置则以一级为准，目前仅崩溃类型有二级开关。
  /// 用于关闭启动捕获，默认为true可设置为false进行关闭 一级
  late bool enableLaunch;

  /// 用于关闭内存占用捕获，默认为true可设置为false进行关闭 一级
  late bool enableMEM;

  /// Android only
  ///
  /// 用于关闭java crash捕获，默认为true可设置为false进行关闭 二级
  late bool enableJava;

  /// 用于关闭native crash捕获，默认为true可设置为false进行关闭 二级
  late bool enableNative;

  /// 用于关闭java和native crash捕获，默认为false可设置为true进行关闭 一级
  late bool enableUnExp;

  /// 用于关闭ANR捕获，默认为true可设置为false进行关闭 一级
  late bool enableAnr;

  /// 用于关闭卡顿捕获，默认为true可设置为false进行关闭 一级
  late bool enablePa;

  ///  IOS only
  ///
  late bool enableCrashAndBlock;
  late bool enableOOM;

  Map<String, bool> toMap() => <String, bool>{
        'enableLaunch': enableLaunch,
        'enableMEM': enableMEM,
        'enableJava': enableJava,
        'enableNative': enableNative,
        'enableUnExp': enableUnExp,
        'enableAnr': enableAnr,
        'enablePa': enablePa,
        'enableCrashAndBlock': enableCrashAndBlock,
        'enableOOM': enableOOM,
      };
}

bool get _supportPlatform {
  if (!kIsWeb && (_isAndroid || _isIOS)) return true;
  debugPrint('Not support platform for $defaultTargetPlatform');
  return false;
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
