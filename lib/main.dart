import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/first_use_page.dart';
import 'package:chico_dagua/ui/session_flow/eto_page.dart';
import 'package:chico_dagua/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(NewOne());
}

/// Classe executada antes de tudo para verificar a existência, e em caso positivo,
/// carregar dos dados no contexto do app, caso não exista ainda, direcionará o
/// usuário a tela de primeiro uso para coleta inicial de dados.
class NewOne extends StatelessWidget {

  static DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Lê os dados do JSON
      future: ds.readData(),
      builder: (context, snapshot) {
        // Se não tem dados ainda, mostra uma tela de carregamento
        if(!snapshot.hasData) {
          print(snapshot.data);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          );
          // Se o JSON tem dados previamente salvos, decodifica-os e carrega as váriaveis do
          // ScopedModel com os dados provenientes do JSON.
        }else if(snapshot.data.length > 2 && (snapshot.data.isNotEmpty || snapshot.data != null)) {
          print(snapshot.data);
          List city = json.decode(snapshot.data);

          return ScopedModel<SessionModel>(
            model: SessionModel.init(
                        city.elementAt(0)["\"hasCity\""],
                        city.elementAt(0)["\"city\""]["\"cityId\""],
                        city.elementAt(0)["\"city\""]["\"cityName\""],
                        city.elementAt(0)["\"city\""]["\"stateName\""],
                        city.elementAt(0)["\"city\""]["\"latitude\""],
                        city.elementAt(0)["\"cult\""]["\"cultId\""],
                        city.elementAt(0)["\"cult\""]["\"cultName\""],
                        double.parse(city.elementAt(0)["\"cult\""]["\"Ep\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"q\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"Eem\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"El\""].toString())
                    ),
            child: ScopedModelDescendant<SessionModel>(
              builder: (context, child, model) {
                return ScopedModel<FlowModel>(
                  model: FlowModel(),
                  child: MaterialApp(
                    home: HomePage(),
                    title: "Chico d'Água",
                    debugShowCheckedModeBanner: false,
                    initialRoute: "/",
                    routes: <String, WidgetBuilder> {
                      "firstUse": (BuildContext context) => FirstUsePage(),
                      "calcETo" : (BuildContext context) => EToPage(),
                    },
                  ),
                );
              },
            ),
          );
          // Se o JSON está vazio, normalmente no primeiro uso, o usuário é encaminhado
          // a tela de primeiro uso onde iremos reunir os dados da cultura e afins.
        }else {
          return ScopedModel<SessionModel>(
            model: SessionModel(),
            child: ScopedModelDescendant<SessionModel>(
              builder: (context, child, model) {
                return ScopedModel<FlowModel>(
                  model: FlowModel(),
                  child: MaterialApp(
                    home: HomePage(),
                    title: "Chico d'Água",
                    debugShowCheckedModeBanner: false,
                    initialRoute: "firstUse",
                    routes: <String, WidgetBuilder> {
                      "firstUse": (BuildContext context) => FirstUsePage(),
                      "calcETo" : (BuildContext context) => EToPage(),
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
