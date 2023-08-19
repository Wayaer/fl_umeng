#import "UMengPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>

@implementation UMengPlugin

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"UMeng"
                  binaryMessenger:registrar.messenger];

    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        if ([@"init" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            [UMConfigure initWithAppkey:args[@"appKey"] channel:args[@"channel"]];
            result(@(YES));
        } else if ([@"getUMId" isEqualToString:call.method]) {
            NSString *zid = [UMConfigure getUmengZID];
            NSString *uid = [UMConfigure umidString];
            result(@{
                    @"umId": uid == nil ? @"" : uid,
                    @"umzId": zid == nil ? @"" : zid
            });
        } else if ([@"getDeviceInfo" isEqualToString:call.method]) {
            result(@{
                    @"isJailbroken": @([MobClick isJailbroken]),
                    @"isPirated": @([MobClick isPirated]),
                    @"isProxy": @([MobClick isProxy]),
            });
        } else if ([@"setEncryptEnabled" isEqualToString:call.method]) {
            [UMConfigure setEncryptEnabled:[call.arguments boolValue]];
            result(@(YES));
        } else if ([@"getTestDeviceInfo" isEqualToString:call.method]) {
            result([UMConfigure deviceIDForIntegration]);
        } else if ([@"setLogEnabled" isEqualToString:call.method]) {
            [UMConfigure setLogEnabled:[call.arguments boolValue]];
            result(@(YES));
        } else if ([@"onEvent" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            [MobClick event:args[@"event"] attributes:args[@"properties"]];
            result(@(YES));
        } else if ([@"onProfileSignIn" isEqualToString:call.method]) {
            NSDictionary *args = call.arguments;
            NSString *provider = args[@"provider"];
            if (provider) {
                [MobClick profileSignInWithPUID:args[@"userID"] provider:provider];
            } else {
                [MobClick profileSignInWithPUID:args[@"userID"]];
            }
            result(@(YES));
        } else if ([@"onProfileSignOff" isEqualToString:call.method]) {
            [MobClick profileSignOff];
            result(@(YES));
        } else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]) {
            [MobClick setAutoPageEnabled:YES];
            result(@(YES));
        } else if ([@"setPageCollectionModeManual" isEqualToString:call.method]) {
            [MobClick setAutoPageEnabled:NO];
            result(@(YES));
        } else if ([@"onPageStart" isEqualToString:call.method]) {
            [MobClick beginLogPageView:call.arguments];
            result(@(YES));
        } else if ([@"onPageEnd" isEqualToString:call.method]) {
            [MobClick endLogPageView:call.arguments];
            result(@(YES));
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}
@end
