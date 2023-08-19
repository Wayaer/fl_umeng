package fl.umeng.link

import android.content.Context
import android.content.Intent
import android.net.Uri
import com.umeng.umlink.MobclickLink
import com.umeng.umlink.UMLinkListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** UMengLinkPlugin */
class UMengLinkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private var path: String? = null
    private var uri: String? = null
    private var linkParams: HashMap<String, String>? = null
    private var installParams: HashMap<String, String>? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "UMeng.link")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getLaunchParams" -> {
                result.success(
                    mapOf(
                        "path" to path,
                        "linkParams" to linkParams,
                        "uri" to uri,
                        "installParams" to installParams
                    )
                )
            }
            "getInstallParams" -> {
                val clipBoardEnabled = call.arguments as Boolean
                if (!clipBoardEnabled) {
                    MobclickLink.getInstallParams(context, umLinkAdapter)
                } else {
                    MobclickLink.getInstallParams(context, false, umLinkAdapter)
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleUMLinkURI(context: Context, intent: Intent) {
        MobclickLink.handleUMLinkURI(context, intent.data, umLinkAdapter)
    }

    private var umLinkAdapter: UMLinkListener = object : UMLinkListener {
        override fun onLink(path: String, params: HashMap<String, String>) {
            this@UMengLinkPlugin.path = path
            this@UMengLinkPlugin.linkParams = params
            channel.invokeMethod(
                "onLink", mapOf(
                    "path" to path, "linkParams" to linkParams
                )
            )
        }

        override fun onInstall(params: HashMap<String, String>, uri: Uri) {
            this@UMengLinkPlugin.uri = uri.path
            this@UMengLinkPlugin.installParams = params
            channel.invokeMethod(
                "onInstall", mapOf(
                    "uri" to uri.path, "installParams" to params
                )
            )
        }

        override fun onError(error: String) {
            channel.invokeMethod("onError", error)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private var binding: ActivityPluginBinding? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addOnNewIntentListener(onNewIntent)
        handleUMLinkURI(binding.activity, binding.activity.intent)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addOnNewIntentListener(onNewIntent)
        handleUMLinkURI(binding.activity, binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        binding!!.removeOnNewIntentListener(onNewIntent)
        binding = null
    }


    override fun onDetachedFromActivity() {
        binding!!.removeOnNewIntentListener(onNewIntent)
        binding = null
    }

    private var onNewIntent: PluginRegistry.NewIntentListener =
        PluginRegistry.NewIntentListener { intent ->
            handleUMLinkURI(context, intent)
            true
        }
}
