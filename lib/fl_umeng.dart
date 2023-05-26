import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('UMeng');

class FlUMeng {
  factory FlUMeng() => _singleton ??= FlUMeng._();

  FlUMeng._();

  static FlUMeng? _singleton;
  bool _isInit = false;

  bool get isInit => _isInit;

  /// 初始化
  /// [preInit] 是否预加载 仅支持android
  Future<bool> init(
      {required String androidAppKey,
      required String iosAppKey,
      String channel = ''}) async {
    if (!_supportPlatform) return false;
    final bool? state = await _channel.invokeMethod<bool?>(
        'init', <String, dynamic>{
      'appKey': _isAndroid ? androidAppKey : iosAppKey,
      'channel': channel
    });
    _isInit = state ?? false;
    return state ?? false;
  }

  /// 获取zid 和 umid
  Future<UMengID?> getUMId() async {
    if (!_supportPlatform) return null;
    final Map<dynamic, dynamic>? map =
        await _channel.invokeMethod<Map<dynamic, dynamic>?>('getUMId');
    return UMengID(map?['umId'] as String?, map?['umzId'] as String?);
  }

  Future<UMengDeviceInfo?> getDeviceInfo() async {
    if (!_supportPlatform) return null;
    final Map<dynamic, dynamic>? map =
        await _channel.invokeMethod<Map<dynamic, dynamic>?>('getDeviceInfo');
    if (_isAndroid && map != null) {
      return DeviceAndroidInfo.formMap(map);
    } else if (_isIOS && map != null) {
      return DeviceIOSInfo(
          map["isJailbroken"], map["isPirated"], map["isProxy"]);
    }
    return null;
  }

  /// 设置是否对日志信息进行加密, 默认NO
  Future<bool> setEncryptEnabled(bool enabled) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod<bool?>('setEncryptEnabled', enabled);
    return state ?? false;
  }

  /// 获取集成测试信息的接口
  /// android  "$deviceId"
  /// ios  "$deviceId"
  Future<String?> getTestDeviceInfo() async {
    if (!_supportPlatform) return null;
    return await _channel.invokeMethod<String?>('getTestDeviceInfo');
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
}

class UMengDeviceInfo {}

class DeviceAndroidInfo extends UMengDeviceInfo {
  DeviceAndroidInfo.formMap(Map<dynamic, dynamic> map)
      : deviceId = map['deviceId'] as String?,
        mac = map['mac'] as String?,
        androidId = map['androidId'] as String?,
        oaId = map['oaId'] as String?,
        appHashKey = map['appHashKey'] as String?,
        appMD5Signature = map['appMD5Signature'] as String?,
        appName = map['appName'] as String?,
        appSHA1Key = map['appSHA1Key'] as String?,
        idfa = map['idfa'] as String?,
        imei = map['imei'] as String?,
        imeiNew = map['imeiNew'] as String?,
        imis = map['imis'] as String?,
        mccmnc = map['mccmnc'] as String?,
        meId = map['meId'] as String?,
        secondSimIMEi = map['secondSimIMEi'] as String?,
        simICCID = map['simICCID'] as String?,
        serial = map['serial'] as String?;

  String? deviceId;
  String? mac;
  String? androidId;
  String? oaId;
  String? appHashKey;
  String? appMD5Signature;
  String? appName;
  String? appSHA1Key;
  String? idfa;
  String? imei;
  String? imeiNew;
  String? imis;
  String? mccmnc;
  String? meId;
  String? secondSimIMEi;
  String? simICCID;
  String? serial;

  Map<String, dynamic> toMap() => {
        'deviceId': deviceId,
        'mac': mac,
        'androidId': androidId,
        'oaId': oaId,
        'appHashKey': appHashKey,
        'appMD5Signature': appMD5Signature,
        'appName': appName,
        'appSHA1Key': appSHA1Key,
        'idfa': idfa,
        'imei': imei,
        'imeiNew': imeiNew,
        'imis': imis,
        'mccmnc': mccmnc,
        'meId': meId,
        'secondSimIMEi': secondSimIMEi,
        'simICCID': simICCID,
        'serial': serial,
      };
}

class DeviceIOSInfo extends UMengDeviceInfo {
  DeviceIOSInfo(this.isJailbroken, this.isPirated, this.isProxy);

  /// 判断设备是否越狱，依据是否存在apt和Cydia.app
  bool? isJailbroken;

  /// 判断App是否被破解
  bool? isPirated;

  ///
  bool? isProxy;

  Map<String, dynamic> toMap() => {
        'isJailbroken': isJailbroken,
        'isPirated': isPirated,
        'isProxy': isProxy,
      };
}

class UMengID {
  UMengID(this.umid, this.umzid);

  String? umid;
  String? umzid;
}

bool get _supportPlatform {
  if (!kIsWeb && (_isAndroid || _isIOS)) return true;
  debugPrint('Not support platform for $defaultTargetPlatform');
  return false;
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
