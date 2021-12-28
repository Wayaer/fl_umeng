#import "UMengPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMAPMConfig.h>

@implementation UMengPlugin

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"UMeng"
                                     binaryMessenger:registrar.messenger];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        
        if ([@"init" isEqualToString:call.method]){
            NSDictionary *args = call.arguments;
            [UMConfigure initWithAppkey:args[@"appKey"] channel:args[@"channel"]];
            result(@(YES));
        }else if ([@"getUMId" isEqualToString:call.method]){
            result(@{
                @"umId":[UMConfigure getUmengZID],
                @"umzId":[UMConfigure umidString]
            });
        }else if ([@"getDeviceInfo" isEqualToString:call.method]){
            result(@{
                @"isJailbroken":[NSNumber numberWithBool:[MobClick  isJailbroken]],
                @"isPirated":[NSNumber numberWithBool:[MobClick  isPirated]],
                @"isProxy":[NSNumber numberWithBool:[MobClick  isProxy]],
            });
        }else if ([@"setEncryptEnabled" isEqualToString:call.method]){
            [UMConfigure setEncryptEnabled:call.arguments];
            result(@(YES));
        }else if ([@"getTestDeviceInfo" isEqualToString:call.method]){
            result([UMConfigure deviceIDForIntegration]);
        }else if ([@"setLogEnabled" isEqualToString:call.method]){
            [UMConfigure setLogEnabled:call.arguments];
            result(@(YES));
        }else if ([@"onEvent" isEqualToString:call.method]){
            NSDictionary *args = call.arguments;
            [MobClick event:args[@"event"] attributes:args[@"properties"]];
            result(@(YES));
        }else if ([@"onProfileSignIn" isEqualToString:call.method]){
            NSDictionary *args = call.arguments;
            NSString *provider = args[@"provider"];
            if(provider){
                [MobClick profileSignInWithPUID:args[@"userID"] provider:provider];
            }else{
                [MobClick profileSignInWithPUID:args[@"userID"]];
            }
            result(@(YES));
        }else if ([@"onProfileSignOff" isEqualToString:call.method]){
            [MobClick profileSignOff];
            result(@(YES));
        }else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:YES];
            result(@(YES));
        }else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:NO];
            result(@(YES));
        }else if ([@"onPageStart" isEqualToString:call.method]){
            [MobClick beginLogPageView:call.arguments];
            result(@(YES));
        }else if ([@"onPageEnd" isEqualToString:call.method]){
            [MobClick endLogPageView:call.arguments];
            result(@(YES));
        }else if ([@"setAppVersion" isEqualToString:call.method]){
            NSDictionary *args = call.arguments;
            [UMCrashConfigure setAppVersion:args[@"version"] buildVersion:args[@"buildId"]];
            result(@(YES));
        }else if ([@"setCrashConfig" isEqualToString:call.method]){
            NSDictionary *args = call.arguments;
            UMAPMConfig* config = [UMAPMConfig defaultConfig];
            config.crashAndBlockMonitorEnable = args[@"enableCrashAndBlock"];
            config.launchMonitorEnable = args[@"enableLaunch"];
            config.memMonitorEnable = args[@"enableMEM"];
            config.oomMonitorEnable = args[@"enableOOM"];
            [UMCrashConfigure setAPMConfig:config];
            result(@(YES));
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
}
@end
