import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

import '../resources/app_colors.dart';

import '../widgets/buttons/main_button.dart';


class Dialogs {

  static bool showing = false;

  static void hide(BuildContext context) {
    if (showing) {
      showing = false;
      Navigator.pop(context);
    }
  }

  static Future showThemed(BuildContext context, Widget child) async {
    if (!showing) {
      showing = true;
      return showDialog(  
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              showing = false;
              return true;
            },
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: child
                ),
              )
            ),
          );
        }
      );
    }
  }

  static Future showMessage(BuildContext context, String title, String body, String ok, {double width}) async {
    return showThemed(context, 
      Container(
        width: width ?? MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(body,
                        style: TextStyle(
                          height: 1.2,
                          color: Colors.black,
                          fontSize: 18
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                  ]
                )
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                child: Text(ok,
                  style: TextStyle(
                    color: AppColors.orange
                  )
                ),
                onPressed: () {
                  hide(context);
                },
              )
            )
          ]
        )
      )
    );
  }

  static void showLoader(BuildContext context){
    if (!showing) {
      showing = true;
      showDialog(context: context, 
        child: WillPopScope(
          onWillPop: () async {
            showing = false;
            return true;
          },
          child: Container(
            width: MediaQuery.of(context).size.width, 
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(AppColors.yellow)
                  ),
                  FlatButton(
                    onPressed: () {
                      Dialogs.hide(context);
                    },
                    child: Text('CANCEL',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                    )
                  )
                ]
              ),
            )
          )           
        )
      );
    }
  }
}