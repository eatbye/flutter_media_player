import Flutter
import UIKit
//import StreamingKit
import FreeStreamer
import AVFoundation

public class SwiftFlutterMediaPlayerPlugin: NSObject, FlutterPlugin {
    let audioPlayer = FSAudioStream();
    
    var registrar: FlutterPluginRegistrar;
    var currentRate: Double = 0.0;
    var channel: FlutterMethodChannel;
    var state = -1;
    
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
            prepare()
            return result(true)
        case "receivingRemoteControlEvents":
            receivingRemoteControlEvents()
            return result(true)
        case "play":
            let args = (call.arguments as! NSDictionary)
            let urlString = args.object(forKey: "url") as! String
            let isLocal = args.object(forKey: "isLocal") as! Bool
            print(isLocal);
            print("-=-----")
            if(isLocal){
                let asset = self.registrar.lookupKey(forAsset: urlString);
                let path = Bundle.main.path(forAuxiliaryExecutable: asset);
                let url = URL(fileURLWithPath: path!)
                
                audioPlayer.play(from: url)
            }else{
                let url = URL(string: urlString)
                print(url)
                audioPlayer.play(from: url)
            }
            audioPlayer.onStateChange = self._streamStateChangeHandler()
            
            return result(urlString)
        case "pause":
            audioPlayer.pause()
            return result(true)
        case "resume":
            //audioPlayer.resume();
            audioPlayer.pause()
            return result(true)
        case "stop":
            audioPlayer.stop();
            return result(true);
        case "progress":
            //return result(audioPlayer.progress)
            //let position = audioPlayer.currentTimePlayed
            //let duration = position.playbackTimeInSeconds / position.position
            //return result(duration)
            let position = audioPlayer.currentTimePlayed
            return result(position.playbackTimeInSeconds)
        case "duration":
            //let position = audioPlayer.currentTimePlayed
    
            //let duration = position.playbackTimeInSeconds / position.position
            //let position = audioPlayer.currentTimePlayed
            //return result(position.position)
            //return result(position.playbackTimeInSeconds);
            
            let position = audioPlayer.currentTimePlayed
            let duration = position.playbackTimeInSeconds / position.position
            return result(duration)
        case "getVolume":
            let vol = AVAudioSession.sharedInstance().outputVolume
            return result(vol)
        case "seek":
            let args = (call.arguments as! NSDictionary)
            let time = args.object(forKey: "time") as! Float
            //audioPlayer.seek(toTime: time)
            let positionAll = audioPlayer.currentTimePlayed
            let duration = positionAll.playbackTimeInSeconds / positionAll.position
            
            var position = FSStreamPosition()
            position.position = time / duration
            audioPlayer.seek(to: position)
            return result(true)
        case "getPlatformVersion":
            return result("iOS " + UIDevice.current.systemVersion)
        case "state":
            //return result(audioPlayer.state.rawValue)
            return result(state);
        default:
            return result(false);
        }
    }
    
    func receivingRemoteControlEvents(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func prepare(){
        //beginReceivingRemoteControlEvents
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: []);
            try AVAudioSession.sharedInstance().setActive(true);
            //self.channel.invokeMethod("audio.play", arguments: nil);
        } catch let error {
            print(error);
            //self.channel.invokeMethod("error", arguments: error.localizedDescription);
            //return result(false);
        }
    }
    
    private func _streamStateChangeHandler() -> (FSAudioStreamState) -> Void {
        return { state1 in
//            if state.rawValue == FSAudioStreamState.fsAudioStreamPlaybackCompleted.rawValue {
                //self.nextAction()
//            }
            print(state1.rawValue);
            self.state = state1.rawValue;
            /*
             if state.rawValue == FSAudioStreamState.fsAudioStreamPlaying.rawValue{
             print("-------------")
             
             self.setInfoCenterCredentials()
             }
             */
        }
    }
    /*
    @objc func audioSessionRouteChanged(_ notification: Notification) {
        let reasonObj = (notification as NSNotification).userInfo![AVAudioSessionRouteChangeReasonKey] as! NSNumber
        if let reason = AVAudioSession.RouteChangeReason(rawValue: reasonObj.uintValue) {
            switch reason {
            case .newDeviceAvailable:
                print("1")
                
                break
            case .oldDeviceUnavailable:
                //self.pauseAction()
                break
            default:
                break
            }
        }
    }
    
    // MARK: - 音乐播放控制
    override func remoteControlReceived(with event: UIEvent?) {
        print("音乐播放控制")
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                playAction()
            case .remoteControlPause :
                pauseAction()
            case .remoteControlNextTrack :
                nextAction()
            case .remoteControlPreviousTrack:
                previousAction()
            case .remoteControlTogglePlayPause:
                playAction()
            default:
                break
            }
        }
    }
    */
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


