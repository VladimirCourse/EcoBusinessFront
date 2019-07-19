import 'dart:math';

class Accomodation {
  String name;
  String description;
  String address;


  double price;
  int capacity;

  String currency;

  double lat;
  double lng;
  double score;
  
  List <String> categories;

  Accomodation({
   this.name, 
   this.description, 
   this.address, 
   this.lat, 
   this.lng, 
   this.score, 
   this.price,
   this.capacity,
   this.currency,
   this.categories = const []}) {
     if (currency == 'RUB') {
       price /= 65;
       currency = '\$';
     } else if (currency == 'EUR') {
       price = (price * 1.2);
       currency = '\$';
     }
     this.capacity = (name?.length ?? 4) % 3 + 2;
   }

  int number(int peopleCount) {
    return peopleCount ~/ capacity + (peopleCount % capacity > 0 ? 1 : 0);
  }

  double co2Saving(int peopleCount) {
    return 1 / number(peopleCount);
  }

  double money(int peopleCount) {
    return price * number(peopleCount);
  }

  double moneySaving(int peopleCount) {
    return peopleCount * price - money(peopleCount);
  }
  
  factory Accomodation.fromJson(Map<String, dynamic> json) {
    return Accomodation(
      name: json['name'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      score: json['score'],
      price: json['price'],
      currency: json['currency'],
    );
  }
}