class Point {
  String id;

  String googleId;

  String address;
  String city;
  
  double lat;
  double lng;
  
  Point({this.id, this.address, this.lat, this.lng, this.googleId, this.city});

  Map <String, dynamic> toJson(){
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
      'city': city
    };
  }

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}