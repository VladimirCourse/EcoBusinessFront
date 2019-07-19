import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';

import '../shadow_card.dart';

import '../../resources/app_colors.dart';

enum Mode {one, many}

class SelectBloc {
  final Mode mode;
  final Function(List<int> selected) onChange;

  BehaviorSubject<List<int>> selected;

  SelectBloc({this.onChange, this.mode = Mode.one, List<int> selected = const []}) {
    this.selected = BehaviorSubject<List<int>>.seeded(selected);
  }

  void select(int index) async {
    if (mode == Mode.one) {
      selected.sink.add([index]);
    } else {
      selected.sink.add(selected.value..add(index));
    }
    if (onChange != null) {
      onChange(selected.value);
    }
  }

  void clear() async {
    selected.sink.add([]);
  }
}

class SelectCard extends StatefulWidget {
  
  final double width;
  final double height;
  final int index;
  final EdgeInsets margin;

  final Widget child;

  final SelectBloc bloc;

  SelectCard({this.bloc, this.index, this.width, this.height, this.margin, this.child});

  @override
  SelectCardState createState() => SelectCardState();
}

class SelectCardState extends State<SelectCard> {
  SelectBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = widget.bloc;
  }

  Widget build(BuildContext context) { 
    return Container(
      margin: widget.margin,
      //padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: ShadowCard(
        radius: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: widget.child,
            ),
            InkWell(
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
                ),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    bloc.select(widget.index);
                  },
                  child: StreamBuilder(
                    stream: bloc.selected.stream,
                    builder: (context, AsyncSnapshot<List<int>> snapshot) {
                    return Text('SELECT',
                      style: TextStyle(
                        color: snapshot.hasData && snapshot.data.contains(widget.index) ? Colors.grey : AppColors.orange,
                        fontFamily: 'Roboto-Medium',
                        fontSize: 15
                      ),);
                    }
                  ),
                )
              )
            )
          ],
        ),
      )
    );
  }
}