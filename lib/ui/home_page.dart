import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/city_query.dart';
import 'package:chico_dagua/ui/history_page.dart';
import 'package:chico_dagua/ui/work_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static final DataStuff  ds = DataStuff();
//  static SessionModel sesMod = SessionModel();

  static List hist = [];
  static List city = [];
  static int actCityId = 0;

  @override
  void initState() {
    int trava = 0;
    Map<String, dynamic> mn = Map(); //criamos um mapa <String, dynamic>, dynamic porque tera tipos variados de dados nos valores.
    super.initState();
//    ds.readData().then((data) { //lê os dados do arquivo, como o retorno de "readData()" é um Future, usamos o then.
//      setState(() {
//
//        if(data.isEmpty) { //caso os dados venham vazio.
//          mn = ds.populate();
//          print(mn);
//          mn["\"hasCity\""] = false;
//          mn["\"city\""]["\"cityId\""] = 0;
//
//          actCityId = mn["\"city\""]["\"cityId\""];
//          city.add(mn);
//          trava = 1;
//        }else { //caso os dados tenham vindo, faremos o tratamemto. //POG ALERT!!!
//          city = json.decode(data); //decodificamos os dados, estruturados, e preenchemos a lista _city (é uma lista de mapas).
//          ds.init(city);
//          mn.addAll(city[0]); //como só temos um mapa, add quem está na posição 0 ao mapa.
//
//          sesMod = SessionModel.init(
//                        city.elementAt(0)["\"hasCity\""],
//                        city.elementAt(0)["\"city\""]["\"cityId\""],
//                        city.elementAt(0)["\"cult\""]["\"cultId\""],
//                        city.elementAt(0)["\"cult\""]["\"Ep\""],
//                        city.elementAt(0)["\"irrig\""]["\"q\""],
//                        city.elementAt(0)["\"irrig\""]["\"Eem\""],
//                        city.elementAt(0)["\"irrig\""]["\"El\""]
//                    );
//        }
//        actCityId = mn["\"city\""]["\"cityId\""]; //pegamos o segundo valor, esse é o código da cidade.
//
//        if(mn["\"hasCity\""] == false && trava == 1) { //caso ainda não tenha sido selecionado uma cidade
//          Navigator.pushNamed(context, "chooseCity"); //redirecionamos a tela de seleção.
//        }
//      });
//
//    });

    ds.readData(isHistory: true).then((data) {
      if(data.isEmpty) {
        print("Tá vazio!");
      }else {
        print("Não tá vazio!");
        hist = json.decode(data);
        ds.initHist(hist);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Comfortaa"),
      home: Scaffold(
          drawer: Drawer(
            child: contextMenu(),
            elevation: 30.0,
          ),
          appBar: AppBar(
            title: ScopedModelDescendant<SessionModel>(
              rebuildOnChange: true,
              builder: (context, child, model) {
                return Text(
                  "Chico d'Água - ${model.hasCity}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
            backgroundColor: Colors.lightBlueAccent[400],
            elevation: 50.0,
          ),
          body: WorkPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  static int ordinalDay(int year, int month, int day) { //retorna o dia juliano
    if (month == DateTime.january) {
      return day;
    } else if (month == DateTime.february) {
      return day + 31;
    } else {
      if (isLeapYear(year)) {
        return ordinalDayFromMarchFirst(month, day) + 60;
      } else {
        return ordinalDayFromMarchFirst(month, day) + 59;
      }
    }
  }

  Widget contextMenu() {
    return ScopedModelDescendant<SessionModel>(
      builder: (context, child, model) {
        return Container(
          color: Colors.lightBlueAccent[400],
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 17.0, right: 8.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 38.0, bottom: 20.0),
                    child: ScopedModelDescendant<SessionModel>(
                      builder: (context, child, model) {
                        return Text("${ds.getCityName(model.cityId)}", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),);
                      },
                    ),
                  ),
                ],
              ),
              _contextMenuTiles("Mudar dados", context, CityQuery()),
              _contextMenuTiles("Histórico", context, HistoryPage()),
              Divider(
                color: Colors.white70,
                height: 2.0,
              ),
              ListTile(
                  title: Text("Sobre", style: TextStyle(
                    color: Colors.white,
                  ),),
                  onTap: () {
                    _aboutInfo();
                  }
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _contextMenuTiles(String title, BuildContext context, Widget newPage) {
    return ListTile(
      title: Text("$title", style: TextStyle(
        color: Colors.white,
      ),),
      onTap: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => newPage
            )
        );
      },
    );
  }

  void _aboutInfo() {
    return showAboutDialog(
      context: context,
      applicationName: "Chico d'Água",
      applicationVersion: "v1.1.3",
      applicationIcon: Image.asset("imgs/cda.png", height: 55.0, width: 55.0,),
      children: <Widget>[
        Text("Este app é parte resultante do projeto de extensão \"Chico d'Água\" "
            "desenvolvido na Universidade Federal de Alagoas (UFAL) - "
            "Campus Arapiraca.",
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}