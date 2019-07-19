import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../../models/api/car.dart';


class CarContainer extends StatelessWidget {

  final Car car;

  CarContainer({this.car});

  Widget build(BuildContext context) { 
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${car.money(1).toStringAsFixed(2)}\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
                Text('per 1 car',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text('Origin: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                        ),
                      ),
                      Text(car.origin.address,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text('Destination: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                        ),
                      ),
                      Text(car.destination.address,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text('Capacity: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14
                        ),
                      ),
                      Text('${car.capacity} people',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14
                        ),
                      ),
                    ]
                  )
                )
              ]
            ),
          ),    
        ],
      ),
    );
  }
}