#import "MgOatuh2Plugin.h"
#import <mg_oatuh2/mg_oatuh2-Swift.h>

@implementation MgOatuh2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMgOatuh2Plugin registerWithRegistrar:registrar];
}
@end
