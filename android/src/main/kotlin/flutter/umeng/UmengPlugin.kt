package flutter.umeng

import android.content.Context
import android.util.Log
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method

class UmengPlugin : FlutterPlugin, MethodCallHandler {
    private var context: Context? = null
    private var versionMatch = false

    override fun onAttachedToEngine(plugin: FlutterPluginBinding) {
        val channel = MethodChannel(plugin.binaryMessenger, "Umeng")
        channel.setMethodCallHandler(this)
        context = plugin.applicationContext
        try {
            val agent = Class.forName("com.umeng.analytics.MobclickAgent")
            val methods = agent.declaredMethods
            for (m in methods) {
                Log.e("UMLog", "Reflect:$m")
                if (m.name == "onEventObject") {
                    versionMatch = true
                    break
                }
            }
            if (!versionMatch) {
                Log.e("UMLog", "安卓SDK版本过低，建议升级至8以上")
                //return;
            } else {
                Log.e("UMLog", "安卓依赖版本检查成功")
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("UMLog", "SDK版本过低，请升级至8以上$e")
            return
        }
        val method: Method
        try {
            val config = Class.forName("com.umeng.commonsdk.UMConfigure")
            method = config.getDeclaredMethod("setWraperType", String::class.java, String::class.java)
            method.isAccessible = true
            method.invoke(null, "flutter", "1.0")
            Log.i("UMLog", "setWraperType:flutter1.0 success")
        } catch (e: NoSuchMethodException) {
            e.printStackTrace()
            Log.e("UMLog", "setWraperType:flutter1.0$e")
        } catch (e: InvocationTargetException) {
            e.printStackTrace()
            Log.e("UMLog", "setWraperType:flutter1.0$e")
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
            Log.e("UMLog", "setWraperType:flutter1.0$e")
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
            Log.e("UMLog", "setWraperType:flutter1.0$e")
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (!versionMatch) {
            Log.e("UMLog", "onMethodCall:" + call.method + ":安卓SDK版本过低，请升级至8以上")
        }
        try {
            when (call.method) {
                "init" -> initCommon(call)
                "onEvent" -> onEvent(call)
                "onProfileSignIn" -> MobclickAgent.onProfileSignIn(call.argument("userID"))
                "onProfileSignOff" -> MobclickAgent.onProfileSignOff()
                "setPageCollectionModeAuto" -> MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_AUTO)
                "setPageCollectionModeManual" -> MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL)
                "onPageStart" -> MobclickAgent.onPageStart(call.argument("pageName"))
                "onPageEnd" -> MobclickAgent.onPageEnd(call.argument("pageName"))
                "reportError" -> MobclickAgent.reportError(context, call.argument<String>("error"))
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
    private fun initCommon(call: MethodCall) {
        val androidAppKey = call.argument<String>("androidAppKey")
        val channel = call.argument<String>("channel")
        UMConfigure.init(context, androidAppKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);
    }

    private fun onEvent(call: MethodCall) {
        val event = call.argument<String>("event")
        val map = call.argument<Map<String, *>>("properties")
        MobclickAgent.onEventObject(context, event, map)
    }


}