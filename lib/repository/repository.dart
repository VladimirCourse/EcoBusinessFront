import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:open_code_front/models/api/accomodation.dart';

import '../models/api/flight.dart';
import '../models/api/airport.dart';
import '../models/api/train.dart';
import '../models/api/bus.dart';
import '../models/api/plan.dart';
import '../models/api/car.dart';
import '../models/api/point.dart';


class Repository {
  //lot of hardcode
  //not enough time
  //no good apis to search buses and trains
  //stable for demo

  static Map<String, Point> airportToPoint = {
    'KZN': Point(
       lat: 55.796538, 
       lng: 49.1082,
       address: 'Kazan Airport'
    ),
    'MOW': Point(
       lat: 55.60315,
       lng: 37.2921,
       address: 'Vnukovo Airport'
    ),
    'HEL': Point(
       lat: 60.32, 
       lng: 24.96,
       address: 'Helsinki Airport'
    ),
    'WAW': Point(
      lat: 52.2296756, 
      lng: 21.0122287,
      address: 'Warsaw Airport'
    ),
    'BER': Point(
      lat: 52.559722, 
      lng: 13.287778,
      address: 'Berlin Airport'
    ),
    'PRG': Point(
      lat: 50.0878114, 
      lng: 14.4204598,
      address: 'Prague Airport'
    ),
    'LED': Point(
      lat: 59.939039, 
      lng: 30.315785,
      address: 'Saint Petersburg Airport'
    )
  };
  
  static Map<String, Point> trainToPoint = {
    'KZN': Point(
       lat: 55.78822,
       lng: 49.100069,
       address: 'Kazan Railway'
    ),
    'MOW': Point(
       lat: 55.773603,
       lng: 37.656759,
       address: 'Komsomlskaya square, 2'
    ),
    'HEL': Point(
       lat: 60.171873, 
       lng: 24.941422,
       address: 'Asema-aukio, Kaivokatu 1a'
    ),
    'WAW': Point(
      lat: 52.228873, 
      lng: 21.003168,
      address: 'al. Jerozolimskie 54'
    ),
    'BER': Point(
      lat: 52.525084,
      lng: 13.369402,
      address: 'Hauptbahnhof, Europaplatz 1'
    ),
    'PRG': Point(
      lat: 50.095721, 
      lng: 14.346082,
      address: 'Nádraží Veleslavín, 160'
    ),
    'LED': Point(
      lat: 59.919675, 
      lng: 30.3295,
      address: 'Zagorodnyy Prospekt, 52'
    )
  };

  static Map<String, Point> cityToPoint = {
    'KZN': Point(
       lat: 55.797128, 
       lng: 49.112287,
       address: 'Kazan, Russia'
    ),
    'MOW': Point(
       lat: 55.751414,
       lng: 37.617411,
       address: 'Moscow, Russia'
    ),
    'HEL': Point(
       lat: 60.168242, 
       lng: 24.938483,
       address: 'Helsinki, Finland'
    ),
    'WAW': Point(
      lat: 52.228318, 
      lng: 21.035013,
      address: 'Warsaw, Poland'
    ),
    'BER': Point(
      lat: 52.517199, 
      lng: 13.403105,
      address: 'Berlin, Germany'
    ),
    'PRG': Point(
      lat: 50.073990, 
      lng: 14.427959,
      address: 'Prague, Czech Republic'
    ),
    'LED': Point(
      lat: 59.929437, 
      lng: 30.321643,
      address: 'Saint Petersburg, Russia'
    )
  };

  static Map<String, String> iataToCity = {
    'KZN': 'Kazan, Russia',
    'MOW': 'Moscow, Russia',
    'LED': 'Saint Petersburg, Russia',
    'HEL': 'Helsinki, Finland',
    'WAW': 'Warsaw, Poland',
    'PRG': 'Prague, Czech Republic',
    'BER': 'Berlin, Germany',
  };

  static Map<String, List<String>> iataGraph = {
    'KZN' : [
      'MOW'
    ],
    'LED' : [
      'HEL'
    ],
    'HEL' : [
      'LED'
    ],
    'WAW' : [
      'PRG',
      'BER'
    ],
    'PRG' : [
      'BER'
    ],
  };

  static const String host = 'http://34.90.110.227:3001';

  static List<DateTime> dates = [
    DateTime(2019, 07, 27),
    DateTime(2019, 07, 28),
    DateTime(2019, 07, 29),
    DateTime(2019, 07, 30),
  ];

  static Future<List<Flight>> flights(String origin, String destination, DateTime date) async {
    final client = Client();
    final url = '${host}/planner/flights?origin=${origin}&destination=${destination}&date=${DateFormat('yyyy-MM-dd').format(date)}';
    final res = await client.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      List body = json.decode(res.body);
      List<Flight> result = [];
      for (var flight in body) {
        try {
          result.add(Flight.fromJson(flight));
        } catch (ex) {
          return [];
        }
      }
      return result;
    } else {
      return [];
    }
  }

  static Future<List<Bus>> buses(String origin, String destination, DateTime date) async {
    final client = Client();
    final url = '${host}/planner/buses?origin=${origin}&destination=${destination}&date=${DateFormat('yyyy-MM-dd').format(date)}';
    final res = await client.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      List body = json.decode(res.body);
      List<Bus> result = [];
      for (var flight in body) {
        try {
          result.add(Bus.fromJson(flight));
        } catch (ex) {
          return [];
        }
      }
      return result;
    } else {
      return [];
    }
  }

  static Future<List<Train>> trains(String origin, String destination, DateTime date) async {
    final client = Client();
    final url = '${host}/planner/trains?origin=${origin}&destination=${destination}&date=${DateFormat('yyyy-MM-dd').format(date)}';
    final res = await client.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      List body = json.decode(res.body);
      List<Train> result = [];
      for (var flight in body) {
        try {
          result.add(Train.fromJson(flight));
        } catch (ex) {
          print(ex);
          return [];
        }
      }
      return result;
    } else {
      return [];
    }
  }

  static Future<List<Car>> carsTransfer(String destination) async {
    final client = Client();
    final url = '${host}/planner/transfer/cars?destination=${destination}';
    final res = await client.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      List body = json.decode(res.body);
      List<Car> result = [];
      for (var flight in body) {
        try {
          result.add(Car.fromJson(flight));
        } catch (ex) {
          print(ex);
          return [];
        }
      }
      return result;
    } else {
      return [];
    }
  }


  static Future<List<Accomodation>> hotels(String destination, DateTime date, int days) async {
    final client = Client();
    final url = '${host}/planner/hotels?destination=${destination}&arrival=${DateFormat('yyyy-MM-dd').format(date)}&departure=${DateFormat('yyyy-MM-dd').format(date.add(Duration(days: 1)))}';
    final res = await client.get(Uri.encodeFull(url));
    if (res.statusCode == 200) {
      List body = json.decode(res.body);
      List<Accomodation> result = [];
      for (var flight in body) {
        try {
          result.add(Accomodation.fromJson(flight));
        } catch (ex) {
          print(ex);
          return [];
        }
      }
      return result;
    } else {
      return [];
    }
  }

}