import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Define the URL of your app on Google Play Store or Apple App Store
  final String appUrl =
      'https://play.google.com/store/apps/details?id=com.whatsapp'; // Replace with your actual app URL
  
  final String googleFormUrl = 
      'https://docs.google.com/forms/d/e/1FAIpQLSdn7My51YeGOKD7jddDGboX06DU8VQC8C-zJFAix-Bcbe8tpw/viewform';
  
  @override
  Widget build(BuildContext context) {
    Color customColor = const Color(0xFF2596BE);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36,20,20,0),
        child: Container(
            width: 366,
            height: 279,
            decoration: BoxDecoration(
              color: customColor, // Background color of the container
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOptionTile(
                  icon: Icons.feedback,
                  text: 'Feedback',
                  onTap: () {
                    _launchGoogleForm();
                  },
                ),
                CustomOptionTile(
                  icon: Icons.share,
                  text: 'Share',
                  onTap: () {
                    _shareApp();
                  },
                ),
                CustomOptionTile(
                  icon: Icons.exit_to_app,
                  text: 'Exit',
                  iconColor: const Color(0xFFFF3C2F),
                  onTap: () {
                    _exitApp(context);
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }

// Method to launch the Google Form URL
  void _launchGoogleForm() async {
    final Uri uri = Uri.parse(googleFormUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleFormUrl';
    }
  }

  // Function to share the app
  void _shareApp() {
    final String message = 'Check out this awesome app: $appUrl';

    // Use the share_plus package to share the app link
    Share.share(message, subject: 'Check out this app!');
  }

  // Function to exit the app
  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                // Use SystemNavigator.pop() for Android and exit(0) for other platforms
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                } else {
                  exit(0);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomOptionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final VoidCallback onTap;

  const CustomOptionTile({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335,
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 22.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}