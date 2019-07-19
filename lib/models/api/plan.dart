import 'dart:math';
import 'transport.dart';
import 'accomodation.dart';

class Plan {
  String origin;
  String destination;

  Transport transport;
  Transport transitTo;
  Transport transitFrom;

  Accomodation accomodation;

  int days;
  int peopleCount;
  DateTime date;

  Plan();

  double co2() {
    return (transport?.co2Pollution(peopleCount) ?? 0) + 
          (transitTo?.co2Pollution(peopleCount) ?? 0) + 
          (transitFrom?.co2Pollution(peopleCount) ?? 0);
  }

  double co2Saving() {
    final total = (transport?.co2Saving(peopleCount) ?? 0) +
                  (transitTo?.co2Saving(peopleCount) ?? 0) +
                  (transitFrom?.co2Saving(peopleCount) ?? 0);
    return total;
  }

  double money() {
    final total = (transport?.money(peopleCount) ?? 0) + 
                  (transitTo?.money(peopleCount) ?? 0) + 
                  (transitFrom?.money(peopleCount) ?? 0) + 
                  (accomodation?.money(peopleCount) ?? 0) * days;
    return total;
  }

  double moneySaving() {
    final total = (transport?.moneySaving(peopleCount) ?? 0) + 
                  (transitTo?.moneySaving(peopleCount) ?? 0) + 
                  (transitFrom?.moneySaving(peopleCount) ?? 0) + 
                  (accomodation?.moneySaving(peopleCount) ?? 0);
    return total;
  }

  bool isValid() {
    return origin != null && destination != null && date != null && peopleCount != null && days != null;
  }
}