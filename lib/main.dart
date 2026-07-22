import 'package:flutter/material.dart';

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> regionOptions = ['CA', 'US', 'MX'];
  List<String> subregionOptions = ['Alaska', 'Another option', 'etc'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('North American Bird Finder'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              DropdownButton(
                items: regionOptions.map((String region) {
                  return DropdownMenuItem<String>(
                    value: region,
                    child: Text(region),
                  );
                }).toList(), 
                onChanged: (value) {
                  // do something
                }
              ),
              DropdownButton(
                items: subregionOptions.map((String subregion) {
                  return DropdownMenuItem<String>(
                    value: subregion,
                    child: Text(subregion),
                  );
                }).toList(), 
                onChanged: (value) {
                  // do something
                }
              ),
              SearchBar(
                hintText: 'Search by name...',
                leading: Icon(Icons.search),
                onChanged: (value) {
                  // do something
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}