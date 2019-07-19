import 'package:geo/geo.dart';

import 'point.dart';
import 'pollutant.dart';
import 'transport.dart';

import '../../repository/repository.dart';

class Train extends Transport implements Pollutant {
  String name;

  String origin;
  String destination;

  Train(
    {
      this.name, 
      this.origin, 
      this.destination, 
      double co2 = 0.028,
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
    final orig = Repository.trainToPoint[origin];
    final dest = Repository.trainToPoint[destination];
    //1.05 is for route not straight line
    return 1.05 * computeDistanceBetween(LatLng(orig.lat, orig.lng), LatLng(dest.lat, dest.lng)) / 1000.0;
  }

  //very rough calculations
  //0.028 kg of CO2 for average train
  //100 passengers
  //80% of seats taken
  @override
  double co2Pollution(int peopleCount) {
    return (co2 * distance()) / (100 * 0.8 + peopleCount);
  }

  @override
  double co2Saving(int peopleCount) {
    return(co2 * distance()) / (100 * 0.8 + 1) - co2Pollution(peopleCount) ;
  }

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
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