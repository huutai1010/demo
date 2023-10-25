import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestM3U8 extends StatefulWidget {
  @override
  _TestM3U8State createState() => _TestM3U8State();
}

class _TestM3U8State extends State<TestM3U8> {
  final videoPlayerController = VideoPlayerController.network(
      'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8');
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Demo"),
        ),
        body: Container(
          child: Chewie(controller: chewieController),
        ));
  }
}
