import 'package:flutter/material.dart';
import 'package:lab3/models/sighting.dart';

class SightingsProvider with ChangeNotifier {
  final List<Sighting> _mySightings = [];

  List<Sighting> get mySightings => _mySightings;

  void addSighting(Sighting newSighting) {
    _mySightings.add(newSighting);
    notifyListeners();
  }

  void removeSighting(Sighting sighting) {
    _mySightings.remove(sighting);
  }
}