package fl.umeng

import android.content.Context
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import com.umeng.commonsdk.statistics.common.DeviceConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


open class UMengPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(plugin: FlutterPluginBinding) {
        channel = MethodChannel(plugin.binaryMessenger, "UMeng")
        context = plugin.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                val key = call.argument<String>("appKey")
                val channel = call.argument<String>("channel")
                UMConfigure.preInit(context, key, channel)
                UMConfigure.submitPolicyGrantResult(context, true)
                UMConfigure.init(context, key, channel, UMConfigure.DEVICE_TYPE_PHONE, null)
                result.success(true)
            }

            "getUMId" -> {
                result.success(
                    mapOf(
                        "umId" to UMConfigure.getUMIDString(context),
                        "umzId" to UMConfigure.getUmengZID(context),
                    )
                )
            }

            "getDeviceInfo" -> {
                result.success(
                    mapOf(
                        "deviceId" to DeviceConfig.getDeviceId(context),
                        "mac" to DeviceConfig.getMac(context),
                        "androidId" to DeviceConfig.getAndroidId(context),
                        "oaId" to DeviceConfig.getOaid(context),
                        "appHashKey" to DeviceConfig.getAppHashKey(context),
                        "appMD5Signature" to DeviceConfig.getAppMD5Signature(context),
                        "appName" to DeviceConfig.getAppName(context),
                        "appSHA1Key" to DeviceConfig.getAppSHA1Key(context),
                        "idfa" to DeviceConfig.getIdfa(context),
                        "imei" to DeviceConfig.getImei(context),
                        "imeiNew" to DeviceConfig.getImeiNew(context),
                        "imis" to DeviceConfig.getImsi(context),
                        "mccmnc" to DeviceConfig.getMCCMNC(context),
                        "meId" to DeviceConfig.getMeid(context),
                        "secondSimIMEi" to DeviceConfig.getSecondSimIMEi(context),
                        "simICCID" to DeviceConfig.getSimICCID(context),
                        "serial" to DeviceConfig.getSerial(),
                    )
                )
            }

            "setEncryptEnabled" -> {
                UMConfigure.setEncryptEnabled(call.arguments as Boolean)
                result.success(true)
            }

            "setAnalyticsEnabled" -> {
                val enableAplCollection = call.argument<Boolean>("enableAplCollection")!!
                UMConfigure.enableAplCollection(enableAplCollection)
                val enableImeiCollection = call.argument<Boolean>("enableImeiCollection")!!
                UMConfigure.enableImeiCollection(enableImeiCollection)
                val enableImsiCollection = call.argument<Boolean>("enableImsiCollection")!!
                UMConfigure.enableImsiCollection(enableImsiCollection)
                val enableIccidCollection = call.argument<Boolean>("enableIccidCollection")!!
                UMConfigure.enableIccidCollection(enableIccidCollection)
                val enableUmcCfgSwitch = call.argument<Boolean>("enableUmcCfgSwitch")!!
                UMConfigure.enableUmcCfgSwitch(enableUmcCfgSwitch)
                val enableWiFiMacCollection = call.argument<Boolean>("enableWiFiMacCollection")!!
                UMConfigure.enableWiFiMacCollection(enableWiFiMacCollection)
                result.success(true)
            }

            "setDomain" -> {
                UMConfigure.setDomain(call.arguments as String)
                result.success(true)
            }

            "getTestDeviceInfo" -> result.success(DeviceConfig.getDeviceIdForGeneral(context))
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
                val userId = call.argument<String>("userId")
                if (provider != null) {
                    MobclickAgent.onProfileSignIn(userId, provider)
                } else {
                    MobclickAgent.onProfileSignIn(userId)
                }
                result.success(true)
            }

            "onProfileSignOff" -> {
                MobclickAgent.onProfileSignOff()
                result.success(true)
            }

            "userProfileMobile" -> {
                MobclickAgent.userProfileMobile(call.arguments as String)
                result.success(true)
            }

            "userProfileEMail" -> {
                MobclickAgent.userProfileEMail(call.arguments as String)
                result.success(true)
            }

            "userProfile" -> {
                val map = call.arguments as Map<*, *>
                MobclickAgent.userProfile(map["key"] as String, map["value"] as String)
                result.success(true)
            }

            "setLatitude" -> {
                val map = call.arguments as Map<*, *>
                MobclickAgent.setLocation(map["longitude"] as Double, map["latitude"] as Double)
                result.success(true)
            }

            "setSecret" -> {
                MobclickAgent.setSecret(context, call.arguments as String)
                result.success(true)
            }

            "registerPreProperties" -> {
                val map = call.arguments as Map<*, *>
                MobclickAgent.registerPreProperties(context, JSONObject(map))
                result.success(true)
            }

            "unregisterPreProperty" -> {
                MobclickAgent.unregisterPreProperty(context, call.arguments as String)
                result.success(true)
            }

            "getPreProperties" -> {
                val json = MobclickAgent.getPreProperties(context)
                result.success(json.toMap())
            }

            "clearPreProperties" -> {
                MobclickAgent.clearPreProperties(context)
                result.success(true)
            }

            "setPageCollectionMode" -> {
                val isAuto = call.arguments as Boolean
                if (isAuto) {
                    MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_AUTO)
                } else {
                    MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.LEGACY_MANUAL)
                }
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

            else -> result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun JSONObject.toMap(): Map<String, Any> {
        return keys().asSequence().associateWith { get(it) }
    }
}