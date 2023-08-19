#import "UMengLinkPlugin.h"
#import <UMLink/UMLink.h>

@interface UMengLinkPlugin () <MobClickLinkDelegate>
@end

@implementation UMengLinkPlugin {
    NSString *_path;
    NSString *_uri;
    NSDictionary *linkParams;
    NSDictionary *installParams;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"UMeng.link"
                                     binaryMessenger:registrar.messenger];
    UMengLinkPlugin *instance = [[UMengLinkPlugin alloc] init];
    instance.channel = channel;
    
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)init {
    self = [super init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getLaunchParams" isEqualToString:call.method]) {
        result(@{
            @"path": _path?:@"",
            @"uri": _uri?:@"",
            @"linkParams": linkParams?:@{},
            @"installParams": installParams?:@{},
        });
    } else if ([@"getInstallParams" isEqualToString:call.method]) {
        BOOL clipBoardEnabled = [call.arguments boolValue];
        if (clipBoardEnabled) {
            [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
                [self invokeMethodInstall:params :URL :error];
            }];
        } else {
            [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
                [self invokeMethodInstall:params :URL :error];
            }
                          enablePasteboard:NO];
        }
        result(@(YES));
    } else {
        result(FlutterMethodNotImplemented);
    }
}


//Universal link的回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    return [MobClickLink handleUniversalLink:userActivity delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [MobClickLink handleLinkURL:url delegate:self];
}
//URL Scheme回调，iOS9以上，走这个方法
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [MobClickLink handleLinkURL:url delegate:self];
}

- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params {
    _path = path;
    linkParams = params;
    [self.channel invokeMethod:@"onLink" arguments:@{
        @"linkParams": params,
        @"path": path,
    }];
}

- (void)invokeMethodInstall:(NSDictionary *)params :(NSURL *)url :(NSError *)error {
    if (error) {
        [self.channel invokeMethod:@"onError" arguments:error.description];
    } else {
        _uri = url.absoluteString;
        installParams = params;
        [self.channel invokeMethod:@"onInstall" arguments:@{
            @"installParams": params,
            @"uri": url.absoluteString,
        }];
    }
}
@end
