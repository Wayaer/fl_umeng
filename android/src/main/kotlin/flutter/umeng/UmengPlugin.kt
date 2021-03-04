package flutter.umeng

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
                    UMConfigure.init(context, androidAppKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);
                }
                "onEvent" -> {
                    val event = call.argument<String>("event")
                    val map = call.argument<Map<String, *>>("properties")
                    MobclickAgent.onEventObject(context, event, map)
                }
                "setLogEnabled" -> {
                    val logEnabled = call.argument<Boolean>("logEnabled")
                    if (logEnabled != null) UMConfigure.setLogEnabled(logEnabled)
                }
                "onProfileSignIn" -> MobclickAgent.onProfileSignIn(call.argument("userID"))
                "onProfileSignOff" -> MobclickAgent.onProfileSignOff()
                "setPageCollectionModeAuto" -> MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_AUTO)
                "setPageCollectionModeManual" -> MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL)
                "onPageStart" -> MobclickAgent.onPageStart(call.argument("pageName"))
                "onPageEnd" -> MobclickAgent.onPageEnd(call.argument("pageName"))
                "reportError" -> MobclickAgent.reportError(context, call.argument<String>("error"))
                else -> result.notImplemented()
            }

        }


    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}