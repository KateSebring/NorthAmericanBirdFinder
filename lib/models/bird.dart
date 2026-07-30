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
}