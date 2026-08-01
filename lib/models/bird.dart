class Bird {
  String species;
  String commonName;
  String order;
  String family;
  String genus;

  Bird({required this.species, required this.commonName, required this.order, required this.family, required this.genus});

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      species: json['species'],
      commonName: json['common_name'],
      order: json['order'],
      family: json['family'],
      genus: json['genus'],
    );
  }

  String get eBirdCode {
    final List<String> parts = species.trim().toLowerCase().split(' ');

    if(parts.length < 2) {
      return species.length >= 6 ? species.substring(0, 6).toLowerCase() : species.toLowerCase();
    }

    final String genusPart = parts[0];
    final String speciesPart = parts[1];

    final String genusCode = genusPart.length >= 3 ? genusPart.substring(0, 3) : genusPart;
    final String speciesCode = speciesPart.length >= 3 ? speciesPart.substring(0, 3) : speciesPart;

    return '$genusCode$speciesCode';
  }
}