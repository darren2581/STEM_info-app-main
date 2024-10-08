import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:info_app/news.dart';
import 'package:info_app/home_title.dart';
import 'package:info_app/home_link.dart';
import 'package:info_app/events_data.dart';
import 'package:info_app/calendar.dart';
import 'package:info_app/video.dart';

class Home extends StatefulWidget {
  final PageController pageController;

  const Home({super.key, required this.pageController});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List activityBlock = [];

  // First get the FlutterView.
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  @override
  void initState() {
    super.initState();
    // fetchItems();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('http://localhost:8080/fetch_items.php'));

    if (response.statusCode == 200) {
      setState(() {
        activityBlock = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions in logical pixels (dp)
    // Size size = view.physicalSize / view.devicePixelRatio;
    // double width = size.width;
    // double height = size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Upcoming Activities Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const HomeTitle(title: 'Upcoming Activities'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      //widget.tabController.index = 3;
                      widget.pageController.jumpToPage(4);
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 77, 77),
                        height: 0.9,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                        ),
                      ),
                  ),
                )
              ],
            ),            
            SizedBox(
              height: 200,
              width: screenWidth * 0.88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
                    child: EventCard(
                      title: event['title']!,
                      time: event['time']!,
                      location: event['location']!,
                      type: event['type']!,
                      isHome: true,
                    ),
                  );
                }
              ),
            ),
            // Latest News Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const HomeTitle(title: 'Latest News'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      //widget.tabController.index = 1;
                      widget.pageController.jumpToPage(2);
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 77, 77),
                        height: 0.9,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                        ),
                      ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: SizedBox(
                height: 180,
                width: screenWidth * 0.88,
                child: const News(isHome: true, blockWidth: 250, blockHeight: 300,)
              ),
            ),
            // Media Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const HomeTitle(title: 'Media'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      //widget.tabController.index = 2;
                      widget.pageController.jumpToPage(3);
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                          color: Color.fromARGB(255, 77, 77, 77),
                          height: 0.9,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
              child: SizedBox(
                height: 200,
                width: screenWidth * 0.88,
                child: const Video(isHome: true),
              ),
            ),
            const HomeLink(
              url: 'https://www.facebook.com/IEEE.CurtinMalaysia', 
              bckgrdImg: 'assets/home/facebook.svg', 
              title: 'IEEE Curtin Malaysia Student Branch', 
              buttonImg: 'assets/home/Facebook--Streamline-Ios-14 1.svg',
            ),
            const SizedBox(height: 20,),
            const HomeLink(
              url: 'https://www.instagram.com/ieee.curtinmalaysia/', 
              bckgrdImg: 'assets/home/instagram.svg', 
              title: 'ieee.curtinmalaysia', 
              buttonImg: 'assets/home/Instagram--Streamline-Ios-14 1.svg',
            ),
            const SizedBox(height: 20,),
            const HomeLink(
              url: 'https://www.youtube.com/@ieeecmsb9905', 
              bckgrdImg: 'assets/home/youtube.svg', 
              title: 'IEEE CMSB', 
              buttonImg: 'assets/home/Youtube--Streamline-Ios-14 2.svg',
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
//                                   width: 140,
//                                   child: TextButton.icon(
//                                     onPressed: (){
//                                       _launchURL("https://www.facebook.com/IEEE.CurtinMalaysia");
//                                       }, 
//                                     icon: Expanded(
//                                       flex: 1,
//                                       child: SvgPicture.asset(
//                                               'assets/home/Facebook--Streamline-Ios-14 1.svg',
//                                               width: 15,
//                                               height: 15,
//                                             ),
//                                     ),
//                                     label: Expanded(
//                                         flex: 4,
//                                         child: Text(
//                                           "FOLLOW",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 13,
//                                             backgroundColor: Colors.red,
//                                           ),
//                                           )
//                                       ),
//                                     style: ButtonStyle(
//                                         backgroundColor: MaterialStateProperty.all(Colors.white),
//                                         shape: MaterialStateProperty.all(
//                                           RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(5),
//                                           )
//                                         )
//                                       ),
//                                   ),
//                                 )