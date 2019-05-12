import Flutter
import UIKit
import StreamingKit

public class SwiftFlutterMediaPlayerPlugin: NSObject, FlutterPlugin {
    let audioPlayer = STKAudioPlayer();
    
    var registrar: FlutterPluginRegistrar;
    var currentRate: Double = 0.0;
    var channel: FlutterMethodChannel;
    
    init(pluginRegistrar: FlutterPluginRegistrar, pluginChannel: FlutterMethodChannel) {
        registrar = pluginRegistrar;
        channel = pluginChannel;
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let mediaControlsChannel = FlutterMethodChannel(name: "flutter_media_player", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMediaPlayerPlugin(pluginRegistrar: registrar, pluginChannel: mediaControlsChannel);
        
        
        registrar.addMethodCallDelegate(instance, channel: mediaControlsChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "prepare":
            return result(true)
        case "play":
            let args = (call.arguments as! NSDictionary)
            let urlString = args.object(forKey: "url") as! String
            let isLocal = args.object(forKey: "isLocal") as! Bool
            if(isLocal){
                let asset = self.registrar.lookupKey(forAsset: urlString);
                let path = Bundle.main.path(forAuxiliaryExecutable: asset);
                let url = URL(fileURLWithPath: path!)
                
                audioPlayer.play(url)
            }else{
                audioPlayer.play(urlString)
            }
            
            return result(urlString)
        case "pause":
            audioPlayer.pause();
            return result(true);
        case "resume":
            audioPlayer.resume();
            return result(true);
        case "stop":
            audioPlayer.stop();
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
}



/*
public class SwiftFlutterMediaPlayerPlugin: NSObject, FlutterPlugin {

    let audioPlayer = STKAudioPlayer();

    var registrar: FlutterPluginRegistrar;
 //var channel: FlutterMethodChannel;
    
    //init(pluginRegistrar: FlutterPluginRegistrar, pluginChannel: FlutterMethodChannel) {
    //    registrar = pluginRegistrar;
    //   channel = pluginChannel;
    //}
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_media_player", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMediaPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    //self.registrar = registrar;
    var text = registrar.lookupKey(forAsset:"assets/audio.mp3");
    print(text);
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "prepare":
            prepare()
            return result(true)
        case "play":
            let args = (call.arguments as! NSDictionary)
            let urlString = args.object(forKey: "url") as! String
            let isLocal = args.object(forKey: "isLocal") as! Bool
            //audioPlayer.play(urlString)
            
            if(isLocal){
                if let range = urlString.range(of: "assets") {
                    //let position = urlString.distance(from: urlString.startIndex, to: range.lowerBound);
                    
                    //if (position == 1 || position == 0) {
  //                      return result(asset);
                    //}
                    
                    var asset = "audio.mp3"
                    var folder = "assets/"
                    
                    let url = Bundle.main.url(forResource: asset, withExtension: "", subdirectory: "flutter_assets/"+folder);
                    return result(url)
                }
                /*
                if let range = urlString.range(of: "assets") {
                    let position = urlString.distance(from: urlString.startIndex, to: range.lowerBound);
                    if (position == 1 || position == 0) {
                        //let asset = self.registrar.lookupKey(forAsset: urlString);
                        //let path = Bundle.main.path(forAuxiliaryExecutable: asset);
                        //playerItem = AVPlayerItem(url: URL(fileURLWithPath: path!));
                        return result(url);
                    } else {
                        //playerItem = AVPlayerItem(url: args.object(forKey: "isLocal") as! Int == 1 ? URL(fileURLWithPath: urlString) : URL(string: urlString)!);
                    }
                }
                */
                let path = Bundle.main.path(forAuxiliaryExecutable: urlString)
                return result(path)
            }else{
                //audioPlayer.play(urlString)
            }
            
            
            //let path = Bundle.main.path(forAuxiliaryExecutable: urlString);
            
            return result(urlString)
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
*/


