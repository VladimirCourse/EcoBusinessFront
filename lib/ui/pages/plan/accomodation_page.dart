import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import 'transfer_page.dart';

import '../../widgets/text_fields/rounded_text_field.dart';
import '../../widgets/text_fields/address_autocomplete.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/selects/select_card.dart';
import '../../widgets/containers/flight_container.dart';
import '../../widgets/containers/train_container.dart';
import '../../widgets/containers/bus_container.dart';
import '../../widgets/containers/plan_eco_container.dart';
import '../../widgets/containers/plan_money_container.dart';
import '../../widgets/containers/accomodation_container.dart';

import '../../widgets/shadow_card.dart';

import '../../routes/default_route.dart';

import '../../resources/app_colors.dart';

import '../../dialogs/dialogs.dart';

import '../../formatters/text_formatter.dart';

import '../../../models/api/flight.dart';
import '../../../models/api/airport.dart';
import '../../../models/api/train.dart';
import '../../../models/api/bus.dart';
import '../../../models/api/plan.dart';
import '../../../models/api/transport.dart';
import '../../../models/api/accomodation.dart';

import '../../../repository/repository.dart';

class AccomodationPageBloc {
  BehaviorSubject<Plan> plan;
  BehaviorSubject<List<Accomodation>> hotels;

  AccomodationPageBloc(Plan plan) {
    hotels = BehaviorSubject<List<Accomodation>>.seeded([]);
    this.plan = BehaviorSubject<Plan>.seeded(plan);
  }

  void load() async {
    final hotelsLoaded = await Repository.hotels(plan.value.destination, plan.value.date);
    hotels.sink.add(hotelsLoaded);
  }
  
  void selectAccomodation(Accomodation accomodation) {
    plan.sink.add(plan.value..accomodation = accomodation);
  }
}


class AccomodationPage extends StatefulWidget {
  final Plan plan;
  AccomodationPage({this.plan});

  @override
  AccomodationPageState createState() => AccomodationPageState();
}

class AccomodationPageState extends State<AccomodationPage> {
  AccomodationPageBloc bloc;

  SelectBloc hotelsBloc;

  @override
  void initState() {
    super.initState();

    bloc = AccomodationPageBloc(widget.plan);
    bloc.load();

    hotelsBloc = SelectBloc( 
      onChange: (List<int> indexes) {
        bloc.selectAccomodation(bloc.hotels.value[indexes.first]);
      }
    );
  }

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
                          Text('Accomodation in ${Repository.iataToCity[widget.plan.destination]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShadowCard(
                                  color: AppColors.pageBackground,
                                  child: Container(
                                    width: width * 0.3,
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 10, bottom: 5),
                                          child: Text('Information',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 23
                                            ),
                                          ),
                                        ),
                                        Container(                                          
                                          child: ShadowCard(
                                            radius: 10,
                                            child: StreamBuilder(
                                              stream: bloc.plan.stream,
                                              builder: (context, AsyncSnapshot<Plan> snapshot) {
                                                if (snapshot.hasData) {
                                                  return PlanEcoContainer(
                                                    width: width,
                                                    plan: snapshot.data,
                                                  );
                                                } else {
                                                   return PlanEcoContainer(
                                                    width: width,
                                                    plan: Plan(),
                                                  );
                                                }
                                              }
                                            )
                                          )
                                        ),
                                        Container(                                          
                                          child: ShadowCard(
                                            radius: 10,
                                            child: StreamBuilder(
                                              stream: bloc.plan.stream,
                                              builder: (context, AsyncSnapshot<Plan> snapshot) {
                                                if (snapshot.hasData) {
                                                  return PlanMoneyContainer(
                                                    width: width,
                                                    plan: snapshot.data,
                                                  );
                                                } else {
                                                   return PlanMoneyContainer(
                                                    width: width,
                                                    plan: Plan(),
                                                  );
                                                }
                                              }
                                            )
                                          )
                                        ),
                                      ]
                                    )
                                  )
                                ),
                                Expanded(
                                  child: ShadowCard(
                                    color: AppColors.pageBackground,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 10, top: 10),
                                            child: Text('Hotels',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23
                                              ),
                                            ),
                                          ),
                                         Container(
                                            height: width * 0.22,
                                            child: StreamBuilder(
                                              stream: bloc.hotels.stream,
                                              builder: (context, AsyncSnapshot<List<Accomodation>> snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView(
                                                    scrollDirection: Axis.horizontal,
                                                    children: List.generate(snapshot.data.length, 
                                                      (index) {
                                                        return Container(
                                                          width: width * 0.25,
                                                          child: SelectCard(
                                                            bloc: hotelsBloc,
                                                            index: index,
                                                            child: AccomodationContainer(
                                                              accomodation: snapshot.data[index]
                                                            )
                                                          )
                                                        );
                                                      }
                                                    )
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }
                                            ), 
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                )
                              ]
                            )
                          )
                        ]
                      )
                    )
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: width * 0.2,
                      margin: EdgeInsets.only(bottom: 5),
                      child: MainButton(
                        title: 'NEXT',
                        onPressed: () {
                          if (bloc.plan.value.accomodation == null) {
                            Dialogs.showMessage(context, 'Error', 'Please, select where you will be living', 'OK');
                          } else {
                            Navigator.push(
                              context,
                              DefaultRoute(builder: (context) => TransferPage(plan: bloc.plan.value, status: Status.toTransport)),
                            );
                          }
                        },
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