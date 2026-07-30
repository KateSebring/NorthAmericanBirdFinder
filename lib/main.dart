import 'package:flutter/material.dart';
import 'package:lab3/screens/bird_list.dart';
import 'package:lab3/sightings_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => SightingsProvider(),
    child: MyApp(),
  ));
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

