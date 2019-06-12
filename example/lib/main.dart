import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_media_player/flutter_media_player.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterMediaPlayer.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:
        ListView(children: <Widget>[
          Text('Running on: $_platformVersion\n'),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.play('http://newconceptmp3.wordbye.com/1/en/E001.mp3');
              print(result);
            },
            child: Text('播放网上'),
          ),
          FlatButton(
            onPressed: () async {

              var result = await FlutterMediaPlayer.play('assets/audio.mp3');
              print(result);
            },
            child: Text('播放本地'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.pause();
              print(result);
            },
            child: Text('pause'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.resume();
              print(result);
            },
            child: Text('resume'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.stop();
              print(result);
            },
            child: Text('stop'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.duration();
              print(result);
            },
            child: Text('duration 长度秒数'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.progress();
              print(result);
            },
            child: Text('progress 播放秒数'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.seek(10.0);
              print(result);
            },
            child: Text('播放到10秒'),
          ),
          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.state();
              print(result);
            },
            child: Text('state 状态'),
          ),

          FlatButton(
            onPressed: () async {
              var result = await FlutterMediaPlayer.getVolume();
              print(result);
            },
            child: Text('getVolume'),
          ),




        ],)

      ),
    );
  }
}
