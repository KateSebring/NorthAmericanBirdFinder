import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab3/models/bird.dart';
import 'package:lab3/models/sighting.dart';
import 'package:lab3/screens/bird_page.dart';
import 'package:lab3/sightings_provider.dart';
import 'package:lab3/widgets/footer.dart';
import 'package:provider/provider.dart';

class MySightingsScreen extends StatelessWidget {
  const MySightingsScreen({super.key});

  Future<List<dynamic>> _loadBirdData(BuildContext context) async {
    final String jsonString = await DefaultAssetBundle.of(context).loadString('assets/bird_data.json');
    return jsonDecode(jsonString);
  }

  Bird? findBirdInfo(List<dynamic> jsonList, String speciesToFind) {
    try {
      final birdMap = jsonList.firstWhere(
        (element) => element['species'].toString().toLowerCase() == speciesToFind.toLowerCase()
      );

      if (birdMap == null) return null;

      return Bird.fromJson(birdMap);
    } catch (e) {
      return null;
    }
  }

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
            child: Consumer<SightingsProvider>(
              builder: (context, sightingsData, child) {
                if(sightingsData.mySightings.isEmpty) {
                  return Center(
                    child: Text('No sightings found.')
                  );
                }

                return FutureBuilder<List<dynamic>>(
                  future: _loadBirdData(context), 
                  builder: ((context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final birdList = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: sightingsData.mySightings.length,
                      itemBuilder: ((context, index) {
                        final sighting = sightingsData.mySightings[index];
                        return Dismissible(
                          key: ValueKey('${sighting.species}_$index'),
                          onDismissed: (direction) {
                            sightingsData.removeSighting(sighting);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white,),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Sighting for ${sighting.commonName} removed.',
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
                          child: ListTile(
                            leading: Text('🪶'),
                            title: Text('${sighting.commonName} | ${sighting.species}'),
                            subtitle: Text('Seen ${sighting.date} | Location: ${sighting.location}'),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final Sighting? updatedSighting = await showDialog<Sighting>(
                                  context: context, 
                                  builder: (BuildContext context) {
                                    TextEditingController txtDate = TextEditingController(text: sighting.date);
                                    TextEditingController txtLocation = TextEditingController(text: sighting.location);

                                    return AlertDialog(
                                      title: Text('Edit Sighting for ${sighting.commonName}'),
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
                                        TextButton(
                                          onPressed: () {
                                            String newLocation = txtLocation.text;
                                            String newDate = txtDate.text;
                                            final newSighting = Sighting(
                                              commonName: sighting.commonName, 
                                              species: sighting.species, 
                                              location: newLocation, 
                                              date: newDate,
                                            );
                                            Navigator.of(context).pop(newSighting);
                                          }, 
                                          child: Text('Save'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }, 
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    );

                                    
                                  }
                                );
                                if(updatedSighting != null && context.mounted) {
                                  Provider.of<SightingsProvider>(context, listen: false)
                                    .updateSighting(index, updatedSighting);
                                }
                              },
                            ),
                            onTap: () async {
                              Bird? sightedBird = findBirdInfo(birdList, sighting.species);

                              sightedBird ??= Bird(
                                commonName: sighting.commonName, 
                                species: sighting.species, 
                                genus: 'Unknown', 
                                order: 'Unknown', 
                                family: 'Unknown',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualBirdScreen(bird: sightedBird!),
                                ),
                              );
                            },
                          ),
                        );
                      })
                    );
                  })
                );
              },
            ),
          ),
          ),
          FooterWidget(isOnHomePage: false),
        ],
      ),
    );
  }
}