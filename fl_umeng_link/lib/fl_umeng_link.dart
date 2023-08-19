import 'package:fl_umeng/fl_umeng.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:fl_umeng/fl_umeng.dart';

/// 错误回调
typedef FlUMLinkHandlerError = void Function(String? error);

/// 安装或者link回调
typedef FlUMLinkHandlerLink = void Function(UMLinkResult? result);

class FlUMengLink {
  factory FlUMengLink() => _singleton ??= FlUMengLink._();

  FlUMengLink._();

  static FlUMengLink? _singleton;

  static const MethodChannel _channel = MethodChannel('UMeng.link');

  /// 获取A启动参数 link 和install
  Future<UMLinkResult?> getLaunchParams({bool clipBoardEnabled = true}) async {
    if (!_supportPlatform) return null;
    final Map<dynamic, dynamic>? data =
        await _channel.invokeMethod('getLaunchParams', clipBoardEnabled);
    return data == null ? null : UMLinkResult?.fromMap(data);
  }

  /// 安装后 获取的参数
  Future<bool> getInstallParams({bool clipBoardEnabled = true}) async {
    if (!_supportPlatform) return false;
    final bool? state =
        await _channel.invokeMethod('getInstallParams', clipBoardEnabled);
    return state ?? false;
  }

  /// 监听回调参数
  bool addMethodCallHandler({
    FlUMLinkHandlerError? onError,

    /// h5 热启动app
    FlUMLinkHandlerLink? onLink,

    /// h5 引导安装app 后启动app
    FlUMLinkHandlerLink? onInstall,
  }) {
    final isInit = FlUMeng().isInit;
    if (isInit) {
      _channel.setMethodCallHandler(null);
      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onLink':
            onLink?.call(UMLinkResult.fromMap(call.arguments));
            break;
          case 'onInstall':
            onInstall?.call(UMLinkResult.fromMap(call.arguments));
            break;
          case 'onError':
            onError?.call(call.arguments);
            break;
        }
      });
    }
    return isInit;
  }
}

/// 回调结果
class UMLinkResult {
  UMLinkResult.fromMap(Map<dynamic, dynamic> map)
      : installParams = map['installParams'] as Map<dynamic, dynamic>?,
        linkParams = map['linkParams'] as Map<dynamic, dynamic>?,
        path = map['path'] as String?,
        uri = map['uri'] as String?;

  /// link params
  /// ios 可能为空map
  Map<dynamic, dynamic>? linkParams;

  /// path link
  /// ios 可能为空字符串
  String? path;

  /// install params
  /// ios 可能为空map
  Map<dynamic, dynamic>? installParams;

  /// uri  onInstall
  /// ios 可能为空字符串
  String? uri;

  Map<String, dynamic> toMap() => {
        'path': path,
        'uri': uri,
        'linkParams': linkParams,
        'installParams': installParams
      };
}

bool get _supportPlatform {
  if (!kIsWeb && (_isAndroid || _isIOS)) return true;
  debugPrint('Not support platform for $defaultTargetPlatform');
  return false;
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
