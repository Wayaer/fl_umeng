# 友盟统计 for Flutter

- 3.0.0 更新
- 移除APM 性能监测 如需要直接使用[fl_umeng_apm](https://pub.dev/packages/fl_umeng_apm)
- 新增 友盟超链 [fl_umeng_link](https://pub.dev/packages/fl_umeng_link)
- 以上均基于 fl_umeng 必须初始化友盟`FlUMeng().init()`

## android 配置 `/android/app/build.gradle/`

```groovy
android {
    buildTypes {
        release {
            // 添加混淆配置
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'consumer-rules.pro'
        }
        debug {
            // 添加混淆配置
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'consumer-rules.pro'
        }
    }
}
```

## 开始使用

- 注册友盟

```dart

Future<void> initState() async {
  /// 务必先预初始化 随后调用自己的 用户授权协议 之后再进行正常初始化
  final bool? data = await FlUMeng().init(
      preInit: true,
      androidAppKey: '5f8fe2abfac90f1c19a8642e',
      iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
      channel: 'channel');

  /// 注册友盟 统计 性能检测
  final bool? data = await FlUMeng().init(
      androidAppKey: '5f8fe2abfac90f1c19a8642e',
      iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
      channel: 'channel');
  print('UMeng 初始化成功 = $data');
}

```

- 设置账号

```dart

void fun() {
  /// 是否开启log 仅支持 Android
  FlUMeng().setLogEnabled(true);

  /// 设置用户账号
  FlUMeng().signIn('userID');

  /// 取消用户账号
  FlUMeng().signOff();
}
```

- 发送自定义事件

```dart
   /// 发送自定义事件（目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组）
void fun() {
  FlUMeng().onEvent();
}
```

- 使用页面统计

```dart
void fun() {
  /// 如果需要使用页面统计，则先打开该设置
  FlUMeng().setPageCollectionModeManual();

  /// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
  FlUMeng().setPageCollectionModeAuto();

  /// 进入页面统计 
  FlUMeng().onPageStart();

  /// 离开页面统计
  FlUMeng().onPageEnd();
}
```

- 错误发送

```dart
void fun() {
  /// 错误发送  仅支持 Android
  FlUMeng().report Error();
}
```

## android 如遇到 Duplicate class com.google.common.util.concurrent.ListenableFuture的错误

```shell script
* What went wrong:
Execution failed for task ':app:checkDebugDuplicateClasses'.
> 1 exception was raised by workers:
  java.lang.RuntimeException: Duplicate class com.google.common.util.concurrent.ListenableFuture found in modules jetified-guava-20.0.jar (com.google.guava:guava:20.0) and jetified-listenablefuture-1.0.jar (com.google.guava:listenablefuture:1.0)

  Go to the documentation to learn how to <a href="d.android.com/r/tools/classpath-sync-errors">Fix dependency resolution errors</a>.
```

android/app/build.gradle 添加以下代码

```groovy

configurations {
    all*.exclude group: 'com.google.guava', module: 'listenablefuture'
}

```
