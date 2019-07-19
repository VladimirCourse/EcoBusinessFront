import 'dart:math';

import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../resources/app_colors.dart';

import '../../dialogs/dialogs.dart';

import '../../../models/api/plan.dart';
import '../../../models/api/flight.dart';
import '../../../models/api/bus.dart';
import '../../../models/api/train.dart';
import '../../../models/api/transport.dart';


class PlanEcoContainer extends StatelessWidget {

  final Plan plan;
  final double width;

  PlanEcoContainer({this.plan, this.width});

  Color lerp(double co2) {
    // 11.0 - average co2 for person for 1 day
    co2 = max(min((co2 / 11.0), 1), 0);
    if (co2 > 0.3 && co2 < 0.5) {
      return Colors.yellow.withRed((255 * co2).toInt());
    } else if (co2 >= 0.5 && co2 < 0.7) {
      return Colors.yellow.withGreen((255 * co2).toInt());
    } else {
      return Color.lerp(Colors.red, Colors.green, 1 - co2);
    }
  }

  String transportName(Transport transport) {
    if (transport is Flight) {
      return 'Aircraft';
    } else if (transport is Bus) {
      return 'Bus';
    } else if (transport is Train) {
      return 'Train';
    } else {
      return 'Car';
    }
  }

  String transportIcon(Transport transport) {
    if (transport is Flight) {
      return 'images/flight.png';
    } else if (transport is Bus) {
      return 'images/bus.png';
    } else if (transport is Train) {
      return 'images/train.png';
    } else {
      return 'images/car.png';
    }
  }

  Widget build(BuildContext context) { 
    return Container(
      width: width,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Impact per person',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () {
                    Dialogs.showMessage(context, 
                      'Info', 
                      'Enviromental impact is calculated for each person in trip. \nCO2 is sum of emissions of each transport used.\nCO2 saving is how much CO2 will not be emited for each person in comparison to situation when each worker is traveling alone.', 
                      'OK'
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle
                    ),
                    child: Text('i',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                      )
                    )
                  )
                )
              ]
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.2 * 0.22,
                height: width * 0.2 * 0.22,
                 decoration: BoxDecoration(         
                   color: lerp(plan.co2()),         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/eco.png'),
                      ),
                    ),
                  )
                )
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CO2: ${plan.co2().toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),
                    ),
                    Text('CO2 saving: ${plan.co2Saving().toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),
                    )
                  ]
                )
              )
            ]
          ),
          plan.transport == null ? 
          Container() : 
          Container(
            padding: EdgeInsets.only(bottom: 7, top: 15),
            child: Text('Details',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
          ),
          plan.transport == null ? 
          Container() : 
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.2 * 0.18,
                height: width * 0.2 * 0.18,
                 decoration: BoxDecoration(         
                   color: lerp(plan.transport.co2Pollution(plan.peopleCount)),         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(transportIcon(plan.transport)),
                      ),
                    ),
                  )
                )
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text('${transportName(plan.transport)} pollution per person',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14
                            ),
                          ),
                        ]
                      )
                    ),
                    Text('CO2: ${plan.transport.co2Pollution(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('CO2 saving: ${plan.transport.co2Saving(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    )
                  ]
                )
              )
            ]
          ),
          plan.transitTo == null ? 
          Container() : 
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.2 * 0.18,
                height: width * 0.2 * 0.18,
                 decoration: BoxDecoration(         
                   color: lerp(plan.transitTo.co2Pollution(plan.peopleCount)),         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(transportIcon(plan.transitTo)),
                      ),
                    ),
                  )
                )
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transportName(plan.transitTo)} pollution per person (departure)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('CO2: ${plan.transitTo.co2Pollution(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('CO2 saving: ${plan.transitTo.co2Saving(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    )
                  ]
                )
              )
            ]
          ),
          plan.transitFrom == null ? 
          Container() : 
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.2 * 0.18,
                height: width * 0.2 * 0.18,
                 decoration: BoxDecoration(         
                   color: lerp(plan.transitFrom.co2Pollution(plan.peopleCount)),         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(transportIcon(plan.transitFrom)),
                      ),
                    ),
                  )
                )
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transportName(plan.transitFrom)} pollution per person (arrival)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('CO2: ${plan.transitFrom.co2Pollution(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('CO2 saving: ${plan.transitFrom.co2Saving(plan.peopleCount).toStringAsFixed(2)} kg',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    )
                  ]
                )
              )
            ]
          ),
        ]
      )
    );
  }
}