#import "EngineSecurityPlugin.h"
#if __has_include(<engine_security/engine_security-Swift.h>)
#import <engine_security/engine_security-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "engine_security-Swift.h"
#endif

@implementation EngineSecurityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [EngineSecurityPlugin registerWithRegistrar:registrar];
}
@end 