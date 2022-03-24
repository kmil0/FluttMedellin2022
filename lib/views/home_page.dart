import 'package:flutter/material.dart';
import 'package:flutter_medellin/core/services/api_youtube.dart';
import 'package:flutter_medellin/data/models/channel_info.dart';
import 'package:flutter_medellin/data/models/video_info.dart';
import 'package:flutter_medellin/views/video_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  ChannelInfo? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getChannelInfo();
  }

  _getChannelInfo() async {
    ChannelInfo channel = await APIYoutubeService.instance
        .fetchChannel(channelId: 'UCl-zLD5lt9EPuESn_Fl3yXg');
    setState(() {
      _channel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: const Text('Flutter Medellín'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _channel != null
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24.0,
                      backgroundImage:
                          NetworkImage(_channel!.profilePictureUrl!),
                    )
                  : const SizedBox.shrink(),
            ),
          ]),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel!.videos!.length !=
                        int.parse(_channel!.videoCount!) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadVideos();
                }
                return false;
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20),
                      itemCount: _channel!.videos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        VideoInfo video = _channel!.videos![index];
                        return _getVideo(video);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.play_arrow),
                            Text(
                              'Play Animation ',
                            ),
                          ],
                        )),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
    );
  }

  _getVideo(VideoInfo video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPage(
            id: video.id,
            title: video.title,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        elevation: 5,
        child: Image(
          width: 250.0,
          image: NetworkImage(video.thumbnailUrl!),
        ),
      ),
    );
  }

  _loadVideos() async {
    _isLoading = true;
    List<VideoInfo> moreVideos = await APIYoutubeService.instance
        .fetchVideos(playlistId: _channel!.uploadPlaylistId!);
    List<VideoInfo> allVideos = _channel!.videos!..addAll(moreVideos);
    setState(() {
      _channel!.videos = allVideos;
    });
    _isLoading = false;
  }
}
