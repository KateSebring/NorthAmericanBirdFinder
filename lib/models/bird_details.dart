import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab3/models/bird.dart';

class BirdDetails {
  final Bird bird;
  final String? imageUrl;
  final String? description;

  BirdDetails({
    required this.bird,
    required this.imageUrl,
    required this.description
  });

  void operator [](String other) {}
}