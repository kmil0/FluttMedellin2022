import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  final String? id;
  final String? title;
  VideoPage({Key? key, this.id, this.title}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    _controller!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(
                context,
              );
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        backgroundColor: Colors.purple[900],
        title: Text(
          widget.title!,
          style: const TextStyle(fontSize: 12),
        ),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 8.0), child: FlutterLogo())
        ],
      ),
      body: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Video is ready.');
        },
      ),
    );
  }
}
