import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_medellin/data/models/channel_info.dart';
import 'package:flutter_medellin/data/models/video_info.dart';
import 'package:flutter_medellin/core/config/keys.dart';

class APIYoutubeService {
  APIYoutubeService._instantiate();
  static final APIYoutubeService instance = APIYoutubeService._instantiate();
  static const String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<ChannelInfo> fetchChannel({String? channelId}) async {
    Map<String, String> parameters = {
      'id': channelId!,
      'part': 'snippet, contentDetails, statistics',
      'key': apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      ChannelInfo channel = ChannelInfo.fromMap(data);

      channel.videos = await fetchVideos(
        playlistId: channel.uploadPlaylistId!,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<VideoInfo>> fetchVideos({required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '10',
      'playlistId': playlistId,
      'pageToken': _nextPageToken,
      'key': apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      List<VideoInfo> videos = [];
      for (var json in videosJson) {
        videos.add(
          VideoInfo.fromMap(json['snippet']),
        );
      }
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
