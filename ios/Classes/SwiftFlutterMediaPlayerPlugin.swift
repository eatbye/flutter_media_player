import Flutter
import UIKit
import StreamingKit

public class SwiftFlutterMediaPlayerPlugin: NSObject, FlutterPlugin {
    
  let audioPlayer = STKAudioPlayer()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_media_player", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMediaPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "prepare":
            prepare()
            return result(true)
        case "play":
            let args = (call.arguments as! NSDictionary)
            let urlString = args.object(forKey: "url") as! String
            audioPlayer.play(urlString)
            return result(true)
        case "pause":
            audioPlayer.pause();
            return result(true);
        case "resume":
            audioPlayer.resume();
            return result(true);
        case "progress":
            return result(audioPlayer.progress)
        case "duration":
            return result(audioPlayer.duration)
        case "seek":
            let args = (call.arguments as! NSDictionary)
            let time = args.object(forKey: "time") as! Double
            audioPlayer.seek(toTime: time)
            return result(true)
        case "getPlatformVersion":
            return result("iOS " + UIDevice.current.systemVersion)
        case "state":
            return result(audioPlayer.state.rawValue)
        default:
            return result(false);
    }
  }
    
    func prepare(){
    }
    
}
