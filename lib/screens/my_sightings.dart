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
          Consumer<SightingsProvider>(
            builder: (context, sightingsData, child) {
              if(sightingsData.mySightings.isEmpty) {
                return Center(
                  child: Expanded(
                    child: Text('No sightings found.')
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: sightingsData.mySightings.length,
                  itemBuilder: ((context, index) {
                    final sighting = sightingsData.mySightings[index];
                    return Dismissible(
                      key: ValueKey('${sighting.species}_$index'),
                      onDismissed: (direction) {
                        sightingsData.removeSighting(sighting);
                      },
                      child: ListTile(
                        leading: Text('🪶'),
                        title: Text('${sighting.commonName} | ${sighting.species}'),
                        subtitle: Text('Seen ${sighting.date} | Location: ${sighting.location}'),
                      ),
                    );
                  })
                )
              );
            },
          ),
          FooterWidget(isOnHomePage: false),
        ],
      ),
    );
  }
}