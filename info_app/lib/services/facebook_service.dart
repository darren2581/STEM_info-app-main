import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facebook_post.dart';

class FacebookService {
  static const String pageId = '7496028567189772';
  static const String accessToken = 'EAAHUbQg05rkBOwHjAO8rWd33WrX2weCD61nK85ew4y5vf5hynRmGAKTyNIHgLoZC1naxhhIuAmpEV1xFTZAFb7s2uNQnz7ZBunrFgMcqkiHkPP4ORR7lSGNKqxDwFQJhPGzc2qJwYwKb2TMEkQZAZCIMdNzvyyyZCPes48lFTMrGlaq9Vu8UEaftZCOCFMHXK40ZCU0qZCVZBSHvUb8FNzdyxVSNFk4PE93Ot8HSiDIJEhcDpwgUlMLZBMP';

  Future<List<FacebookPost>> fetchPosts() async {
    final response = await http.get(Uri.parse(
      'https://graph.facebook.com/v20.0/$pageId/posts?access_token=$accessToken'
    ));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['data'];
      List<FacebookPost> posts = body.map((dynamic item) => FacebookPost.fromJson(item)).toList();
      return posts;
    } else {
      String errorMessage = 'Failed to load posts: ${response.statusCode} ${response.reasonPhrase}';
      print('Error response: ${response.body}');
      throw Exception(errorMessage);
    }
  }
}
