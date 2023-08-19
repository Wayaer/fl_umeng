# fl_umeng_apm

- 基于 fl_umeng 必须初始化友盟 `FlUMeng().init()`

## 开始使用

- 注册友盟

```dart

Future<void> initState() async {
  /// 注册友盟性能监测
  final bool? data = await FlUMengAPM().init();

  /// 初始化APM后再 初始化UMeng
  print('UMeng 初始化成功 = $data');
}

```

- 设置版本号

```dart

void fun() async {
  /// 设置版本号
  final bool data =
  await FlUMengAPM().setAppVersion('1.0.0', '1.0.1', '20');
  print('setAppVersion  $data');
}
```