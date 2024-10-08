import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mars extends StatefulWidget {
  const Mars({super.key});
  
  @override
  _MarState createState() => _MarState();
}

class _MarState extends State<Mars> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
        ),
        body: ProjectPanel(),
      ),
    );
  }
}

class ProjectPanel extends StatefulWidget {
  const ProjectPanel({super.key});

  @override
  _ProjectPanelState createState() => _ProjectPanelState();
}

class _ProjectPanelState extends State<ProjectPanel> {
  final List<bool> _isOpen = [false, false, false];

  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;
    var projectsData = <Map<String, dynamic>>[];

    // Fetch latest data from Firestore
    await database.collection("stem_mars").get().then((event) {
      for (var doc in event.docs) {
        final data = doc.data();
        projectsData.add(data);
      }
    });

    // Update the state with new data
    setState(() {
      projects = projectsData;
    });
  }

  // final List<Map<String, dynamic>> projects = [
  //   {
  //     'name': 'AquaConnect',
  //     'image': 'assets/mars/Placeholder.png',
  //     'description': 'AquaConnect is a smart solution for aquarium enthusiasts, offering advanced control and convenience. This system combines a floater, valve, servo, and Arduino to provide...'
  //   },
  //   {
  //     'name': '3D Printed Robot Hand',
  //     'image': 'assets/mars/Placeholder2.jpeg',
  //     'description': 'A fully 3D-printed robotic hand uses two ESP32 and, five servo motors and five bend sensors. You can use the gloves on your hand to control the finger movement of the robotic hand. Try out what can do with the hand!'
  //   },
  //   {
  //     'name': '3D-Printed Robotic Arm',
  //     'image': 'assets/mars/Placeholder3.jpeg',
  //     'description': '3D-printed robotic arm, driven by an Arduino Uno, capable of control via three joysticks, governing six arm joints. Arduino signals servo motors to express the arm.'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: List.generate(projects.length, (index) => _buildProjectCard(index)),
    );
  }

  Widget _buildProjectCard(int index) {
    final project = projects[index];

    String fileId = project['image'].split('/d/')[1].split('/')[0];
    String imageLink = 'https://drive.google.com/uc?export=view&id=$fileId';

    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(
              project['name'],
              style: TextStyle(
                fontWeight: _isOpen[index] ? FontWeight.bold : FontWeight.normal, // Bold when expanded
              ),
            ),
            trailing: Icon(
              _isOpen[index] ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            onTap: () {
              setState(() {
                _isOpen[index] = !_isOpen[index];
              });
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isOpen[index] ? null : 0,
            curve: Curves.easeInOut,
            child: _isOpen[index]
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imageLink,
                            // project['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(project['description']),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}