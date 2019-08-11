import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico",
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Colors.lightBlueAccent[400],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                setState(() {
                  ds.clearHistory();
                });
              },
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: ds.readData(isHistory: true),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data == null || snapshot.data.length <= 2) {
            return hasNone();
          }else {
            List history = json.decode(snapshot.data);
            return hasSome(history);
          }
        },
      ),
    );
  }

  Widget hasNone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 110.0),
          child:  Text("Nada aqui ainda. :(",
            style: TextStyle(fontFamily: "Comfortaa",
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget hasSome(List history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        return histCard(context, index, history.reversed);
      },
    );
  }

  Widget histCard(BuildContext context, int index, Iterable history) {
    Map act = history.elementAt(index);
    String tmStamp = act.values.elementAt(0); //recebe o tempo em texto
    String cult = act.values.elementAt(1);
    String stage = act.values.elementAt(2);
    int mins = act.values.elementAt(3);

    DateTime dt = DateTime.parse(tmStamp); //converte o tempo em texto para uma
                                            //instancia de DateTime

    String timf = DateFormat("dd-MM-yyyy hh:mm aa").format(dt); //formata a instancia de DateTime
    String minsStr = formatTime(mins); //deixa os minutos legiveis


    return Card(
      elevation: 13.0,
      color: Colors.lightBlueAccent[400],
      child: Padding(
          padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(timf,
              style: TextStyle(fontFamily: "Comfortaa"),
              textAlign: TextAlign.right,
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 3.0),
              child: Text("$cult - $stage",
                style: TextStyle(fontSize: 16.0,
                  fontFamily: "Comfortaa",
                ),
              ),
            ),
            Text("$minsStr",
              style: TextStyle(color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa"
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
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
