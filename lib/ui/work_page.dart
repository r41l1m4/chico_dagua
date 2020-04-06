import 'package:chico_dagua/ui/session_flow/eto_page.dart';
import 'package:flutter/material.dart';

/// Responsável pelo conteúdo da tela principal do aplicativo.
class WorkPage extends StatefulWidget {
  @override
  _WorkPageState createState() => _WorkPageState();
}

/// Responsável pelo conteúdo da tela principal do aplicativo.
class _WorkPageState extends State<WorkPage> {
  @override
  Widget build(BuildContext context) {
    return start();
  }

  Widget start() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Image.asset("imgs/drops.png",
              width: 120.0,
              height: 120.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Olá, bem vindo(a)!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              "Vamos começar?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          OutlineButton(
            onPressed: () {
              Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondAnimation) => EToPage(),
                  transitionDuration: Duration(milliseconds: 400),
                  transitionsBuilder: (context, animation, secondAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
            },
            child: Text("Vamos lá!"),
            shape: StadiumBorder(),
            splashColor: Colors.white,
            highlightColor: Colors.lightBlueAccent[400],
            borderSide: BorderSide(
                width: 0.2
            ),
          ),
        ],
      ),
    );
  }
}
