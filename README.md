# flutter_umeng
### 友盟插件

##  android 添加配置文件

AndroidManifest.xml 添加以下代码
```
<manifest>

    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
    <uses-permission android:name="android.permission.INTERNET"/>

 <application
     ...
       <meta-data
          android:name="UMENG_APPKEY"
          android:value="your app key"/>
       <meta-data
          android:name="UMENG_CHANNEL"
          android:value="your app CHANNEL"/>
     ...
  </application>
</manifest>
```


## 如遇到 Duplicate class com.google.common.util.concurrent.ListenableFuture的错误

```
* What went wrong:
Execution failed for task ':app:checkDebugDuplicateClasses'.
> 1 exception was raised by workers:
  java.lang.RuntimeException: Duplicate class com.google.common.util.concurrent.ListenableFuture found in modules jetified-guava-20.0.jar (com.google.guava:guava:20.0) and jetified-listenablefuture-1.0.jar (com.google.guava:listenablefuture:1.0)

  Go to the documentation to learn how to <a href="d.android.com/r/tools/classpath-sync-errors">Fix dependency resolution errors</a>.
```

android/app/build.gradle 添加以下代码

```

configurations {
    all*.exclude group: 'com.google.guava', module: 'listenablefuture'
}

```