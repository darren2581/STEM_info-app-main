import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dotted_line_painter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Yic extends StatefulWidget {
  const Yic({super.key});
  
  @override
  _YicState createState() => _YicState();
}

class _YicState extends State<Yic>{
  List<Map<String, dynamic>> votingsList = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;
    var votingsData = <Map<String, dynamic>>[];

    // Fetch latest data from Firestore
    await database.collection("stem_yic_voting").get().then((event) {
      for (var doc in event.docs) {
        final data = doc.data();
        votingsData.add(data);
      }
    });

    // Update the state with new data
    setState(() {
      votingsList = votingsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color.fromRGBO(255,87,87,255),
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
            //   // Day 1
            //   daySection("Day 1", "7th September 2024", [
            //     eventItem("0800", "Registration", ""),
            //     eventItem("0930", "Welcoming Speech", "By YB Dato Sumwan"),
            //     eventItem("1000", "Opening Ceremony", ""),
            //     eventItem("1100", "YIC & TMC Competition", ""),
            //     eventItem("1200", "Lunch Break", ""),
            //     eventItem("1330", "Career Talk", "By AnodaPursen from Petro"),
            //   ]),
            //   const SizedBox(height: 20),
            //   //Day 2
            //   daySection("Day 2", "8th September 2024", [
            //     eventItem("0800", "Registration", ""),
            //     eventItem("0930", "Appreciation Speech", "By YB Dato Sumwan"),
            //     eventItem("1000", "Performance by Some1", ""),
            //     eventItem("1100", "Science Track Competition", ""),
            //     eventItem("1200", "Lunch Break", ""),
            //     eventItem("1330", "Science Track Judging", "Judges from Curtin"),
            //   ]),
              // const SizedBox(height: 20),
              //Votings
              votings(context, votingsList),
            ],
          ),
        ),
      ),
    );
  }
}

Widget daySection(String day, String date, List<Widget> events) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Planet.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
      Column(
        children: events,
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget eventItem(String time, String content, String? description ) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        const SizedBox(width: 35),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              if (description != null && description.isNotEmpty)
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              const SizedBox(height: 8.0),
              CustomPaint(
                painter: DottedLinePainter(
                  color: Colors.grey,
                  strokeWidth: 1.0,
                  dashLength: 3.0,
                  dashSpacing: 3.0,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget votings(BuildContext context, List<Map<String, dynamic>> votingsList) {
  double screenHeight = MediaQuery.of(context).size.height;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Star.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            "Votings",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/Star.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: screenHeight,
        child: ListView.builder(
            itemCount: votingsList.length,
            itemBuilder: (context, index) {
              final votings = votingsList[index];
        
              final url = votings['url'];
              final title = votings['title'];
              final image = votings['image'];
        
              return votingItem(context, title, url, image);
            }
        ),
      ),
      //change link to wanted
      // votingItem(context, "Young Innovative Challenge", "https://forms.gle/twWqsSoaCxhsPXHt7", "assets/image/qr_code.png"),
      // votingItem(context, "Science Challenge", "https://forms.gle/twWqsSoaCxhsPXHt7", "assets/image/qr_code.png"),
      // votingItem(context, "Tech Track", "https://forms.gle/twWqsSoaCxhsPXHt7", "assets/image/qr_code.png"),
    ],
  );
}

Widget votingItem(BuildContext context, String title, String url, String qrPath) {
  String fileId =   qrPath.split('/d/')[1].split('/')[0];
  String imageLink = 'https://drive.google.com/uc?export=view&id=$fileId';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              height: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Image.network(imageLink),
                  );
                },
              );
            },
            child: SvgPicture.asset(
              'assets/icons/QR.svg',
              width: 24,
              height: 24,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 20.0),
        ),
      ),
    ),
  );
}
