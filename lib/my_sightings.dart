import 'package:flutter/material.dart';
import 'package:lab3/footer.dart';
import './models/sighting.dart';

class MySightingsScreen extends StatefulWidget {
  const MySightingsScreen({super.key});

  @override
  State<MySightingsScreen> createState() => _MySightingsScreenState();
}

class _MySightingsScreenState extends State<MySightingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Sightings'),
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        spacing: 12.0,
        children: [
          // list birds in sightings list
          // add ability to swipe out
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('🪶'),
                  title: Text('Common Name | Scientific Name'),
                  subtitle: Text('Location'),
                );
              }
            ),
          ),
          FooterWidget(isOnHomePage: false),
        ],
      ),
    );
  }
}