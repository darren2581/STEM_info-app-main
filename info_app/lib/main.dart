import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import 'home.dart';
import 'STEM_Playground/stem.dart';
import 'news.dart';
import 'video.dart';
import 'calendar.dart';
import 'menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // var database = FirebaseFirestore.instance;
  // List<Map<String, dynamic>> eventData = []; // Store data here

  // await database.collection("activities").get().then((event) {
  //   for (var doc in event.docs) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     eventData.add(data); // Add each document's data to the list

  //     // Accessing the specific values
  //     final venue = data['venue'];
  //     final startTimestamp = data['start_datetime'];
  //     final endTimestamp = data['end_datetime'];

  //     // Printing the specific values
  //     print("Venue: $venue");
  //     print("Start Time: ${startTimestamp.toDate()}");
  //     print("End Time: ${endTimestamp.toDate()}");
  //   }
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IEEE Curtin Malaysia',
      theme: ThemeData(
        primaryColor: const Color(0xFF2596BE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2596BE), // Set app bar background color
        ),
      ),
      home: const BottomTabNavigationPage(),
    );
  }
}

class BottomTabNavigationPage extends StatefulWidget {
  const BottomTabNavigationPage({super.key});

  @override
  State<BottomTabNavigationPage> createState() => _BottomTabNavigationPageState();
}

class _BottomTabNavigationPageState extends State<BottomTabNavigationPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);   // PageController for managing pages
  late List<Widget> _pages;
  int _currentIndex = 0;
  late Color customColor;
  late Color stemColor;

  final List<String> _titles = [
    'Home',
    'STEM Playground',
    'News',
    'Videos',
    'Calendar',
    'Menu',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
    _pages = [
      Home(pageController: _pageController),
      const Stem(),
      const News(isHome: false, blockWidth: 343, blockHeight: 208,),
      const Video(isHome: false),
      const Calendar(),
      const Menu(),
    ];
    customColor = const Color(0xFF2596BE);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController to free resources when the state is removed.
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index; // Update the current index when the page changes
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index); // Navigate to the selected page
  }


  void _handlePageChange() {          // Update background color based on the current page
    setState(() {
      final page = _pageController.page ?? 0.0;

      if (page == 1) {
        customColor = const Color(0xFFEA4547);
      } else {
        customColor = const Color(0xFF2596BE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            _titles[_currentIndex],
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages, // The pages to display in the PageView
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: customColor,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.home,
              color: Colors.white,
            ),
            label: 'Home',
            backgroundColor: Color(0xFF2596BE),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/STEM Playground.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'STEM',
            backgroundColor: customColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/News.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'News',
            backgroundColor: customColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Videos.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'Videos',
            backgroundColor: customColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Calendar.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: 'Calendar',
            backgroundColor: customColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.menu,
              color: Colors.white,
            ),
            label: 'Menu',
            backgroundColor: Color(0xFF2596BE),
          ),
        ],
      ),
    );
  }
}

