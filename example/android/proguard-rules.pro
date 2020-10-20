
# 友盟
-keep class com.umeng.** {*;}

-keep class com.uc.** {*;}

-keep class members* {
   public <init> (org.json.JSONObject);
}
-keep class members enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class com.zui.** {*;}
-keep class com.miui.** {*;}
-keep class com.heytap.** {*;}
-keep class a.** {*;}
-keep class com.vivo.** {*;}

-keep class com.umeng.umcrash.UMCrash { *; }

-keep class com.uc.crashsdk.** { *; }
-keep interface com.uc.crashsdk.** { *; }

-keep public class com.umeng.example.R$*{
public static final int *;
}