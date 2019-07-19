import 'package:geo/geo.dart';

import 'point.dart';
import 'pollutant.dart';
import 'transport.dart';

class Car extends Transport implements Pollutant {
  String id;
  String name;

  int capacity;

  Point origin;
  Point destination;

  Car(
    {
      this.id, 
      this.name, 
      this.capacity, 
      double co2,
      double price,
      String currency,
      DateTime departureAt,
      DateTime arrivalAt
    }
  ) : 
  super (
    price: price,
    currency: currency,
    departureAt: departureAt,
    arrivalAt: arrivalAt,
    co2: co2
  ) {
  }

  double distance() {
    //1.2 is for route not straight line
    return 1.2 * computeDistanceBetween(LatLng(origin.lat, origin.lng), LatLng(destination.lat, destination.lng)) / 1000.0;
  }

  int number(int peopleCount) {
    return peopleCount ~/ capacity + (peopleCount % capacity > 0 ? 1 : 0);
  }

  @override
  double co2Pollution(int peopleCount) {
    return (co2 * distance() * number(peopleCount)) / peopleCount;
  }

  @override
  double co2Saving(int peopleCount) {
    return 1 / number(peopleCount);
  }

  @override
  double money(int peopleCount) {
    return price * number(peopleCount) * distance();
  }

  @override
  double moneySaving(int peopleCount) {
    return peopleCount * price * distance() - money(peopleCount);
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      price: json['price'],
      capacity: json['capacity'],
      currency: json['currency'],
      co2: json['capacity'] == 4 ? 0.09 : 0.125
    );
  }
}