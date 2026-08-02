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

  factory BirdDetails.fromJson(Map<String, dynamic> json) {
    return BirdDetails(
      bird: Bird.fromJson(json['bird'] as Map<String, dynamic>), 
      imageUrl: json['imageUrl'], 
      description: json['description']
    );
  }
}