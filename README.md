# fl_umeng
### 友盟插件


## android 如遇到初始化失败的问题

如果您的应用使用了代码混淆，请添加如下配置，以避免【友盟+】SDK被错误混淆导致SDK不可用。

android/app 目录 添加
```
   proguard-rules.pro

```
并在【proguard-rules.pro】 添加以下混淆内容
```groovy
-keep public class 您的应用包名.R$*{
   public static final int *;
}
```

android/app/build.gradle
添加以下内容
```groovy
  
buildTypes {
        release {
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        debug {
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
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