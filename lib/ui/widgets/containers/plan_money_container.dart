import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../resources/app_colors.dart';

import '../../dialogs/dialogs.dart';

import '../../../models/api/plan.dart';
import '../../../models/api/flight.dart';
import '../../../models/api/bus.dart';
import '../../../models/api/train.dart';
import '../../../models/api/transport.dart';

class PlanMoneyContainer extends StatelessWidget {

  final Plan plan;
  final double width;

  PlanMoneyContainer({this.plan, this.width});

  Color lerp() {
    double x = plan.co2() / 100000;
    return Color.fromARGB(255, (2 * x * 255).toInt(), 255 * (2 * (1 - x)).toInt(), 0);
  }

  String transportName(Transport transport) {
    if (transport is Flight) {
      return 'Flight';
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
                Text('Trip cost',
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
                      'Money saving is calculated how much money companies could save if they cooperate and send workers together in comparison to situation when each worker is traveling alone.', 
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
                   color: Colors.yellow,         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/price.png'),
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
                    Text('Cost: ${plan.money().toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),
                    ),
                     Text('Money saving: ${plan.moneySaving().toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),
                    ),
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
                   color: Colors.greenAccent,         
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
                    Text('${transportName(plan.transport)} cost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Cost: ${plan.transport.price.toStringAsFixed(2)} x ${plan.peopleCount} = ${plan.transport.money(plan.peopleCount).toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Money saving: ${plan.transport.moneySaving(plan.peopleCount).toStringAsFixed(2)}\$',
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
          //Padding(padding: EdgeInsets.only(top: 5)),
          plan.accomodation == null ? 
          Container() : 
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.2 * 0.18,
                height: width * 0.2 * 0.18,
                 decoration: BoxDecoration(         
                   color: Colors.blueAccent,         
                   borderRadius: BorderRadius.all(Radius.circular(10)),             
                 ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(                  
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/hotel.png'),
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
                    Text('Accomodation cost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Cost: ${plan.accomodation.price.toStringAsFixed(2)} x ${plan.peopleCount} x ${plan.days} days = ${(plan.accomodation.money(plan.peopleCount) * plan.days).toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Money saving: ${plan.accomodation.moneySaving(plan.peopleCount).toStringAsFixed(2)}\$',
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
                   color: Colors.redAccent,         
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
                    Text('Transfer cost (departure)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Cost: ${plan.transitTo.price} x ${plan.peopleCount} = ${plan.transitTo.money(plan.peopleCount).toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Money saving: ${plan.transitTo.moneySaving(plan.peopleCount).toStringAsFixed(2)}\$',
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
                   color: Colors.blueGrey,         
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
                    Text('Transfer cost (arrival)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Cost: ${plan.transitFrom.price} x ${plan.peopleCount} = ${plan.transitFrom.money(plan.peopleCount).toStringAsFixed(2)}\$ ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                    ),
                    Text('Money saving: ${plan.transitFrom.moneySaving(plan.peopleCount).toStringAsFixed(2)}\$',
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