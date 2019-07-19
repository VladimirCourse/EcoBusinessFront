import 'package:geo/geo.dart';

import 'pollutant.dart';
import 'transport.dart';

import '../../repository/repository.dart';

class Flight extends Transport implements Pollutant {
  String name;

  String origin;
  String destination;
  
  Flight(
    {
      this.name,  
      this.origin, 
      this.destination,
      double co2 = 23.3,
      double price,
      String currency,
      DateTime departureAt,
     // DateTime arrivalAt
    }
  ) : 
  super (
    price: price,
    currency: currency,
    departureAt: departureAt,
    //arrivalAt: arrivalAt,
    co2: co2
  );

  double distance() {
    final orig = Repository.airportToPoint[origin];
    final dest = Repository.airportToPoint[destination];
    return computeDistanceBetween(LatLng(orig.lat, orig.lng), LatLng(dest.lat, dest.lng)) / 1000.0;
  }

  //very rough calculations
  //23.3 kg of CO2 for Boeing 737 per 1 km
  //189 passengers
  //70% of seats taken
  @override
  double co2Pollution(int peopleCount) {
    return (co2 * distance()) / (189 * 0.7 + peopleCount);
  }

  @override
  double co2Saving(int peopleCount) {
    return(co2 * distance()) / (189 * 0.7 + 1) - co2Pollution(peopleCount) ;
  }

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      currency: json['currency'] ?? 'USD',
      name: json['gate'],
      price: json['value'],
      origin: json['origin'],
      destination: json['destination'],
      departureAt: DateTime.parse(json['depart_date']),
    );
  }
}