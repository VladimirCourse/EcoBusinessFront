import 'package:flutter_web/material.dart';

class ShadowCard extends StatelessWidget {

  final double radius;
  final EdgeInsets padding;
  final Widget child;
  final Color color;

  ShadowCard({this.radius = 15, this.color = Colors.white, this.child, this.padding});

  Widget build(BuildContext context) { 
    return Container(
      padding: padding ?? EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
      alignment: Alignment.center,
       child: Container(
        alignment: Alignment.center,
        child: Container(
          child: Container(
            child: child,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: color,
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                spreadRadius: 1.5,
                offset: Offset(0, 3),
                color: Color.fromARGB(25, 0, 0, 0)
              )
            ]
          )
        ),
      ),
    );
  }
}