package fl.umeng

import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel


class UmengPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(plugin: FlutterPluginBinding) {
        channel = MethodChannel(plugin.binaryMessenger, "UMeng")
        val context = plugin.applicationContext
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> {
                    val androidAppKey = call.argument<String>("appKey")
                    val channel = call.argument<String>("channel")
                    UMConfigure.init(context, androidAppKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null)
                    result.success(true)
                }
                "onEvent" -> {
                    val event = call.argument<String>("event")
                    val map = call.argument<Map<String, *>>("properties")
                    MobclickAgent.onEventObject(context, event, map)
                    result.success(true)
                }
                "setLogEnabled" -> {
                    val logEnabled = call.argument<Boolean>("logEnabled")
                    if (logEnabled != null) {
                        UMConfigure.setLogEnabled(logEnabled)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
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
                    MobclickAgent.onPageStart(call.argument("pageName"))
                    result.success(true)
                }
                "onPageEnd" -> {
                    MobclickAgent.onPageEnd(call.argument("pageName"))
                    result.success(true)
                }
                "reportError" -> {
                    MobclickAgent.reportError(context, call.argument<String>("error"))
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