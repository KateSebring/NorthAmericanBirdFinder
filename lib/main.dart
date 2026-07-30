import 'dart:convert';
import 'package:flutter/material.dart';
import './bird_page.dart';
import './bird.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'North American Bird Finder',
      home: BirdListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BirdListScreen extends StatefulWidget {
  const BirdListScreen({super.key});

  @override
  State<BirdListScreen> createState() => _BirdListScreenState();
}

class _BirdListScreenState extends State<BirdListScreen> {
  late Future<List<Bird>> _birdData;
  String _searchQuery = '';

  Future<List<Bird>> loadBirdData(BuildContext context) async {
    final String jsonString = await DefaultAssetBundle.of(context).loadString('assets/bird_data.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => Bird.fromJson(json)).toList();
  }

  @override
  void initState() {
    _birdData = loadBirdData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('North American Bird Finder'),
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: SearchBar(
                hintText: 'Search by name...',
                leading: Icon(Icons.search),
                constraints: BoxConstraints(
                  maxWidth: 300.0,
                  minHeight: 50.0,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  // do something
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Bird>> (
              future: _birdData, 
              builder: (
                (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if(snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final List<Bird> filteredBirds;

                  if(_searchQuery.isEmpty) {
                    filteredBirds = snapshot.data ?? [];
                  } else {
                    filteredBirds = snapshot.data?.where((bird) => bird.commonName.toLowerCase().contains(_searchQuery.toLowerCase()) || bird.species.toLowerCase().contains(_searchQuery.toLowerCase()) ).toList() ?? [];
                  }

                  return ListView.builder(
                    itemCount: filteredBirds.length,
                    itemBuilder: ((context, index) {
                      final bird = filteredBirds[index];
                      return ListTile(
                        leading: Text(
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          '🐦'
                        ),
                        title: Text(bird.commonName),
                        subtitle: Text(
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                          bird.species
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualBirdScreen(bird: filteredBirds[index]),
                            ),
                          );
                        },
                      );
                    }),
                  );
                }
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.purple[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 40.0,
              children: [
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}