import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab3/models/sighting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SightingsProvider extends ChangeNotifier {
  List<Sighting> _mySightings = [];
  static const String _storageKey = 'user_bird_sightings';

  List<Sighting> get mySightings => _mySightings;

  SightingsProvider();

  Future<void> init() async {
    await _loadSightingsFromDisk();
  }

  Future<void> _loadSightingsFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? serializedList = prefs.getStringList(_storageKey);

    if(serializedList != null) {
      _mySightings = serializedList.map((item) {
        final Map<String, dynamic> decodedMap = jsonDecode(item);
        return Sighting.fromJson(decodedMap);
      }).toList();

      notifyListeners();
    }
  }

  Future<void> _saveSightingsToDisk() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> serializedList = _mySightings
      .map((sighting) => jsonEncode(sighting.toJson()))
      .toList();

    await prefs.setStringList(_storageKey, serializedList);
  }

  void addSighting(Sighting newSighting) {
    _mySightings.add(newSighting);
    notifyListeners();
    _saveSightingsToDisk();
  }

  void removeSighting(Sighting sighting) {
    _mySightings.remove(sighting);
    notifyListeners();
    _saveSightingsToDisk();
  }

  void updateSighting(int index, Sighting updatedSighting) {
    if(index >= 0 && index < _mySightings.length) {
      _mySightings[index] = updatedSighting;
      notifyListeners();
      _saveSightingsToDisk();
    }
  }
}