import 'package:flutter/material.dart';
import 'package:lab3/bird_list.dart';
import 'package:lab3/my_sightings.dart';

class FooterWidget extends StatelessWidget {
  final bool isOnHomePage;
  const FooterWidget({super.key, required this.isOnHomePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.purple[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40.0,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) => isOnHomePage ? const MySightingsScreen() : const BirdListScreen())));
            },
            child: isOnHomePage ? 
            Row(
              spacing: 10.0,
              children: [
                Icon(
                  size: 22.0,
                  color: Colors.white,
                  Icons.remove_red_eye,
                ),
                Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0
                  ),
                  'My Sightings'
                ),
              ],
            )
            : 
            Row(
              spacing: 10.0,
              children: [
                Icon(
                  size: 22.0,
                  color: Colors.white,
                  Icons.home,
                ),
                Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0
                  ),
                  'Home'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}