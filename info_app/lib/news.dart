import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './post/post_manager.dart';
import './post/post_service.dart';

class News extends StatefulWidget {
  final bool isHome;
  final double blockWidth;
  final double blockHeight;

  const News({super.key, required this.isHome, required this.blockWidth, required this.blockHeight});

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<News> {

  List<Map<String, dynamic>> newsList = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;
    var newsData = <Map<String, dynamic>>[];

    // Fetch latest data from Firestore
    await database.collection("news").get().then((event) {
      for (var doc in event.docs) {
        final data = doc.data();
        newsData.add(data);
      }
    });

    // Update the state with new data
    setState(() {
      newsList = newsData;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url.toString());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildButton(String url, String title, String date, String image, Color color, double blockWidth, double blockHeight) {
    String fileId = image.split('/d/')[1].split('/')[0];
    String imageLink = 'https://drive.google.com/uc?export=view&id=$fileId';

    return IntrinsicHeight(
      child: SizedBox(
        width: blockWidth,
        height: blockHeight,
        // constraints: const BoxConstraints(minHeight: 208.0, minWidth: 343.0), // Default height and width constraint
        child: ElevatedButton(
          onPressed: () => _launchURL(url),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: color,
          ),
          child: Stack(
            fit: StackFit.expand, // Ensures the Stack fills the parent widget
            children: [
              // Background image clipped to button's shape
              Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(imageLink),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Text content overlay
              Positioned(
                bottom: 0, // Aligns the container to the bottom of the button
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 72.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        if (!widget.isHome)
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color customColor = const Color(0xFF2596BE);

    Axis orientation = widget.isHome ? Axis.horizontal : Axis.vertical;
    EdgeInsets padding = widget.isHome ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : const EdgeInsets.all(30);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF2596BE),
        child: ListView.builder(
          // shrinkWrap: true,
          padding: padding,
          scrollDirection: orientation,
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
        
            final url = news['url'];
            final title = news['title'];
            final date = news['date'];
            final image = news['image'];
        
            Widget retWidget = widget.isHome
              ? Row(
                  children: [
                    buildButton(url, title, date, image, customColor, widget.blockWidth, widget.blockHeight),
                    const SizedBox(width: 35.0), // spacing between elements in a row
                  ],
                )
              : Column(
                  children: [
                    buildButton(url, title, date, image, customColor, widget.blockWidth, widget.blockHeight),
                    const SizedBox(height: 44.0), // spacing between elements in a column
                  ],
                );
              buildButton(url, title, date, image, customColor, widget.blockWidth, widget.blockHeight);
        
              return retWidget;
          },
        ),
      ),
    );
  }
}