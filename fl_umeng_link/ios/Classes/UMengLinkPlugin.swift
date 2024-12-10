import Flutter
import UMLink

public class UMengLinkPlugin: NSObject, FlutterPlugin, MobClickLinkDelegate {
    private var channel: FlutterMethodChannel

    private var path: String?
    private var uri: String?
    private var linkParams: [AnyHashable: Any]?
    private var installParams: [AnyHashable: Any]?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "UMeng.link", binaryMessenger: registrar.messenger())
        let plugin = UMengLinkPlugin(channel)
        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    init(_ channel: FlutterMethodChannel) {
        self.channel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLaunchParams":
            let params: [String: Any?] = [
                "path": path,
                "uri": uri,
                "linkParams": linkParams,
                "installParams": installParams,
            ]
            result(params)
        case "getInstallParams":
            let clipBoardEnabled = call.arguments as? Bool
            if clipBoardEnabled != nil {
                MobClickLink.getInstallParams(invokeInstallParams, enablePasteboard: clipBoardEnabled!)
            } else {
                MobClickLink.getInstallParams(invokeInstallParams)
            }
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func invokeInstallParams(params: [AnyHashable: Any]?, url: URL?, error: Error?) {
        if error == nil {
            uri = url?.absoluteString
            installParams = params
            let params: [String: Any?] = [
                "installParams": params,
                "uri": url?.absoluteString,
            ]
            channel.invokeMethod("onInstall", arguments: params)
        } else {
            channel.invokeMethod("onError", arguments: error!.localizedDescription)
        }
    }

    // Universal link的回调
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return MobClickLink.handleUniversalLink(userActivity, delegate: self)
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        return MobClickLink.handle(url, delegate: self)
    }

    // URL Scheme回调，iOS9以上，走这个方法
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return MobClickLink.handle(url, delegate: self)
    }

    public func getLinkPath(_ path: String, params: [AnyHashable: Any]) {
        self.path = path
        linkParams = params
        let params: [String: Any?] = [
            "linkParams": params,
            "path": path,
        ]
        channel.invokeMethod("onLink", arguments: params)
    }
}
