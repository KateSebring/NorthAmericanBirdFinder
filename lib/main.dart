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
      debugShowCheckedModeBanner: false,
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
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 20.0,
                children: [
                  DropdownButton(
                    value: regionOptions.first,
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
                    value: subregionOptions.first,
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
                    constraints: BoxConstraints(
                      maxWidth: 300.0,
                      minHeight: 50.0,
                    ),
                    onChanged: (value) {
                      // do something
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}