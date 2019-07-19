import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../../../models/api/flight.dart';


class FlightContainer extends StatelessWidget {

  final Flight flight;

  FlightContainer({this.flight});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(flight.price.toStringAsFixed(2) + '\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25
                      ),
                    ),
                    Text(flight.name,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 20
                      ),
                    )
                  ],
                ),
                Text('per 1 passenger',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14
                  ),
                ),
              ]
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(DateFormat('hh:mm').format(flight.departureAt),
                    //   style: TextStyle(
                    //     fontSize: 20
                    //   ),
                    // ),
                    // Padding(padding: EdgeInsets.only(top: 3)),
                    Text(flight.origin,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Text(DateFormat('dd.MM.yyyy').format(flight.departureAt),
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
                    Text('0',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2)),
                    Text('changes',
                       style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // Text(DateFormat('hh:mm').format(flight.arrivalAt),
                    //   style: TextStyle(
                    //     fontSize: 20
                    //   ),
                    // ),
                    // Padding(padding: EdgeInsets.only(top: 3)),
                    Text(flight.destination,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Text(DateFormat('dd.MM.yyyy').format(flight.departureAt),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}