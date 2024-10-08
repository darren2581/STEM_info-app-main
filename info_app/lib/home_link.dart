import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class HomeLink extends StatefulWidget {
  final String url;
  final String bckgrdImg;
  final String title;
  final String buttonImg;

  const HomeLink({
    super.key, 
    required this.url,
    required this.bckgrdImg,
    required this.title,
    required this.buttonImg
  });

  @override
  State<HomeLink> createState() => _HomeLinkState();
}

class _HomeLinkState extends State<HomeLink> {

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
    return LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = MediaQuery.of(context).size.width;

                // Aspect ratio of your SVG
                double aspectRatio = 961 / 540;
                double height = (screenWidth * 0.88) / aspectRatio;

                return Container(
                  width: screenWidth * 0.88,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(128, 0, 0, 0),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4), // changes position of shadow
                      )
                    ]
                  ),
                  // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SvgPicture.asset(
                              widget.bckgrdImg,
                              width: screenWidth * 0.88,
                              height: height,
                              fit: BoxFit.cover,
                            ),
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.3, sigmaY: 1.3),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: height,
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 13),
                                  child: SvgPicture.asset(
                                    'assets/home/IEEE_transparent (2).svg',
                                    width: 151.95,
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 140,
                                  height: 30,
                                  child: TextButton(
                                    onPressed: (){
                                      _launchURL(widget.url);
                                      }, 
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(Colors.white),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        )
                                      )
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          widget.buttonImg,
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(width: 20),
                                        const FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "FOLLOW",
                                            style: TextStyle(
                                              height: 0.9,
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ] 
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
  }
}