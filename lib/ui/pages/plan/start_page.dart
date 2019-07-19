import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

import 'transport_page.dart';

import '../../widgets/text_fields/rounded_text_field.dart';
import '../../widgets/text_fields/address_autocomplete.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/selects/select_dropdown.dart';

import '../../routes/default_route.dart';

import '../../resources/app_colors.dart';

import '../../dialogs/dialogs.dart';

import '../../formatters/text_formatter.dart';

import '../../../repository/repository.dart';

import '../../../models/api/plan.dart';

class StartPageBloc {

  BehaviorSubject<List<String>> addresses;

  StartPageBloc() {
    addresses = BehaviorSubject<List<String>>.seeded([]);
  }

  void selectFrom(String iata) {
    addresses.sink.add(Repository.iataGraph[iata].map((k) => Repository.iataToCity[k]).toList());
  }

}

class StartPage extends StatefulWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  StartPageBloc bloc;
  SelectBloc fromBLoc;
  SelectBloc toBloc;
  SelectBloc dateBloc;
  SelectBloc durationBloc;
  SelectBloc peopleBloc;
  Plan plan;

  @override
  void initState() {
    super.initState();

    bloc = StartPageBloc();
    plan = Plan();
    plan.origin = 'LED';
    plan.destination = 'HEL';
    plan.days = 4;
    plan.peopleCount = 5;
    plan.date = Repository.dates[0];

    fromBLoc = SelectBloc(
      onChange: (index) {
        final iata = Repository.iataGraph.keys.toList()[index];
        plan.origin = iata;
        bloc.selectFrom(iata);
        plan.destination = null;
        toBloc.clear();
      }
    );

    toBloc = SelectBloc(
      onChange: (index) {
        final iata = Repository.iataGraph[plan.origin][index];
        plan.destination = iata;
      }
    );

    dateBloc = SelectBloc(
      onChange: (index) {
        plan.date = Repository.dates[index];
      }
    );

    durationBloc = SelectBloc(
      onChange: (index) {
        plan.days = index + 3;
      }
    );

    peopleBloc = SelectBloc(
      onChange: (index) {
        plan.peopleCount = index + 1;
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
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(                               
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/build_header.png'),
              ),
            ),
            child: Container(
              //height: height,
              //alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: width * 0.3, right: width * 0.3, top: height * 0.15),
                  child: Column(
                    children: <Widget>[
                      Text('Plan your business trip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      // AddressAutocomplete(
                      //   hintText: 'From',
                      // ),
                      SelectDropdown(
                        title: 'From',
                        bloc: fromBLoc,
                        items: Repository.iataGraph.keys.map((k) => Repository.iataToCity[k]).toList()
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      // AddressAutocomplete(
                      //   hintText: 'To',
                      // ),
                      StreamBuilder(
                        stream: bloc.addresses.stream,
                        builder: (context, AsyncSnapshot<List<String>> snapshot) {
                          return SelectDropdown(
                            title: 'To',
                            bloc: toBloc,
                            items: snapshot.hasData ? snapshot.data : [],
                          );
                        }
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      // RoundedTextField(
                      //   hintText: 'Departure date (dd.mm.yyyy)',
                      //   inputFormatters: [
                      //     MaskedTextInputFormatter(
                      //       mask: 'xx.xx.xxxx',
                      //       separator: '.'
                      //     )
                      //   ]
                      // ),
                      SelectDropdown(
                        title: 'Departure date',
                        bloc: dateBloc,
                        items: List.generate(Repository.dates.length, 
                          (index) {
                            return DateFormat('yyyy-MM-dd').format(Repository.dates[index]);
                          }
                        )
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      // RoundedTextField(
                      //   keyboardType: TextInputType.number,
                      //   hintText: 'Number of people',
                      //   inputFormatters: [
                      //     WhitelistingTextInputFormatter.digitsOnly,
                      //     LengthLimitingTextInputFormatter(2),
                      //   ],
                      // ),
                      SelectDropdown(
                        title: 'How long will be your trip?',
                        bloc: durationBloc,
                        items: List.generate(7, 
                          (index) {
                            return '${index + 3} days';
                          }
                        )
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SelectDropdown(
                        title: 'How many people?',
                        bloc: peopleBloc,
                        items: List.generate(10, 
                          (index) {
                            return '${index + 1} people';
                          }
                        )
                      ),
                      Container(
                        width: width * 0.2,
                        margin: EdgeInsets.only(top: 20),
                        child: MainButton(
                          title: 'FIND ROUTE',
                          onPressed: () {
                            if (plan.isValid()) {
                              Navigator.push(
                                context,
                                DefaultRoute(builder: (context) => TransportPage(plan)),
                              );
                            } else {
                              Dialogs.showMessage(context, 'Error', 'Please, fill all fields', 'OK');
                            }
                          },
                        )
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(top: 20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Checkbox(
                      //         value: true,
                      //         activeColor: AppColors.yellow,
                      //         onChanged: (value) {

                      //         },
                      //       ),
                      //       Text('Show hardcoded example (please, check it \n if something going wrong on live data)',
                      //         style: TextStyle(
                      //           color: Colors.white
                      //         ),
                      //       ),
                      //     ]
                      //   )
                      // )
                    ],
                  )
                ),
              ),
            ),
          )
        ),
      )
    );
  }
}