import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import 'transfer_page.dart';
import 'accomodation_page.dart';

import '../../widgets/text_fields/rounded_text_field.dart';
import '../../widgets/text_fields/address_autocomplete.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/selects/select_card.dart';
import '../../widgets/containers/flight_container.dart';
import '../../widgets/containers/train_container.dart';
import '../../widgets/containers/bus_container.dart';
import '../../widgets/containers/plan_eco_container.dart';
import '../../widgets/containers/plan_money_container.dart';


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

import '../../../repository/repository.dart';

class TransportPageBloc {

  BehaviorSubject<Plan> plan;
  BehaviorSubject<List<Flight>> flights;
  BehaviorSubject<List<Train>> trains;
  BehaviorSubject<List<Bus>> buses;

  TransportPageBloc(Plan plan) {
    flights = BehaviorSubject<List<Flight>>.seeded([]);
    trains = BehaviorSubject<List<Train>>.seeded([]);
    buses = BehaviorSubject<List<Bus>>.seeded([]);
    this.plan = BehaviorSubject<Plan>.seeded(plan);
  }

  void load() async {
    final flightsLoaded = await Repository.flights(plan.value.origin, plan.value.destination, plan.value.date);
    flights.sink.add(flightsLoaded);
    final trainsLoaded = await Repository.trains(plan.value.origin, plan.value.destination, plan.value.date);
    trains.sink.add(trainsLoaded);    
    final busesLoaded = await Repository.buses(plan.value.origin, plan.value.destination, plan.value.date);
    buses.sink.add(busesLoaded);
  }
  
  void selectTransport(Transport transport) {
    plan.sink.add(plan.value..transport = transport);
  }
}

class TransportPage extends StatefulWidget {
  final Plan plan;
  TransportPage(this.plan);

  @override
  TransportPageState createState() => TransportPageState();
}

class TransportPageState extends State<TransportPage> {

  TransportPageBloc bloc;

  SelectBloc flightsBloc;
  SelectBloc trainsBloc;
  SelectBloc busesBloc;

  @override
  void initState() {
    super.initState();

    bloc = TransportPageBloc(widget.plan);
    bloc.load();

    flightsBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.flights.value[indexes.first]);
        trainsBloc.clear();
        busesBloc.clear();
      }
    );

    trainsBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.trains.value[indexes.first]);
        flightsBloc.clear();
        busesBloc.clear();
      }
    );

    busesBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.buses.value[indexes.first]);
        trainsBloc.clear();
        flightsBloc.clear();
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
                          Text('How do you get there?',
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
                                          StreamBuilder(
                                            stream: bloc.flights.stream,
                                            builder: (context, AsyncSnapshot<List<Flight>> snapshot) {
                                              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 10, bottom: 5),
                                                      child: Text('By plain',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 23
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width * 0.15,
                                                      child: ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: List.generate(snapshot.data.length, 
                                                          (index) {
                                                            return Container(
                                                              width: width * 0.25,
                                                              child: SelectCard(
                                                                bloc: flightsBloc,
                                                                index: index,
                                                                child: FlightContainer(
                                                                  flight: snapshot.data[index]
                                                                )
                                                              )
                                                            );
                                                          }
                                                        )
                                                      ),
                                                    )
                                                  ]
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }
                                          ), 
                                          StreamBuilder(
                                            stream: bloc.trains.stream,
                                            builder: (context, AsyncSnapshot<List<Train>> snapshot) {
                                              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 10, bottom: 5),
                                                      child: Text('By train',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 23
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width * 0.15,
                                                      child: ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: List.generate(snapshot.data.length, 
                                                          (index) {
                                                            return Container(
                                                              width: width * 0.25,
                                                              child: SelectCard(
                                                                bloc: trainsBloc,
                                                                index: index,
                                                                child: TrainContainer(
                                                                  train: snapshot.data[index]
                                                                )
                                                              )
                                                            );
                                                          }
                                                        )
                                                      ),
                                                    )
                                                  ]
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }
                                          ), 
                                          StreamBuilder(
                                            stream: bloc.buses.stream,
                                            builder: (context, AsyncSnapshot<List<Bus>> snapshot) {
                                              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 10, bottom: 5),
                                                      child: Text('By bus',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 23
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width * 0.15,
                                                      child: ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: List.generate(snapshot.data.length, 
                                                          (index) {
                                                            return Container(
                                                              width: width * 0.25,
                                                              child: SelectCard(
                                                                bloc: busesBloc,
                                                                index: index,
                                                                child: BusContainer(
                                                                  bus: snapshot.data[index]
                                                                )
                                                              )
                                                            );
                                                          }
                                                        )
                                                      ),
                                                    )
                                                  ]
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }
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
                          if (bloc.plan.value.transport == null) {
                            Dialogs.showMessage(context, 'Error', 'Please, select the transport', 'OK');
                          } else {
                            Navigator.push(
                              context,
                              DefaultRoute(builder: (context) => AccomodationPage(plan: bloc.plan.value)),
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