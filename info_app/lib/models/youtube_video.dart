class YouTubeVideo {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;

  YouTubeVideo({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      videoUrl: 'https://www.youtube.com/watch?v=${json['id']['videoId']}',
    );
  }
}
