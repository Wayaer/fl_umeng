-keep public class **.R$*{
   public static final int *;
}

-keep class com.umeng.** {*;}

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}


-keep class com.uc.** { *; }

-keep class com.efs.** { *; }
