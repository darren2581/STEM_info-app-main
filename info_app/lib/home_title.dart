import 'package:flutter/material.dart';

class HomeTitle extends StatefulWidget {
  final String title;

  const HomeTitle({super.key, required this.title});

  @override
  State<HomeTitle> createState() => _HomeTitleState();
}

class _HomeTitleState extends State<HomeTitle> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            // height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
                child: Text(
                  widget.title, 
                  style: const TextStyle(
                    height: 0.9,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ),
          ); 
  }
}