# fl_umeng
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
## android 混淆设置

如果您的应用使用了代码混淆，请添加如下配置，以避免【友盟+】SDK被错误混淆导致SDK不可用。

android/app 目录 添加
```
   proguard-rules.pro
```
并在【proguard-rules.pro】 添加以下混淆内容
```
-keep class com.umeng.** {*;}

-keep class com.uc.** {*;}

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class com.zui.** {*;}
-keep class com.miui.** {*;}
-keep class com.heytap.** {*;}
-keep class a.** {*;}
-keep class com.vivo.** {*;}
-keep class com.uc.crashsdk.** { *; }
-keep interface com.uc.crashsdk.** { *; }

-keep public class 您的应用包名.R$*{
public static final int *;
}
```

android/app/build.gradle
添加以下内容
```
   buildTypes {
        release {
            ...
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            ...
            }
        }
        debug {
            ...
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            ...
        }
    }
```


## android 如遇到 Duplicate class com.google.common.util.concurrent.ListenableFuture的错误

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