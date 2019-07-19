import 'dart:html';

import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

import 'ui/pages/plan/start_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ///ElementStream<MouseEvent> onClick;

  MyApp() {
    // ui.platformViewRegistry.registerViewFactory(
    //   'hello-world-html',
    //   (int viewId) => DivElement()
    //     ..text = 'kek'
    //     ..onClick.listen(
    //       (evt) {
    //         print("kek");
    //       }
    //     )
    // );
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: 100,
//           height: 20,
//           child: TextField(
            
//           ),
//           // child: HtmlView(
//           //   viewType: 'hello-world-html',
//           // )
//         )
//       ), 
//     );
//   }
// }
