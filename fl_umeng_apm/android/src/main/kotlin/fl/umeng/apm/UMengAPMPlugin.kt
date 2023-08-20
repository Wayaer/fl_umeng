package fl.umeng.apm

import android.os.Bundle
import com.umeng.umcrash.UMCrash
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlUMengAPMPlugin */
class UMengAPMPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "UMeng.apm")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val argument = call.arguments as Map<*, *>
                val bundle = Bundle()
                bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_JAVA, argument["enableJava"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_NATIVE, argument["enableNative"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_UNEXP, argument["enableUnExp"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_ANR, argument["enableAnr"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_PA, argument["enablePa"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_LAUNCH, argument["enableLaunch"] == true)
                bundle.putBoolean(UMCrash.KEY_ENABLE_MEM, argument["enableMEM"] == true)
                UMCrash.initConfig(bundle)
                result.success(true)
            }

            "setAppVersion" -> {
                UMCrash.setAppVersion(call.argument("version"), call.argument("subVersion"), call.argument("buildId"))
                result.success(true)
            }

            "getUMAPMFlag" -> result.success(UMCrash.getUMAPMFlag())
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

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
