//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

#if __has_include(<screenshot_callback/ScreenshotCallbackPlugin.h>)
#import <screenshot_callback/ScreenshotCallbackPlugin.h>
#else
@import screenshot_callback;
#endif

#if __has_include(<sensors_plus/FLTSensorsPlusPlugin.h>)
#import <sensors_plus/FLTSensorsPlusPlugin.h>
#else
@import sensors_plus;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [ScreenshotCallbackPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenshotCallbackPlugin"]];
  [FLTSensorsPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSensorsPlusPlugin"]];
}

@end
