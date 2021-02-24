#import "UmengPlugin.h"
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>

@implementation UmengPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"UMeng"
                                     binaryMessenger:registrar.messenger];
    [channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
        NSDictionary *args = call.arguments;
        if ([@"init" isEqualToString:call.method]){
            [UMConfigure initWithAppkey:args[@"iosAppKey"] channel:args[@"channel"]];
        }else if ([@"setLogEnabled" isEqualToString:call.method]){
            [UMCommonLogManager setUpUMCommonLogManager];
            BOOL logEnabled = [[args objectForKey:@"logEnabled"] boolValue];
            [UMConfigure setLogEnabled:logEnabled];
        }else if([@"onEvent" isEqualToString:call.method]){
            [MobClick event:args[@"event"] attributes:args[@"properties"]];
        }else if ([@"onProfileSignIn" isEqualToString:call.method]){
            [MobClick profileSignInWithPUID:args[@"userID"]];
        }else if ([@"onProfileSignOff" isEqualToString:call.method]){
            [MobClick profileSignOff];
        }else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:YES];
        }else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:NO];
        }else if ([@"onPageStart" isEqualToString:call.method]){
            [MobClick beginLogPageView:args[@"pageName"]];
        }else if ([@"onPageEnd" isEqualToString:call.method]){
            [MobClick endLogPageView:args[@"pageName"]];
        }else if ([@"reportError" isEqualToString:call.method]){
            NSLog(@"reportError API not existed ");
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
}
@end
