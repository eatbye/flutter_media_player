#import "FlutterMediaPlayerPlugin.h"
#import <flutter_media_player/flutter_media_player-Swift.h>

@implementation FlutterMediaPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMediaPlayerPlugin registerWithRegistrar:registrar];
}
@end
