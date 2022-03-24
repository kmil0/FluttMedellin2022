import 'package:flutter_medellin/data/models/video_info.dart';

class ChannelInfo {
  final String? id;
  final String? title;
  final String? subscriberCount;
  final String? profilePictureUrl;
  final String? uploadPlaylistId;
  final String? videoCount;
  List<VideoInfo>? videos;

  ChannelInfo({
    this.id,
    this.title,
    this.subscriberCount,
    this.profilePictureUrl,
    this.uploadPlaylistId,
    this.videoCount,
    this.videos,
  });

  factory ChannelInfo.fromMap(Map<String, dynamic> map) {
    return ChannelInfo(
      id: map['id'],
      title: map['snippet']['title'],
      subscriberCount: map['statistics']['subscriberCount'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
      videoCount: map['statistics']['videoCount'],
    );
  }
}
