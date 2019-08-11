import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ResultPage extends StatefulWidget {

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {

    double q = ScopedModel.of<SessionModel>(context).q;
    double eem = ScopedModel.of<SessionModel>(context).Eem / 100;
    double el = ScopedModel.of<SessionModel>(context).El / 100;
    double ep = ScopedModel.of<SessionModel>(context).Ep / 100;
    String cult = ds.getCultName(ScopedModel.of<SessionModel>(context).cultId);
    String stage = ScopedModel.of<FlowModel>(context).stage;

    int min = timeIrrig(ScopedModel.of<FlowModel>(context).etc, el, ep, eem, q);
    String duration = formatTime(min);

    //cria entrada no histórico
    Map entry = entryHistory(DateTime.now().toString(), cult, stage, min);
    ds.history.add(entry);
    ds.saveData(ds.history, isHistory: true);

    return Scaffold(
      body: Container(
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
                Navigator.of(context).pop();
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

  Map entryHistory(String data, String cult, String stage, int mins) {
    Map<String, dynamic> mp2 = Map();

    mp2["\"tmStamp\""] = data;
    mp2["\"cult\""] = cult;
    mp2["\"stage\""] = stage;
    mp2["\"mins\""] = mins;

    return mp2;
  }

}

