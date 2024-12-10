// import Flutter
//
// public class UMengAPMPlugin: NSObject, FlutterPlugin {
//     private var channel: FlutterMethodChannel
//
//     public static func register(with registrar: FlutterPluginRegistrar) {
//         let channel = FlutterMethodChannel(name: "UMeng.apm", binaryMessenger: registrar.messenger())
//         let plugin = UMengAPMPlugin(channel)
//         registrar.addMethodCallDelegate(plugin, channel: channel)
//     }
//
//     init(_ channel: FlutterMethodChannel) {
//         self.channel = channel
//     }
//
//     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//         switch call.method {
//         case "init":
//             let args = call.arguments as! [String: Any]
//             UMCrashConfigure.enableNetwork(forProtocol: args["enableNetworkForProtocol"] as! Bool)
//             let config = UMAPMConfig.default()
//             config.crashAndBlockMonitorEnable = args["enableCrashAndBlock"] as! Bool
//             config.launchMonitorEnable = args["enableLaunch"] as! Bool
//             config.memMonitorEnable = args["enableMEM"] as! Bool
//             config.oomMonitorEnable = args["enableOOM"] as! Bool
//             config.networkEnable = args["networkEnable"] as! Bool
//             UMCrashConfigure.setAPMConfig(config)
//             result(true)
//         case "setAppVersion":
//             let args = call.arguments as! [String: Any]
//             let version = args["version"] as! String
//             let buildId = args["buildId"] as! String
//             UMCrashConfigure.setAppVersion(version, buildVersion: buildId)
//             result(true)
//         default:
//             result(FlutterMethodNotImplemented)
//         }
//     }
// }
