import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Luckydraw extends StatefulWidget {
  const Luckydraw({super.key});

  @override
  _LuckydrawState createState() => _LuckydrawState();
}

class _LuckydrawState extends State<Luckydraw> {
  // final List<String> images = [
  //   'assets/image/lucky_draw_pic1.jpeg',
  //   'assets/image/lucky_draw_pic3.jpeg',
  //   'assets/image/stem.jpg',
  // ];

  List<Map<String, dynamic>> posters = [];
  List<Map<String, dynamic>> rules = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var database = FirebaseFirestore.instance;

    var postersData = <Map<String, dynamic>>[];
    var rulesData = <Map<String, dynamic>>[];

    // Fetch both collections in parallel
    final postersFuture = database.collection("stem_lucky_draw_posters").get();
    final rulesFuture = database.collection("stem_lucky_draw_rules").get();

    // Wait for both operations to complete
    final results = await Future.wait([postersFuture, rulesFuture]);

    // Extract data from both results
    postersData = results[0].docs.map((doc) => doc.data()).toList();
    rulesData = results[1].docs.map((doc) => doc.data()).toList();

    // Update the state with new data
    setState(() {
      posters = postersData;
      rules = rulesData;
    });
  }

  // final List<String> rules = [
  //   '1. By participating in the lucky draw, you agree to be bound by these terms and conditions.',
  //   '2. Participants must have a valid registration to enter.',
  //   '3. Only one entry per person is allowed.',
  //   '4. No purchase is necessary to enter or win.',
  //   '5. The prize(s) for the lucky draw is/are attached in the posters above.',
  //   '6. The winner(s) will be selected by a random draw from all the valid entries received by the closing date.',
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: posters.length,
                itemBuilder: (context, index) {
                  final poster = posters[index];

                  final image = poster['image'];
              
                  String fileId = image.split('/d/')[1].split('/')[0];
                  String imageLink = 'https://drive.google.com/uc?export=view&id=$fileId';
              
                  return Container(
                    margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10), 
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), 
                      child: SizedBox(
                        width: 300,
                        height: 370,
                        child: Image.network(
                          imageLink,
                          fit: BoxFit.contain, // Fit the image without cropping
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                  margin:
                      const EdgeInsets.only(top: 40, left: 25, bottom: 10),
                  child: const Text(
                    'Lucky Draw Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 25, bottom: 20),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    final rule = rules[index];
                
                    return Text(
                        '- ${rule['rule']}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
              ),
            ]
            
            // ListView(
            //   children: [
            //     ...images
            //         .map(
            //           (imagePath) => Container(
            //             margin: EdgeInsets.only(top: 20, right: 20, left: 20),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: Colors.black,
            //                 width: 1.0,
            //               ),
            //               borderRadius: BorderRadius.circular(10), 
            //             ),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(10), 
            //               child: SizedBox(
            //                 width: 300,
            //                 height: 370,
            //                 child: Image.asset(
            //                   imagePath,
            //                   fit: BoxFit.contain, // Fit the image without cropping
            //                 ),
            //               ),
            //             ),
            //           ),
            //         )
            //         .toList(),
            //     Container(
            //       child: const Text(
            //         'Rules',
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       margin:
            //           EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 10),
            //     ),
            //     ...rules
            //         .map(
            //           (rule) => Container(
            //             margin: EdgeInsets.only(right: 20, left: 20),
            //             child: Text(
            //               rule,
            //               style: TextStyle(
            //                 fontSize: 15,
            //               ),
            //             ),
            //           ),
            //         )
            //         .toList(),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       body: Center(
  //         child: ListView(
  //           children: [
  //             ...images
  //                 .map(
  //                   (imagePath) => Container(
  //                     margin: EdgeInsets.only(top: 20, right: 20, left: 20),
  //                     decoration: BoxDecoration(
  //                       border: Border.all(
  //                         color: Colors.black,
  //                         width: 1.0,
  //                       ),
  //                       borderRadius: BorderRadius.circular(10), 
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(10), 
  //                       child: SizedBox(
  //                         width: 300,
  //                         height: 370,
  //                         child: Image.asset(
  //                           imagePath,
  //                           fit: BoxFit.contain, // Fit the image without cropping
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //             Container(
  //               child: const Text(
  //                 'Rules',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               margin:
  //                   EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 10),
  //             ),
  //             ...rules
  //                 .map(
  //                   (rule) => Container(
  //                     margin: EdgeInsets.only(right: 20, left: 20),
  //                     child: Text(
  //                       rule,
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
