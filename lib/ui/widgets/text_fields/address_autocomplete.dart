import 'dart:convert';

import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

import '../shadow_card.dart';

import '../../resources/app_colors.dart';


class AutocompleteBloc {

  BehaviorSubject<List<String>> addresses;
  BehaviorSubject<String> address;

  AutocompleteBloc() {
    addresses = BehaviorSubject<List<String>>.seeded([]);
    address = BehaviorSubject<String>.seeded('');
  }

  void autocomplete(String address) async {
    if (address.isNotEmpty) {
      final url = 'http://localhost:3000/planner/autocomplete?input=${address}';
      final res = await Client().get(Uri.encodeFull(url));
      final places = json.decode(res.body);
      addresses.sink.add(places.map<String>((p) => p['description'].toString()).toList());
    }
  }

  void clear() {
    addresses.sink.add([]);
    address.sink.add('');
  }
}

class AddressAutocomplete extends StatefulWidget {

  final bool obscureText;
  final int maxLines;
  final double fontSize;
  final double radius;
  final String hintText;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String) validator;
  final Function (String) onSaved;
  final List<TextInputFormatter> inputFormatters;

  AddressAutocomplete({this.maxLines, this.hintText, this.radius = 5, this.textAlign = TextAlign.left, this.fontSize = 16, this.focusNode, this.controller, this.validator, this.onSaved, this.keyboardType, this.obscureText = false, this.inputFormatters = const []});

  @override
  AddressAutocompleteState createState() => AddressAutocompleteState();
}


class AddressAutocompleteState extends  State<AddressAutocomplete> {

  TextEditingController controller;
  AutocompleteBloc bloc = AutocompleteBloc();


  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  Widget build(BuildContext context) { 
    return Column(
      children: [
        ShadowCard(
          padding: EdgeInsets.only(bottom: 5),
          radius: 25.0,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              onChanged: (address) {
                bloc.autocomplete(address);
              },
              controller: controller,
              focusNode: widget.focusNode,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
              //validator: validate,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey
                ),
                errorStyle: TextStyle(
                  height: 0.1,
                ),
                focusedBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: Colors.transparent),   
                ),
                enabledBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: Colors.transparent),   
                ),   
                errorBorder: UnderlineInputBorder(   
                  borderSide: BorderSide(color: Colors.transparent),   
                ),   
                focusedErrorBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: Colors.transparent),   
                ),   
              ),
            )
          ),
        ),
        StreamBuilder(
          stream: bloc.addresses.stream,
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            return Column(
              children: List.generate(snapshot.data?.length ?? 0, 
                (index) {
                  return InkWell(
                    onTap: () {
                      controller.text = snapshot.data[index];
                      bloc.clear();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                      color: Colors.white,
                      alignment: Alignment.topLeft,
                      child: Text('${snapshot.data[index]}',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      )
                    )
                  );
                }
              )
            );
          }
        )
      ]
    );
  }
}