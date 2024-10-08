import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'ImageViewer/imageFullView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});
  
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps>{
  List<Map<String, dynamic>> maps = [];

  // @override
  // void initState() {
  //   super.initState();
  //   timeDilation = 2.0;     // Slow down animations by 2 millisecond

  //   _mapImages = [
  //     'assets/image/Image.png',
  //     'assets/image/Image.png',
  //     'assets/image/Image.png',
  //     'assets/image/Image.png',
  //   ];
  // }

  @override
  void initState() {
    super.initState();
    timeDilation = 2.0;     // Slow down animations by 2 millisecond
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;
    var mapData = <Map<String, dynamic>>[];

    // Fetch latest data from Firestore
    await database.collection("stem_map").get().then((event) {
      for (var doc in event.docs) {
        final data = doc.data();
        data['doc_id'] = doc.id;
        mapData.add(data);
      }
    });

    // Update the state with new data
    setState(() {
      maps = mapData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color.fromRGBO(255,87,87,255),
        child: ListView.builder(
          itemCount: maps.length,
          itemBuilder: (context, index) {
            final map = maps[index];
        
            final image = map['image'];
            final title = map['title'];
        
            String fileId = image.split('/d/')[1].split('/')[0];
            String imageLink = 'https://drive.google.com/uc?export=view&id=$fileId';
        
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Imagefullview(
                      imageUrl: imageLink,
                      tag: 'image_$index',
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  // Map categories
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      side: const BorderSide(
                        color: Colors.black,  // Border color
                        width: 2,  // Border width
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'image_$index',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageLink,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    timeDilation = 1.0;     // Reset timeDilation when the widget is disposed
    super.dispose();
  }
}