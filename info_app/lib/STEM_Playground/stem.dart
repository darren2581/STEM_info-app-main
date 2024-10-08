import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map.dart';
import 'YIC.dart';
import 'mars.dart';
import 'luckyDraw.dart';

class Stem extends StatefulWidget {
  const Stem({super.key});

  @override
  _StemState createState() => _StemState();
}

class _StemState extends State<Stem> with SingleTickerProviderStateMixin{
  late TabController _tabController; // Declare a TabController variable
  late List<Widget> _stemPages;

  final List<String> _categories = [
    'Map',
    'Y.I.C.',
    'M.A.R.S.',
    'Lucky Draw'
  ];

  final String registrationFormUrl = 
      'https://docs.google.com/forms/d/e/1FAIpQLSck6VpD4SyTFjkcfYWvCf2Q0h7U7I3BiM9_f8brYM7T6gf7ag/viewform';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _stemPages = [
      const Maps(),
      const Yic(),
      const Mars(),
      const Luckydraw(),
    ];
  }
  
  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController to free resources when the state is removed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor = Color(0xFFEA4547);
    return Scaffold(
      body: Stack(
        children: [      
          Column(
            children: [
              Container (
                color: customColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,     // Color of the tab indicator
                  labelColor: Colors.white,         // Color of the selected tab text
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: _categories[0]),
                    Tab(text: _categories[1]),
                    Tab(text: _categories[2]),
                    Tab(text: _categories[3]),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _stemPages,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 70.0,
                height: 70.0,
                child: FloatingActionButton(
                  onPressed: () {
                    _launchRegistrationForm();
                  },
                  backgroundColor: customColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),    // Make button round
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/User Registration 35px.svg',
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to launch the Registration Form URL
  void _launchRegistrationForm() async {
    final Uri uri = Uri.parse(registrationFormUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $registrationFormUrl';
    }
  }
}
