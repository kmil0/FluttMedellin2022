class VideoInfo {
  DateTime? publishedAt;
  final String? id;
  final String? title;
  final String? channelTitle;
  final String? thumbnailUrl;
  final String? description;

  VideoInfo({
    this.publishedAt,
    this.id,
    this.title,
    this.channelTitle,
    this.thumbnailUrl,
    this.description,
  });

  factory VideoInfo.fromMap(Map<String, dynamic> snippet) {
    return VideoInfo(
        publishedAt: DateTime.parse(snippet['publishedAt']),
        id: snippet['resourceId']['videoId'],
        title: snippet['title'],
        channelTitle: snippet['channelTitle'],
        thumbnailUrl: snippet['thumbnails']['high']['url'],
        description: snippet['description']);
  }
}
