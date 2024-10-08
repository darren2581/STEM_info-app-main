class Post {
  final String title;
  final String date;
  final String url;
  final String image;

  Post({
    required this.title,
    required this.date,
    required this.url,
    required this.image,
  });
}

class PostManager {
  final Map<String, Post> _posts = {};

  void addPost(String id, Post post) {
    _posts[id] = post;
  }

  Post? getPost(String id) {
    return _posts[id];
  }

  void removePost(String id) {
    _posts.remove(id);
  }

  List<Post> getAllPosts() {
    return _posts.values.toList();
  }
}