import Flutter
import UMCommon

public class UMengPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "UMeng", binaryMessenger: registrar.messenger())
        let plugin = UMengPlugin(channel)
        registrar.addMethodCallDelegate(plugin, channel: channel)
    }
    
    init(_ channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let args = call.arguments as! [String: Any]
            let appKey = args["appKey"] as! String
            let channel = args["channel"] as! String
            UMConfigure.initWithAppkey(appKey, channel: channel)
            result(true)
        case "getUMId":
            result([
                "umId": UMConfigure.getUmengZID(),
                "umzId": UMConfigure.umidString(),
            ])
        case "getDeviceInfo":
            result([
                "isJailbroken": MobClick.isJailbroken(),
                "isPirated": MobClick.isPirated(),
                "isProxy": MobClick.isProxy(),
            ])
        case "setEncryptEnabled":
            UMConfigure.setEncryptEnabled(call.arguments as! Bool)
            result(true)
        case "setAnalyticsEnabled":
            let args = call.arguments as! [String: Any]
            UMConfigure.setAnalyticsEnabled(args["enabled"] as! Bool)
            result(true)
        case "setDomain":
            UMConfigure.setDomain(call.arguments as? String)
            result(true)
        case "getTestDeviceInfo":
            result(UMConfigure.deviceIDForIntegration())
        case "setLogEnabled":
            UMConfigure.setLogEnabled(call.arguments as! Bool)
            result(true)
        case "setSecret":
            MobClick.setSecret(call.arguments as! String)
            result(true)
        case "registerPreProperties":
            let args = call.arguments as! [String: Any]
            MobClick.registerPreProperties(args)
            result(true)
        case "unregisterPreProperty":
            MobClick.unregisterPreProperty(call.arguments as! String)
            result(true)
        case "getPreProperties":
            result(MobClick.getPreProperties())
        case "clearPreProperties":
            MobClick.clearPreProperties()
            result(true)
        case "userProfileMobile":
            MobClick.userProfileMobile(call.arguments as! String)
            result(true)
        case "userProfileEMail":
            MobClick.userProfileEMail(call.arguments as! String)
            result(true)
        case "userProfile":
            let args = call.arguments as! [String: Any]
            MobClick.userProfile(args["value"]!, to: args["key"] as! String)
            result(true)
        case "onEvent":
            let args = call.arguments as! [String: Any]
            let event = args["event"] as! String
            let properties = args["properties"] as! [AnyHashable: Any]
            MobClick.event(event, attributes: properties)
            result(true)
        case "onProfileSignIn":
            let args = call.arguments as! [String: Any]
            let provider = args["provider"] as? String
            let userId = args["userId"] as! String
            if provider != nil {
                MobClick.profileSignIn(withPUID: userId, provider: provider!)
            } else {
                MobClick.profileSignIn(withPUID: userId)
            }
            result(true)
        case "onProfileSignOff":
            MobClick.profileSignOff()
            result(true)
        case "setLatitude":
            let args = call.arguments as! [String: Any]
            let longitude = args["longitude"] as! Double
            let latitude = args["latitude"] as! Double
            MobClick.setLatitude(longitude, longitude: longitude)
            result(true)
        case "setPageCollectionMode":
            MobClick.setAutoPageEnabled(call.arguments as! Bool)
            result(true)
        case "onPageStart":
            MobClick.beginLogPageView(call.arguments as! String)
            result(true)
        case "onPageEnd":
            MobClick.endLogPageView(call.arguments as! String)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
