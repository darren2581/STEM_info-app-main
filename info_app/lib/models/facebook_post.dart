class FacebookPost {
  final String id;
  final String message;
  final String createdTime;
  final String postUrl;

  FacebookPost({
    required this.id,
    required this.message,
    required this.createdTime,
    required this.postUrl,
  });

  factory FacebookPost.fromJson(Map<String, dynamic> json) {
    return FacebookPost(
      id: json['id'],
      message: json['message'],
      createdTime: json['created_time'],
      postUrl: 'https://www.facebook.com/${json['id']}', 
    );
  }
}
