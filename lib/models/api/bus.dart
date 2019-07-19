import 'package:geo/geo.dart';

import 'point.dart';
import 'pollutant.dart';
import 'transport.dart';

import '../../repository/repository.dart';

class Bus extends Transport implements Pollutant {
  String name;

  String origin;
  String destination;

  Bus(
    {
      this.name, 
      this.origin, 
      this.destination, 
      double co2 = 0.82,
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
  );

  double distance() {
    final orig = Repository.cityToPoint[origin];
    final dest = Repository.cityToPoint[destination];
    //1.1 is for route not straight line
    return 1.1 * computeDistanceBetween(LatLng(orig.lat, orig.lng), LatLng(dest.lat, dest.lng)) / 1000.0;
  }

  //very rough calculations
  //0.82 kg of CO2 for average touristic bus
  //45 passengers
  //75% of seats taken
  @override
  double co2Pollution(int peopleCount) {
    return (co2 * distance()) / (45 * 0.75 + peopleCount);
  }

  @override
  double co2Saving(int peopleCount) {
    return(co2 * distance()) / (45 * 0.75 + 1) - co2Pollution(peopleCount) ;
  }

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      name: json['name'],
      price: double.parse(json['price']),
      currency: json['currency'] ?? 'USD',
      origin: json['origin'],
      destination: json['destination'],
      departureAt: DateTime.parse(json['departure_at']),
      arrivalAt: DateTime.parse(json['arrival_at']),
    );
  }
}