import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../../models/api/bus.dart';

import '../../../repository/repository.dart';

class BusContainer extends StatelessWidget {

  final Bus bus;

  BusContainer({this.bus});

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
                    Text(bus.price.toStringAsFixed(2) + '\$',
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.black,
                        fontSize: 25
                      ),
                    ),
                    Text(bus.name,
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.green.shade700,
                        fontSize: 20
                      ),
                    )
                  ],
                ),
                Text('per 1 passenger',
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
                  Text(DateFormat('HH:mm').format(bus.departureAt),
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(DateFormat('dd.MM.yyyy').format(bus.departureAt),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('- ${bus.arrivalAt.difference(bus.departureAt).inHours}h ${bus.arrivalAt.difference(bus.departureAt).inMinutes % 60}m -',
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
                  Text(DateFormat('HH:mm').format(bus.arrivalAt),
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(DateFormat('dd.MM.yyyy').format(bus.arrivalAt),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12
                    ),
                  ),
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
                  Text('${Repository.iataToCity[bus.origin]}',
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
                  Text('${Repository.iataToCity[bus.destination]}',
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