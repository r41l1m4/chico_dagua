import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    int min = timeIrrig(
        ScopedModel.of<FlowModel>(context).etc,
        // Divide por 100 pois o valor é dado em "cm", e precisamos de um decimal
        // para que seja substituido na equação.
        ScopedModel.of<SessionModel>(context).El / 100,
        ScopedModel.of<SessionModel>(context).Ep / 100,
        ScopedModel.of<SessionModel>(context).Eem / 100,
        ScopedModel.of<SessionModel>(context).q
    );
    String duration = formatTime(min);

    //cria entrada no histórico
    Map entry = entryHistory(DateTime.now().toString(),
        ScopedModel.of<SessionModel>(context).cultName,
        ScopedModel.of<FlowModel>(context).stage,
        min,
        FlowModel.of(context).et0
    );
    ds.history.add(entry);
    ds.saveData(ds.history, isHistory: true);


    Firestore.instance.collection("stats").document().setData(
        {
          'state':SessionModel.of(context).state,
          'city':SessionModel.of(context).city,
          'tempMax':FlowModel.of(context).tempMax,
          'tempMin':FlowModel.of(context).tempMin,
          'ETo':FlowModel.of(context).et0,
          'Kc':FlowModel.of(context).kc
        }
    );

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
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text("ETo -> ${FlowModel.of(context).et0}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
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

  /// Dado o ETc, vazão do equipamento e os parâmetros de distância, retorna a
  /// quantidade de minutos que o equipamento deve permanecer ligado.
  int timeIrrig(double etc, double El, double Ep, double Eem, double q) {
    double pt1 = etc * (El * Ep);
    double pt2 = q * (Ep / Eem);
    double time = ((pt1 / pt2) * 1.10) * 60;
    return time.round();
  }

  /// Recebe a quantidade de tempo em minutos, e retorna uma String com o tempo
  /// em formato légivel para o olho humano.
  /// Ex: 73min => 1 hora e 13 minutos
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

  ///Retorna um mapa com os dados, já organizados, para que seja salvo no histórico
  ///em JSON.
  Map entryHistory(String data, String cult, String stage, int mins, double et0) {
    Map<String, dynamic> mp2 = Map();

    mp2["\"tmStamp\""] = data;
    mp2["\"cult\""] = cult;
    mp2["\"stage\""] = stage;
    mp2["\"mins\""] = mins;
    mp2["\"ETo\""] = et0;

    return mp2;
  }

}

