import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';

import '../shadow_card.dart';

import '../../resources/app_colors.dart';


class RoundedTextField extends StatelessWidget {

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

  RoundedTextField({this.maxLines, this.hintText, this.radius = 5, this.textAlign = TextAlign.left, this.fontSize = 16, this.focusNode, this.controller, this.validator, this.onSaved, this.keyboardType, this.obscureText = false, this.inputFormatters = const []});

  Widget build(BuildContext context) { 
    return ShadowCard(
      padding: EdgeInsets.only(bottom: 10),
      radius: 25.0,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              focusNode: focusNode,
              controller: controller,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
              //validator: validate,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: hintText,
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
            ),
          ]
        )
      ),
    );
  }
}