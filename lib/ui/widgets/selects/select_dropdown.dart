import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import '../shadow_card.dart';

import '../../resources/app_colors.dart';


class SelectBloc {
  final Function(int selected) onChange;

  BehaviorSubject<int> selected;
  BehaviorSubject<bool> dropped;

  SelectBloc({this.onChange, int selected}) {
    this.selected = BehaviorSubject<int>();
    dropped = BehaviorSubject<bool>.seeded(false);
  }

  void select(int index) async {
    selected.sink.add(index);
    if (onChange != null) {
      onChange(selected.value);
    }
  }

  void drop() {
    dropped.sink.add(!dropped.value);
  }

  void clear() {
    selected.sink.add(null);
    dropped.sink.add(false);
  }

  void hide() {
    dropped.sink.add(false);
  }
}

class SelectDropdown extends StatefulWidget {
  final List<String> items;
  final SelectBloc bloc;
  final String title;

  SelectDropdown({this.title, this.bloc, this.items});

  @override
  SelectDropdownState createState() => SelectDropdownState();
}

class SelectDropdownState extends State<SelectDropdown> {
  SelectBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = widget.bloc;
  }

  Widget build(BuildContext context) { 
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            child: ShadowCard(
            padding: EdgeInsets.only(bottom: 10),
              radius: 25.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child:  StreamBuilder(
                  stream: bloc.selected.stream,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Text(snapshot.hasData ? widget.items[snapshot.data] : widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: snapshot.hasData ? Colors.black : Colors.grey
                      )
                    );
                  }
                ),
              )
            ),
            onTap: () {
              bloc.drop();
            },
          ),
          StreamBuilder(
            stream: bloc.dropped.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data) {
                return Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.items.length, 
                      (index) {
                        return InkWell(
                          onTap: () {
                            bloc.select(index);
                            bloc.hide();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),                            
                            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                            child: Text(widget.items[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              ),
                            ),
                          )
                        );
                      }   
                    )
                  ),
                );
              } else {
                return Container(

                );
              }
            }
          )
        ]
      )
    );
  }
}