#import "MgOauth2Plugin.h"
#import <mg_oauth2/mg_oauth2-Swift.h>

@implementation MgOauth2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMgOauth2Plugin registerWithRegistrar:registrar];
}
@end
