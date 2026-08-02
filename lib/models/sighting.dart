class Sighting {
  String commonName;
  String species;
  String location;
  String date;

  Sighting({required this.commonName, required this.species, required this.location, required this.date});

  Map<String, dynamic> toJson() => {
    'commonName': commonName,
    'species': species,
    'location': location,
    'date': date,
  };

  factory Sighting.fromJson(Map<String, dynamic> json) {
    return Sighting(
      commonName: json['commonName'], 
      species: json['species'], 
      location: json['location'], 
      date: json['date']
    );
  }
}