class Airport {
  String id;
  String name;
  String city;
  String iata;

  double lat;
  double lng;
  
  Airport({this.id, this.name, this.city, this.iata, this.lat, this.lng});

  Map <String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'city': city,
      'iata': iata
    };
  }

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      iata: json['iata']
    );
  }
}