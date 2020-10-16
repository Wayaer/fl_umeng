package flutter.umeng

import android.content.Context
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


class UmengPlugin : FlutterPlugin, MethodCallHandler {
    private var context: Context? = null
    private lateinit var channel: MethodChannel
    override fun onAttachedToEngine(plugin: FlutterPluginBinding) {
        channel = MethodChannel(plugin.binaryMessenger, "UMeng")
        channel.setMethodCallHandler(this)
        context = plugin.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> initCommon(call)
            "onEvent" -> onEvent(call)
            "setLogEnabled" -> setLogEnabled(call)
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

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setLogEnabled(call: MethodCall) {
        val logEnabled = call.argument<Boolean>("logEnabled")
        if (logEnabled != null) UMConfigure.setLogEnabled(logEnabled)
    }

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