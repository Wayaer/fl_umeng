# 友盟统计 for Flutter

- 友盟APM 性能监测 如需要直接使用[fl_umeng_apm](https://pub.dev/packages/fl_umeng_apm)
- 友盟超链 [fl_umeng_link](https://pub.dev/packages/fl_umeng_link)
- 以上均基于 `fl_umeng` 必须初始化友盟`FlUMeng().init()`

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

- 全部方法参考 [example](https://github.com/Wayaer/fl_umeng/blob/main/fl_umeng/example/lib/main.dart)

- 注册友盟

```dart

Future<void> init() async {
  /// 注册友盟 统计 性能检测 
  final bool? data = await FlUMeng().init(
      androidAppKey: '5f8fe2abfac90f1c19a8642e',
      iosAppKey: '5f8fe4d4c1122b44acfc7aa7',
      channel: 'channel');
  print('UMeng 初始化成功 = $data');
}

```

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

  /// 设置是否自动采集；
  FlUMeng().setPageCollectionMode();

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
  FlUMeng().reportError();
}
```