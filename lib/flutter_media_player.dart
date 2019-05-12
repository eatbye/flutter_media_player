import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMediaPlayer {
  static const MethodChannel _channel =
      const MethodChannel('flutter_media_player');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> prepare() async {
    var res = await _channel.invokeMethod('prepare');
    return res;

  }

  static Future<bool> play(url) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'url': url,
    };

    var res = await _channel.invokeMethod('play', params);
    return res;
  }

  static Future<bool> pause() async {
    var res = await _channel.invokeMethod('pause');
    return res;
  }

  static Future<bool> resume() async {
    var res = await _channel.invokeMethod('resume');
    return res;
  }

  static Future<double> progress() async {
    var res = await _channel.invokeMethod('progress');
    return res;
  }

  static Future<double> duration() async {
    var res = await _channel.invokeMethod('duration');
    return res;
  }

  static Future<bool> seek(time) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'time': time,
    };

    var res = await _channel.invokeMethod('seek', params);
    return res;
  }

  static Future<int> state() async {
    var res = await _channel.invokeMethod('state');
    return res;
  }

}
