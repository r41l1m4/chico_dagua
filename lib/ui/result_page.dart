import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final double etc;

  ResultPage({this.etc});

  @override
  _ResultPageState createState() => _ResultPageState(etc2: etc);
}

class _ResultPageState extends State<ResultPage> {
  double etc2;

  _ResultPageState({this.etc2});

  DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    double q = ds.city.elementAt(0)["\"irrig\""]["\"q\""];
    double eem = (ds.city.elementAt(0)["\"irrig\""]["\"Eem\""]) / 100;
    double el = (ds.city.elementAt(0)["\"irrig\""]["\"El\""]) / 100;
    double ep = (ds.city.elementAt(0)["\"cult\""]["\"Ep\""]) / 100;

    int min = timeIrrig(etc2, el, ep, eem, q);
    String duration = formatTime(min);

    return Scaffold(
      body: Container(
        //alignment: Alignment.center,
        color: Colors.lightBlueAccent[400],
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 30.0, right: 10.0),
              child: Image.asset("imgs/clock2.png",
                height: 100.0,
                width: 100.0,
              )
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Baseado no que você contou, "
                      "o equipamento deve permanecer ligado por:",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 80.0),
              child: Text("$duration",
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                ),
              ),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName("/"));
              },
              child: Text("Voltar à página inicial", style: TextStyle(color: Colors.white),),
              shape: StadiumBorder(),
              color: Color(255),
              borderSide: BorderSide(
                  width: 0.7,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }

  int timeIrrig(double etc, double El, double Ep, double Eem, double q) {
    double pt1 = etc * (El * Ep);
    double pt2 = q * (Ep / Eem);
    double time = ((pt1 / pt2) * 1.10) * 60;
    return time.round();
  }

  String formatTime(int time) {
    int h;
    int min;
    if(time < 60) {
      return "$time minutos";
    }else if(time % 60 == 0) {
      h = time ~/ 60;
      if(h == 1) {
        return "1 hora";
      }else if(h > 1) {
        return "$h horas";
      }
    }else if(time > 60) {
      h = time ~/ 60;
      min = time % 60;
      if(h == 1) {
        return "$h hora e $min minutos";
      }else {
        return "$h horas e $min minutos";
      }
    }
    return null;
  }
}

