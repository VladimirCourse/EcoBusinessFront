import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import 'start_page.dart';

import '../../widgets/text_fields/rounded_text_field.dart';
import '../../widgets/text_fields/address_autocomplete.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/selects/select_card.dart';
import '../../widgets/containers/flight_container.dart';
import '../../widgets/containers/train_container.dart';
import '../../widgets/containers/bus_container.dart';
import '../../widgets/containers/plan_eco_container.dart';
import '../../widgets/containers/plan_money_container.dart';
import '../../widgets/containers/car_container.dart';

import '../../widgets/shadow_card.dart';

import '../../routes/default_route.dart';

import '../../resources/app_colors.dart';

import '../../dialogs/dialogs.dart';

import '../../formatters/text_formatter.dart';

import '../../../models/api/flight.dart';
import '../../../models/api/point.dart';
import '../../../models/api/train.dart';
import '../../../models/api/bus.dart';
import '../../../models/api/plan.dart';
import '../../../models/api/car.dart';
import '../../../models/api/transport.dart';
import '../../../models/api/accomodation.dart';

import '../../../repository/repository.dart';


class ResultPage extends StatefulWidget {
  final Plan plan;

  const ResultPage({this.plan});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =  MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      backgroundColor: AppColors.pageBackground,
      body: Container(
        child: Container(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(                               
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/build_header.png'),
              ),
            ),
            child: Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 55),
                      child: Column(
                        children: [
                          Text('Thank you for usage of our service!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          ShadowCard(
                            child: Container(
                              width: width * 0.4,
                              child: Column(
                                children: <Widget>[
                                  PlanMoneyContainer(
                                    width: width,
                                    plan: widget.plan,
                                  ),
                                  PlanEcoContainer(
                                    width: width,
                                    plan: widget.plan,
                                  ),
                                  Container(
                                    width: width * 0.25,
                                    child: MainButton(
                                      title: 'CHECK OUT',
                                      onPressed: () {
                                        Dialogs.showMessage(context, 'Check out', 'Coming soon!', 'PK');
                                      },
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        DefaultRoute(builder: (context) => StartPage()),
                                      );
                                    },
                                    child: Text('Skip to beginning',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.orange
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 15)),
                                ],
                              ),
                            )
                          )
                        ]
                      ),
                    )
                  )
                ]
              )
            ),
          )
        ),
      )
    );
  }
}