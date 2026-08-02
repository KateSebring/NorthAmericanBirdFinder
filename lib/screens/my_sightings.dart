import 'package:flutter/material.dart';
import 'package:lab3/sightings_provider.dart';
import 'package:lab3/widgets/footer.dart';
import 'package:provider/provider.dart';

class MySightingsScreen extends StatelessWidget {
  const MySightingsScreen({super.key});

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
                  child: Text('No sightings found.'),
                );
              }

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
                      trailing: 
                      Icon(
                        Icons.edit,
                      ),
                    ),
                  );
                })
              );
            },
          ),
          ),
          FooterWidget(isOnHomePage: false),
        ],
      ),
    );
  }
}