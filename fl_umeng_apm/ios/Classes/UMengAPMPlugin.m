#import "UMengAPMPlugin.h"
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMAPMConfig.h>

@implementation UMengAPMPlugin

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"UMeng.apm"
                  binaryMessenger:registrar.messenger];

    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        if ([@"init" isEqualToString:call.method]) {
            NSDictionary *crash = call.arguments;
            [NSURLProtocol registerClass:[NSURLProtocol class]];
            [UMCrashConfigure enableNetworkForProtocol:[crash[@"enableNetworkForProtocol"] boolValue]];
            UMAPMConfig *config = [UMAPMConfig defaultConfig];
            config.crashAndBlockMonitorEnable = [crash[@"enableCrashAndBlock"] boolValue];
            config.launchMonitorEnable = [crash[@"enableLaunch"] boolValue];
            config.memMonitorEnable = [crash[@"enableMEM"] boolValue];
            config.oomMonitorEnable = [crash[@"enableOOM"] boolValue];
            config.networkEnable = [crash[@"networkEnable"] boolValue];
            [UMCrashConfigure setAPMConfig:config];
            result(@(YES));
        } else if ([@"setAppVersion" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            [UMCrashConfigure setAppVersion:args[@"version"] buildVersion:args[@"buildId"]];
            result(@(YES));
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}
@end
