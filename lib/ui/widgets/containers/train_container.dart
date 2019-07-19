import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../../models/api/train.dart';

import '../../../repository/repository.dart';

class TrainContainer extends StatelessWidget {

  final Train train;

  TrainContainer({this.train});

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
                    Text(train.price.toStringAsFixed(2) + '\$',
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.black,
                        fontSize: 25
                      ),
                    ),
                    Text(train.name,
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.red.shade700,
                        fontSize: 20
                      ),
                    )
                  ],
                ),
                Text('1 passenger',
                  style: TextStyle(
                    fontFamily: 'Roboto-Light',
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14
                  ),
                ),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(DateFormat('HH:mm').format(train.departureAt),
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(DateFormat('dd.MM.yyyy').format(train.departureAt),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12
                    ),
                  ),
                  // Padding(padding: EdgeInsets.only(top: 3)),
                  // Text(Repository.iataToCity[train.origin],
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14
                  //   ),
                  // ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('- ${train.arrivalAt.difference(train.departureAt).inHours}h ${train.arrivalAt.difference(train.departureAt).inMinutes % 60}m -',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                    ),
                  ),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(DateFormat('HH:mm').format(train.arrivalAt),
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(DateFormat('dd.MM.yyyy').format(train.arrivalAt),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12
                    ),
                  ),
                  // Padding(padding: EdgeInsets.only(top: 3)),
                  // Text(Repository.iataToCity[train.destination],
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14
                  //   ),
                  // ),
                ],
              ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${Repository.iataToCity[train.origin]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('${Repository.iataToCity[train.destination]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14
                    ),
                  ),
                ],
              ),
            ]
          )
        ],
      ),
    );
  }
}