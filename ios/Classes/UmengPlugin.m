#import "UmengPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>

@implementation UmengPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"UMeng"
                                     binaryMessenger:registrar.messenger];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSDictionary *args = call.arguments;
        if ([@"init" isEqualToString:call.method]){
            [UMConfigure initWithAppkey:args[@"appKey"] channel:args[@"channel"]];
            result([NSNumber numberWithBool:YES]);
        }else  if([@"onEvent" isEqualToString:call.method]){
            [MobClick event:args[@"event"] attributes:args[@"properties"]];
            result([NSNumber numberWithBool:YES]);
        }else if ([@"onProfileSignIn" isEqualToString:call.method]){
            NSString *provider = args[@"provider"];
            if(provider){
                [MobClick profileSignInWithPUID:args[@"userID"] provider:provider];
            }else{
                [MobClick profileSignInWithPUID:args[@"userID"]];
            }
            result([NSNumber numberWithBool:YES]);
        }else if ([@"onProfileSignOff" isEqualToString:call.method]){
            [MobClick profileSignOff];
            result([NSNumber numberWithBool:YES]);
        }else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:YES];
            result([NSNumber numberWithBool:YES]);
        }else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
            [MobClick setAutoPageEnabled:NO];
            result([NSNumber numberWithBool:YES]);
        }else if ([@"onPageStart" isEqualToString:call.method]){
            [MobClick beginLogPageView:args[@"pageName"]];
            result([NSNumber numberWithBool:YES]);
        }else if ([@"onPageEnd" isEqualToString:call.method]){
            [MobClick endLogPageView:args[@"pageName"]];
            result([NSNumber numberWithBool:YES]);
        }else {
            result(FlutterMethodNotImplemented);
        }
    }];

}
@end
