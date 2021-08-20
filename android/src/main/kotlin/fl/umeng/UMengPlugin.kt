package fl.umeng

import android.os.Bundle
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import com.umeng.umcrash.UMCrash
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel


class UMengPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(plugin: FlutterPluginBinding) {
        channel = MethodChannel(plugin.binaryMessenger, "UMeng")
        val context = plugin.applicationContext
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> {
                    val key = call.argument<String>("appKey")
                    val channel = call.argument<String>("channel")
                    val preInit = call.argument<Boolean>("preInit")
                    if (preInit == true) {
                        UMConfigure.preInit(context, key, channel)
                    } else {
                        UMConfigure.init(context, key, channel, UMConfigure.DEVICE_TYPE_PHONE, null)
                    }
                    result.success(true)
                }
                "setLogEnabled" -> {
                    UMConfigure.setLogEnabled(call.arguments as Boolean)
                    result.success(true)
                }
                "onEvent" -> {
                    val event = call.argument<String>("event")
                    val map = call.argument<Map<String, *>>("properties")
                    MobclickAgent.onEventObject(context, event, map)
                    result.success(true)
                }
                "onProfileSignIn" -> {
                    val provider = call.argument<String?>("provider")
                    val userID = call.argument<String>("userID")
                    if (provider != null) {
                        MobclickAgent.onProfileSignIn(userID, provider)
                    } else {
                        MobclickAgent.onProfileSignIn(userID)
                    }
                    result.success(true)
                }
                "onProfileSignOff" -> {
                    MobclickAgent.onProfileSignOff()
                    result.success(true)
                }
                "setPageCollectionModeAuto" -> {
                    MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_AUTO)
                    result.success(true)
                }
                "setPageCollectionModeManual" -> {
                    MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL)
                    result.success(true)
                }
                "onPageStart" -> {
                    MobclickAgent.onPageStart(call.arguments as String)
                    result.success(true)
                }
                "onPageEnd" -> {
                    MobclickAgent.onPageEnd(call.arguments as String)
                    result.success(true)
                }
                "reportError" -> {
                    MobclickAgent.reportError(context, call.arguments as String)
                    result.success(true)
                }
                "onKillProcess" -> {
                    MobclickAgent.onKillProcess(context)
                    result.success(true)
                }
                "setAppVersion" -> {
                    UMCrash.setAppVersion(
                        call.argument("version"),
                        call.argument("subVersion"),
                        call.argument("buildId")
                    )
                    result.success(true)
                }
                "setCrashConfig" -> {
                    val bundle = Bundle()
                    bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_JAVA, call.argument<Boolean>("enableJava") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_NATIVE, call.argument<Boolean>("enableNative") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_UNEXP, call.argument<Boolean>("enableUnExp") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_ANR, call.argument<Boolean>("enableAnr") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_PA, call.argument<Boolean>("enablePa") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_LAUNCH, call.argument<Boolean>("enableLaunch") == true)
                    bundle.putBoolean(UMCrash.KEY_ENABLE_MEM, call.argument<Boolean>("enableMEM") == true)
                    UMCrash.initConfig(bundle)
                    result.success(true)
                }
                "setUMCrashDebug" -> {
                    UMCrash.setDebug(call.arguments as Boolean)
                    result.success(true)
                }
                "customLog" -> {
                    UMCrash.generateCustomLog(call.argument<String>("key"), "type")
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}