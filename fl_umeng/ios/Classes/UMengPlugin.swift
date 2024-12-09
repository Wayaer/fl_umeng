import Flutter
import UMCommon
public class UMengPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    
    private var registrar: FlutterPluginRegistrar
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "UMeng", binaryMessenger: registrar.messenger())
        let plugin = UMengPlugin(registrar, channel)
        registrar.addMethodCallDelegate(plugin, channel: channel)
    }
    
    init(_ registrar: FlutterPluginRegistrar, _ channel: FlutterMethodChannel) {
        self.registrar = registrar
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
        case "getTestDeviceInfo":
            result(UMConfigure.deviceIDForIntegration())
        case "setLogEnabled":
            UMConfigure.setLogEnabled(call.arguments as! Bool)
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
            let userId = args["userID"] as! String
            if provider != nil {
                MobClick.profileSignIn(withPUID: userId, provider: provider!)
            } else {
                MobClick.profileSignIn(withPUID: userId)
            }
            result(true)
        case "onProfileSignOff":
            MobClick.profileSignOff()
            result(true)
        case "setPageCollectionModeAuto":
            MobClick.setAutoPageEnabled(true)
            result(true)
        case "setPageCollectionModeManual":
            MobClick.setAutoPageEnabled(false)
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
