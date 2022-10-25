import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Classe reponsável pela exibição do histórico do aplicativo.
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

/// Classe reponsável pela exibição do histórico do aplicativo.
class _HistoryPageState extends State<HistoryPage> {
  static DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico",
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
          }else if(snapshot.data == null || snapshot.data!.length <= 2) {
            return hasNone();
          }else {
            List history = json.decode(snapshot.data!);
            ds.history = history;
            return hasSome(history);
          }
        },
      ),
    );
  }

  ///Retorna um Widget com um texto dizendo que não tem nada, cas não haja registros
  ///no histórico.
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

  ///Retorna um Widget com a lista de Cards de entradas do histórico.
  Widget hasSome(List history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        return histCard(index, history.reversed.elementAt(index));
      },
    );
  }

  ///Retorna um Widget, um Card especificamente, dados determinados parâmetros, isso
  ///é claro, após algumas manipulações nos dados para que seja entendível por
  ///humanos.
  Widget histCard(int index, Map histEntry) {
    //histEntry => {timeStamp, cult, stage, mins, et0}
    DateTime dt = DateTime
        .parse(histEntry.values.elementAt(0)); //converte o tempo em texto para uma
                                              //instancia de DateTime
    String timeFormated = DateFormat("dd-MM-yyyy hh:mm aa").format(dt); //formata a instancia de DateTime

    return Card(
      elevation: 13.0,
      color: Theme.of(context).primaryColor,
      child: Padding(
          padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(timeFormated,
              style: TextStyle(fontFamily: "Comfortaa"),
              textAlign: TextAlign.right,
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              child: Text("${histEntry.values.elementAt(1)} "
                  "- ${histEntry.values.elementAt(2)}",
                style: TextStyle(fontSize: 16.0,
                  fontFamily: "Comfortaa",
                ),
              ),
            ),
            Text("${formatTime(histEntry.values.elementAt(3))}",
              style: TextStyle(color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa"
              ),
              textAlign: TextAlign.left,
            ),
            Text("ETo: ${histEntry.values.elementAt(4)}",
              style: TextStyle(color: Colors.white,
                  fontSize: 17.0,
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


  ///Retorna um string com o tempo em formato legível para humanos.
  ///Ex. dado 63min, irá retornar "1 hora e 3 minutos".
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
    return "";
  }
}
