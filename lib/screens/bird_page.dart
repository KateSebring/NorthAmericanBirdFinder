import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab3/models/sighting.dart';
import 'package:lab3/sightings_provider.dart';
import 'package:provider/provider.dart';
import '../models/bird.dart';
import '../models/bird_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IndividualBirdScreen extends StatefulWidget {
  final Bird bird;

  const IndividualBirdScreen({super.key, required this.bird});

  @override
  State<IndividualBirdScreen> createState() => _IndividualBirdScreenState();
}

class _IndividualBirdScreenState extends State<IndividualBirdScreen> {
  late Future<BirdDetails> birdDetails;

  Future<BirdDetails> loadBirdDetails(Bird bird) async {
    final imageUrl = await fetchBirdImage(bird.species);
    final description = await fetchWikipediaBlurb(bird.species);

    return BirdDetails(
      bird: bird, 
      imageUrl: imageUrl, 
      description: description!['description'],
    );
  }

  Future<Map<String, String>?> fetchWikipediaBlurb(String species) async {
    final query = Uri.encodeComponent(species).replaceAll(" ", "_");
    final url = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$query');

    final response = await http.get(url);
    
    if(response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);

    return {
      'description': data['extract'] ?? '',
    };
  }

  Future<String?> fetchBirdImage(String species) async {
    final encodedName = Uri.encodeComponent(species);

    final url = Uri.parse(
      'https://commons.wikimedia.org/w/api.php'
      '?action=query'
      '&generator=search'
      '&gsrsearch=$encodedName'
      '&gsrnamespace=6'
      '&gsrlimit=10'
      '&prop=imageinfo'
      '&iiprop=url'
      '&format=json'
      '&origin=*'
    );

    final response = await http.get(url);

    if(response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);

    final pages = data['query']?['pages'];

    if(pages == null || pages.isEmpty) {
      return null;
    }

    for (final page in pages.values) {
      final imageInfo = page['imageinfo'];

      if(imageInfo != null && imageInfo.isNotEmpty) {
        return imageInfo[0]['url'];
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    birdDetails = loadBirdDetails(widget.bird);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bird.commonName),
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<BirdDetails>(
        future: birdDetails, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'),);
          }

          final details = snapshot.data;

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.0,),
                  if(details!.imageUrl != null && details.imageUrl!.isNotEmpty) 
                    CachedNetworkImage(
                      imageUrl: details.imageUrl!,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: ((context, url) => const Center(
                        child: SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: CircularProgressIndicator(),
                        ),
                      ))
                    )
                  else
                    const Text('No image available'),
                  Text(
                    widget.bird.commonName,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.bird.species,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  Text(
                    'Order: ${widget.bird.order}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Family: ${widget.bird.family}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Genus: ${widget.bird.genus}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0,),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showSightingDialog(context);
                    }, 
                    child: Text('Add to My Sightings')
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                    child: Text(
                      details.description ?? 'No description available.',
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
  
  void _showSightingDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        TextEditingController txtLocation = TextEditingController();
        TextEditingController txtDate = TextEditingController();
        return AlertDialog(
          title: Text('Log Sighting for ${widget.bird.commonName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtLocation,
                decoration: InputDecoration(
                  labelText: 'Location Sighted',
                ),
              ),
              TextField(
                controller: txtDate,
                decoration: InputDecoration(
                  labelText: 'Date Sighted',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String location = txtLocation.text;
                String date = txtDate.text;
                Sighting newSighting = Sighting(commonName: widget.bird.commonName, species: widget.bird.species, location: location, date: date);
                Provider.of<SightingsProvider>(context, listen: false).addSighting(newSighting);
                
                final mainContext = context;

                Navigator.pop(context);

                ScaffoldMessenger.of(mainContext).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white,),
                        SizedBox(width: 12,),
                        Text(
                          'Sighting for ${widget.bird.commonName} added!',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.purple[800],
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: 70.0,
                      left: 50.0,
                      right: 50.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }, 
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text('Cancel'),
            ),
          ],
        );
      }
    );
  }
}