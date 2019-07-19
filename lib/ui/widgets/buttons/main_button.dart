import 'package:flutter_web/material.dart';

import '../../resources/app_colors.dart';

class MainButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final List<Color> colors;

  MainButton({this.title, this.onPressed, this.colors = AppColors.mainButtonGradient});

  Widget build(BuildContext context) { 
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              spreadRadius: 1.2,
              offset: Offset(0, 3),
              color: colors.first.withAlpha(110)
            )
          ]
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: colors
              )
            ),
            child: FlatButton(
              onPressed: onPressed,
              color: Colors.transparent,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(title,
                  style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    color: Colors.white,
                    fontSize: 22
                  )        
                ),
              ),
            )
          )
        )
      )
    );
  }
}