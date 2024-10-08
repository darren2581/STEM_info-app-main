import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Video extends StatefulWidget {
  final bool isHome;

  const Video({super.key, required this.isHome});

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {

  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;
    var videosData = <Map<String, dynamic>>[];

    // Fetch latest data from Firestore
    await database.collection("videos").get().then((event) {
      for (var doc in event.docs) {
        final data = doc.data();
        data['doc_id'] = doc.id;
        videosData.add(data);
      }
    });

    // Update the state with new data
    setState(() {
      videos = videosData;
    });
  }

  // Fetch the title of the youtube URL
  Future<String> fetchYoutubeVideoTitle(String videoUrl, String docId) async {
    final Uri uri = Uri.parse(videoUrl);
    final String videoId = uri.queryParameters['v'] ?? uri.pathSegments.last.split('?').first;
    const String apiKey = 'AIzaSyCDC263CDIfWIhWR231yscvGatSgzkWauM';
    final Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey');
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final title = data['items'][0]['snippet']['title'];

      DocumentReference docRef = FirebaseFirestore.instance.collection('videos').doc(docId);
      // Update the field 'video_title' in the database to save a copy of the video title for future reference
      await docRef.update({'title': title}).then((_) {
        // print("Field updated successfully!");
      }).catchError((error) {
        print("Failed to update field: $error");
      });

      return title;
    } else {
      throw Exception('Failed to load video title');
    }
  }

  // Fetch the thumbnail of the youtube URL
  String getThumbnailUrl(String videoUrl) {
    final Uri uri = Uri.parse(videoUrl);
    final String videoId = uri.queryParameters['v'] ?? uri.pathSegments.last.split('?').first;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  // Opens up the link of the URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Buttons are built according to the list of URL returned from database
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF2596BE),
        child: ListView.builder(
          scrollDirection: widget.isHome ? Axis.horizontal : Axis.vertical,
          // shrinkWrap: true,
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];

            final youtubeUrl = video['url'];
            final docId = video['doc_id'];
            return FutureBuilder<String>(
              future: fetchYoutubeVideoTitle(youtubeUrl, docId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return buildVideoButton(youtubeUrl, getThumbnailUrl(youtubeUrl), snapshot.data!, widget.isHome);
                }
              },
            );
          },
        ),
      ),
    );
  }

  // Widget that builds one single video button
  Widget buildVideoButton(String url, String thumbnailUrl, String title, bool isHome) {

    final videoButton = Padding(
      padding: isHome ? const EdgeInsets.fromLTRB(0, 0, 30, 0) : const EdgeInsets.fromLTRB(30.0, 30, 30, 10),
      child: SizedBox(
            height: 0.28 * MediaQuery.of(context).size.height,
            width: widget.isHome 
              ? 0.75 * MediaQuery.of(context).size.width
              : 0.9 * MediaQuery.of(context).size.width,
            // The entire "Video Box" will be a button so that pressing any part of the box will send user to the link
            child: ElevatedButton(
              onPressed: () => _launchURL(url),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/Group.svg',
                      width: 48.0,
                      height: 48.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    return isHome 
      ? Row(
        children: [
          videoButton,
        ],
      )
      : Column(
        children: [
          videoButton,
        ],
      );
  }
}
