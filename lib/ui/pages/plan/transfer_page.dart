import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import 'result_page.dart';

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

enum Status {toTransport, fromTransport}

class TransferPageBloc {
  Status status;
  BehaviorSubject<Plan> plan;
  BehaviorSubject<List<Train>> trains;
  BehaviorSubject<List<Bus>> buses;
  BehaviorSubject<List<Car>> cars;

  TransferPageBloc(Plan plan, this.status) {
    trains = BehaviorSubject<List<Train>>.seeded([]);
    buses = BehaviorSubject<List<Bus>>.seeded([]);
    cars = BehaviorSubject<List<Car>>.seeded([]);
    this.plan = BehaviorSubject<Plan>.seeded(plan);
  }

  void load() async {  
    final carsLoaded = await Repository.carsTransfer(status == Status.toTransport ? plan.value.origin : plan.value.destination);
    for (var car in carsLoaded) {
      if (status == Status.toTransport) {
        car.origin = Repository.cityToPoint[plan.value.origin];
        if (plan.value.transport is Train) {
          car.destination = Repository.trainToPoint[plan.value.origin];
        } else if (plan.value.transport is Bus) {
          car.destination = Repository.cityToPoint[plan.value.origin];
        } else {
          car.destination = Repository.airportToPoint[plan.value.origin];
        }
      } else {
        if (plan.value.transport is Train) {
          car.origin = Repository.trainToPoint[plan.value.destination];
        } else if (plan.value.transport is Bus) {
          car.origin = Repository.cityToPoint[plan.value.destination];
        } else {
          car.origin = Repository.airportToPoint[plan.value.destination];
        }
        car.destination = Point(
          lat: plan.value.accomodation.lat,
          lng: plan.value.accomodation.lng,
          address: plan.value.accomodation.address
        );
      } 
    }
    print(carsLoaded);
    cars.sink.add(carsLoaded);
  }
  
  void selectTransport(Transport transport) {
    if (status == Status.fromTransport) {
      plan.sink.add(plan.value..transitFrom = transport);
    } else {
      plan.sink.add(plan.value..transitTo = transport);
    }
  }
}

class TransferPage extends StatefulWidget {
  final Status status;
  final Plan plan;

  const TransferPage({this.plan, this.status});

  @override
  TransferPageState createState() => TransferPageState();
}

class TransferPageState extends State<TransferPage> {

  TransferPageBloc bloc;

  SelectBloc carsBloc;
  SelectBloc trainsBloc;
  SelectBloc busesBloc;

  @override
  void initState() {
    super.initState();

    bloc = TransferPageBloc(widget.plan, widget.status);
    bloc.load();

    carsBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.cars.value[indexes.first]);
        trainsBloc.clear();
        busesBloc.clear();
      }
    );

    trainsBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.trains.value[indexes.first]);
        carsBloc.clear();
        busesBloc.clear();
      }
    );

    busesBloc = SelectBloc(
      onChange: (List<int> indexes) {
        bloc.selectTransport(bloc.buses.value[indexes.first]);
        trainsBloc.clear();
        carsBloc.clear();
      }
    );
  }

  String transportName(Transport transport) {
    if (transport is Flight) {
      return 'airport';
    } else if (transport is Bus) {
      return 'bus station';
    } else if (transport is Train) {
      return 'railway station';
    } else {
      return '';
    }
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
                          Text(widget.status == Status.toTransport ? 'Transfer to ${transportName(bloc.plan.value.transport)}' : 'Transfer to accomodation',
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
                                  child:  Container(
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
                                            stream: bloc.cars.stream,
                                            builder: (context, AsyncSnapshot<List<Car>> snapshot) {
                                              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 10, bottom: 5),
                                                      child: Text('By taxi',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 23
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width * 0.16,
                                                      child: ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: List.generate(snapshot.data.length, 
                                                          (index) {
                                                            return Container(
                                                              width: width * 0.25,
                                                              child: SelectCard(
                                                                bloc: carsBloc,
                                                                index: index,
                                                                child: CarContainer(
                                                                  car: snapshot.data[index]
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
                        title: widget.status == Status.toTransport ? 'NEXT' : 'FINISH!',
                        onPressed: () {
                          if (widget.status == Status.toTransport) {
                            Navigator.push(
                              context,
                              DefaultRoute(builder: (context) => TransferPage(plan: bloc.plan.value, status: Status.fromTransport)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              DefaultRoute(builder: (context) => ResultPage(plan: bloc.plan.value)),
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