import 'package:flutter_web/material.dart';


import '../../routes/default_route.dart';

import '../../resources/app_colors.dart';


import '../../../models/api/accomodation.dart';

class AccomodationContainer extends StatelessWidget {

  final double width;
  final double height;

  final Accomodation accomodation;

  AccomodationContainer({this.width, this.height, this.accomodation});

  Widget build(BuildContext context) { 
    return Container(
      child: InkWell(
        onTap: () {
          
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(   
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),                            
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/hotel_room.jpg'),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text(accomodation.name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text('${accomodation.price.toStringAsFixed(2)}${accomodation.currency}',
                    style: TextStyle(
                      fontFamily: 'Roboto-Medium',
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Text('/1 night,',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7)
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, top: 3),
                  child: Text('${accomodation.capacity} people room',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7)
                    ),
                  ),
                ),
              ]
            ),
            Container(
              padding: EdgeInsets.only(left: 15, top: 3, bottom: 10),
              child: Text(accomodation.address,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.7)
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}